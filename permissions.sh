#!/usr/local/bin/bash

################################################################################
### NZBGET POST-PROCESSING SCRIPT                                            ###

# Change user:group ownership and folder/file permission.

################################################################################
### OPTIONS                                                                  ###

# Set owner and group (yes, no).
setowner=no

# Put user here.
user=user

# Put group here.
group=group

# Set folder and file permissions (yes, no).
setmode=no

# Put file mode here.
mode=664

# Put folder mode here.
dirmode=775

### NZBGET POST-PROCESSING SCRIPT                                            ###
################################################################################


# Exit codes
#POSTPROCESS_PARCHECK=92
#POSTPROCESS_SUCCESS=93
POSTPROCESS_ERROR=94
#POSTPROCESS_NONE=95

POSTPROCESS=95

# Check if the script is called from nzbget 11.0 or later
if [[ "${NZBOP_SCRIPTDIR}" = "" ]]; then
  echo "*** NZBGet post-processing script ***"
  echo "This script is supposed to be called from nzbget (11.0 or later)."
  exit ${POSTPROCESS_ERROR}
fi

if [[ "${NZBPO_USER}" = "user" ]] || [[ "${NZBPO_GROUP}" = "group" ]]; then
  echo "*** NZBGet post-processing script ***"
  echo "[WARN] The user and group are set to defaults, check script settings."
  exit ${POSTPROCESS_ERROR}
fi

# Check if directory exists
if [[ -d "${NZBPP_DIRECTORY}" ]]; then
  # chown
  if [[ "${NZBPO_SETOWNER}" = "yes" ]]; then
    if chown -R "${NZBPO_USER}:${NZBPO_GROUP}" "${NZBPP_DIRECTORY}"; then
      echo "[INFO] User and group set"
      POSTPROCESS=93
    else
      echo "[WARN] User and group NOT set"
      exit ${POSTPROCESS_ERROR}
    fi
  fi

  # chmod
  if [[ "${NZBPO_SETMODE}" = "yes" ]]; then
    # recursively set perms on files
    if find "${NZBPP_DIRECTORY}" -type f -exec chmod "${NZBPO_MODE}" '{}' ';'; then
      echo "[INFO] File permissions set"
      POSTPROCESS=93
    else
      echo "[WARN] File permissions NOT set"
      exit ${POSTPROCESS_ERROR}
    fi

    # recursively set perms on folders
    if find "${NZBPP_DIRECTORY}" -type d -exec chmod "${NZBPO_DIRMODE}" '{}' ';'; then
      echo "[INFO] Folder permissions set"
      POSTPROCESS=93
    else
      echo "[WARN] Folder permissions NOT set"
      exit ${POSTPROCESS_ERROR}
    fi
  fi
else
  echo "[WARN] Directory not found"
  echo "[DETAIL] $NZBPP_DIRECTORY"
  exit ${POSTPROCESS}
fi

exit ${POSTPROCESS}
