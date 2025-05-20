package api

import (
	"encoding/json"
	"errors"
	"net/http"
	"os"
	cerror "server/internal/errors"
	"server/internal/mailer"
	"server/internal/models"
	"server/internal/response"
	"strconv"

	"github.com/gofrs/uuid"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

const (
	EMAIL_VERIFICATION_LINK_SENT = "An verification link was sent to your email."
)

func (a *Api) register(w http.ResponseWriter, r *http.Request) {
	data := models.Register{}

	err := json.NewDecoder(r.Body).Decode(&data)

	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	isEmpty := data.IsEmpty()
	if isEmpty {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_PAYLOAD_EMPTY.Error(), cerror.ERR_PAYLOAD_EMPTY)
		return
	}

	if isValidEmail := data.IsValidEmail(); !isValidEmail {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_EMAIL.Error(), cerror.ERR_API_MALFORMED_EMAIL)
		return
	}

	newUser, err := models.NewUser(a.context, data.Email, data.Password)
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_FAILED_TO_CREATE_USER.Error(), err)
		return
	}

	if err = a.database.RegisterUser(a.context, *newUser); err != nil {

		if errors.Is(err, cerror.ERR_DB_USER_EXISTS) {
			response.WithError(w, http.StatusConflict, err.Error(), err)
			return
		} else {
			println(err.Error())
			response.WithError(w, http.StatusConflict, cerror.ERR_DB_TX_FAILED.Error(), err)
			return
		}
	}

	serverUrl := os.Getenv("SERVER_URL")
	redirectLink := serverUrl + "/register/verify/" + newUser.Id.String() + "/" + strconv.FormatInt(int64(newUser.VerificationCode), 10)

	if mailer.Mail.IsEnabled() {
		if err = mailer.Mail.SendEmailVerificationLink(a.context, redirectLink, newUser.Email); err != nil {
			if err := a.database.DeleteUser(a.context, newUser.Id); err != nil {
				response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_FAILED_TO_CREATE_USER.Error(), err)
				return
			}
		}
	} else {
		redirectLink := "http://localhost:3000/v1/register/verify/" + newUser.Id.String() + "/" + strconv.FormatInt(int64(newUser.VerificationCode), 10)
		println("Run the following to verify user registration.")
		println(`curl --request GET --url ` + redirectLink + ` --header 'Content-Type: application/json' `)
	}

	response.WithJson(w, EMAIL_VERIFICATION_LINK_SENT)
}

func (a *Api) login(w http.ResponseWriter, r *http.Request) {
	data := models.Login{}
	if err := json.NewDecoder(r.Body).Decode(&data); err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	if valid := data.Check(); !valid {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return

	}

	userData, err := a.database.GetUserByCredentials(a.context, &data)
	if err != nil {
		response.WithError(w, http.StatusUnauthorized, cerror.ERR_API_INVALID_CREDENTIALS.Error(), err)
		return
	}

	if bcrypt.CompareHashAndPassword([]byte(userData.Password), []byte(data.Password)) != nil {
		response.WithError(w, http.StatusUnauthorized, cerror.ERR_API_INVALID_CREDENTIALS.Error(), cerror.ERR_API_INVALID_CREDENTIALS)
		return
	}

	if !userData.IsVerified {
		response.WithError(w, http.StatusUnauthorized, cerror.ERR_API_USER_NOT_VERIFIED.Error(), cerror.ERR_API_USER_NOT_VERIFIED)
		return
	}

	jwtH := models.Jwt{}

	accessToken, err := jwtH.GenerateAccessToken(userData.Id)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGIN_FAILED.Error(), err)
		return
	}

	refreshToken, err := jwtH.GenerateRefreshToken(userData.Id)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGIN_FAILED.Error(), err)
		return
	}

	if err = a.database.UpdateRefreshToken(a.context, userData.Id, refreshToken); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGIN_FAILED.Error(), err)
		return
	}

	res := models.LoginResponse{
		Id: userData.Id,
		TokenData: models.TokenPair{
			AccessToken:  accessToken,
			RefreshToken: refreshToken,
		},
	}

	response.WithJson(w, res)
}

func (a *Api) logout(w http.ResponseWriter, r *http.Request) {
	userId := uuid.FromStringOrNil(r.Context().Value("userID").(string))

	if err := a.database.RemoveRefreshToken(a.context, userId); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGOUT_FAILED.Error(), err)
		return
	}

	response.WithJson(w, "")
}

func (a *Api) refresh(w http.ResponseWriter, r *http.Request) {
	data := models.RefreshToken{}
	if err := json.NewDecoder(r.Body).Decode(&data); err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	refreshSecretKey := []byte(os.Getenv("REFRESH_SECRET_KEY"))

	token, err := jwt.ParseWithClaims(data.RefreshToken, &models.Claims{}, func(token *jwt.Token) (any, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, cerror.ERR_API_INVALID_TOKEN
		}
		return refreshSecretKey, nil
	})

	if err != nil {
		response.WithError(w, http.StatusUnauthorized, cerror.ERR_API_INVALID_TOKEN.Error(), err)
		return
	}

	claims, ok := token.Claims.(*models.Claims)
	if !ok || !token.Valid {
		response.WithError(w, http.StatusUnauthorized, cerror.ERR_API_INVALID_TOKEN.Error(), err)
		return
	}

	refreshToken, err := a.database.GetRefreshToken(a.context, claims.UserID)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_TOKEN_REFRESH_FAILED.Error(), err)
		return
	}
	if refreshToken != data.RefreshToken {
		response.WithError(w, http.StatusUnauthorized, cerror.ERR_API_INVALID_TOKEN.Error(), err)
		return
	}

	jwtH := models.Jwt{}
	newAccessToken, err := jwtH.GenerateAccessToken(claims.UserID)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_TOKEN_REFRESH_FAILED.Error(), err)
		return
	}

	newRefreshToken, err := jwtH.GenerateRefreshToken(claims.UserID)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_TOKEN_REFRESH_FAILED.Error(), err)
		return
	}
	if err = a.database.UpdateRefreshToken(a.context, claims.UserID, newRefreshToken); err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_LOGIN_FAILED.Error(), err)
		return
	}

	res := models.TokenPair{
		AccessToken:  newAccessToken,
		RefreshToken: newRefreshToken,
	}
	response.WithJson(w, res)
}
