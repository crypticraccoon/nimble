package api

import (
	"encoding/base64"
	"net/http"
	"os"
	cerror "server/internal/errors"
	"server/internal/response"
	"strconv"

	"github.com/go-chi/chi/v5"
	"github.com/gofrs/uuid"
)

func (a *Api) verifyRegistrationEmail(w http.ResponseWriter, r *http.Request) {
	verificationCode, err := strconv.Atoi(chi.URLParam(r, "code"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}
	id := uuid.FromStringOrNil(chi.URLParam(r, "id"))
	if id == uuid.Nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), cerror.ERR_API_MALFORMED_DATA)
		return
	}

	exists, err := a.database.VerifyUserEmail(a.context, id, verificationCode)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_VERIFICATION_FAILED.Error(), err)
		return
	}

	if !exists {
		response.WithError(w, http.StatusNotFound, cerror.ERR_DB_USER_MISSING.Error(), cerror.ERR_DB_USER_MISSING)
		return
	}

	registrationVerificationLink := os.Getenv("REGISTER_VERIFICATION_REDIRECT") + "/" + id.String() + "/" + strconv.FormatInt(int64(verificationCode), 10)

	response.WithRedirect(w, r, registrationVerificationLink)
}

func (a *Api) verifyRecoveryEmail(w http.ResponseWriter, r *http.Request) {
	verificationCode, err := strconv.Atoi(chi.URLParam(r, "code"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}
	email, err := base64.URLEncoding.DecodeString(chi.URLParam(r, "email"))
	if err != nil {
		response.WithError(w, http.StatusBadRequest, cerror.ERR_API_MALFORMED_DATA.Error(), err)
		return
	}

	exists, err := a.database.VerifyRecoveryEmail(a.context, string(email), verificationCode)
	if err != nil {
		response.WithError(w, http.StatusInternalServerError, cerror.ERR_API_VERIFICATION_FAILED.Error(), err)
		return
	}

	if !exists {
		response.WithError(w, http.StatusNotFound, cerror.ERR_DB_USER_MISSING.Error(), cerror.ERR_DB_USER_MISSING)
		return
	}

	registrationVerificationLink := os.Getenv("RECOVERY_VERIFICATION_REDIRECT") + "/" + chi.URLParam(r, "email") + "/" + strconv.FormatInt(int64(verificationCode), 10)

	response.WithRedirect(w, r, registrationVerificationLink)
}
