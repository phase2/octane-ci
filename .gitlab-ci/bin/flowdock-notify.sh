#!/usr/bin/env bash
# Send a notification to Flowdock room.
# Requires FLOWDOCK_API_TOKEN to be set.
# Usage:
#   To send a message to the Inbox of a flow, use:
#     flowdock-notify.sh inbox SUBJECT BODY
#   To send a message to the main window of a flow, use:
#     flowdock-notify.sh MESSAGE
# When using inbox, SUBJECT and BODY cannot contain any emoji or html.

# FROM_USER cannot contain spaces
FROM_USER="GitlabAutomation"
FROM_ADDRESS="GitLab@gitlab.com"
TAG="ci"

if [ ! -z "${FLOWDOCK_API_TOKEN}" ]; then
  if [ "$1" == 'inbox' ]; then
    shift
    SUBJECT=$1;
    shift
    if [[ -z ${SUBJECT} || -z ${@} ]]; then
      echo "Inbox requires subject and body: $0 inbox SUBJECT BODY"
      exit
    fi
    # Visit https://www.flowdock.com/account/tokens for the flow API token.
    # Note that the external_user_name can not contain spaces
    curl "https://api.flowdock.com/v1/messages/team_inbox/$FLOWDOCK_API_TOKEN" \
      -H 'Content-Type: application/json' \
      -d "{\"content\": \"$@\", \"subject\": \"${SUBJECT}\", \"from_address\": \"${FROM_ADDRESS}\", \"source\": \"${FROM_USER}\", \"external_user_name\": \"${FROM_USER}\", \"tags\": [\"${TAG}\"]}"
  else
    curl "https://api.flowdock.com/v1/messages/chat/$FLOWDOCK_API_TOKEN" \
      -H 'Content-Type: application/json' \
      -d "{\"content\": \"$@\", \"external_user_name\": \"${FROM_USER}\", \"tags\": [\"${TAG}\"]}"
  fi
else
  echo "FLOWDOCK_API_TOKEN not defined, skipping notification"
  echo "Set FLOWDOCK_API_TOKEN in the CI/CD settings to enable notifications"
  echo "Visit https://www.flowdock.com/account/tokens for the flow API token"
fi
