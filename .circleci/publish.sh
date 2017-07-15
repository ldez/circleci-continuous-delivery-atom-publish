#!/usr/bin/env bash

set -e

## Custom variables
USER_EMAIL="lfernandez.dev@gmail.com"
USER_NAME="Ludovic Fernandez"
PUBLISH_TYPE=${PUBLISH_TYPE:="patch"}
SSH_KEY_NAME="circleci_rsa"

encrypted_key="secret"

# FIXME cd "$TRAVIS_BUILD_DIR"
pwd

## Prevent publish on tags
CURRENT_TAG=$(git tag --contains HEAD)

if  [ -z "${STOP_PUBLISH}" ] && [ "$CIRCLE_BRANCH" = "$AUTHORIZED_BRANCH" ] && [ -z "$CURRENT_TAG" ] && [ -z "$CI_PULL_REQUEST" ]
then
  echo 'Publishing...'
else
  echo 'Skipping publishing'
  exit 0
fi

## Git configuration
git config --global user.email "${USER_EMAIL}"
git config --global user.name "${USER_NAME}"

## Repository URL
GIT_REPOSITORY=$(git config remote.origin.url)
GIT_REPOSITORY=${GIT_REPOSITORY/git:\/\/github.com\//git@github.com:}
GIT_REPOSITORY=${GIT_REPOSITORY/https:\/\/github.com\//git@github.com:}

## Loading SSH key
echo "Loading key..."
openssl aes-256-cbc  -d -k "$encrypted_key" -in .circleci/${SSH_KEY_NAME}.enc -out ~/.ssh/${SSH_KEY_NAME}
eval "$(ssh-agent -s)"
chmod 600 ~/.ssh/${SSH_KEY_NAME}
ssh-add ~/.ssh/${SSH_KEY_NAME}

## Change origin url to use SSH
git remote set-url origin ${GIT_REPOSITORY}

## Force checkout master branch (because CircleCI uses a detached head)
git checkout ${AUTHORIZED_BRANCH}

## Simulate a publish action (only for testing purpose)
echo "$CIRCLE_BUILD_NUM" > "${CIRCLE_SHA1}.txt"
git add .
# NOTE: Circle automatically skips the build if the commit contains [skip ci]
git commit -q -m "Prepare 0.0.${CIRCLE_BUILD_NUM} release [ci skip]"
git tag -a -m "circle-script-tag ${PUBLISH_TYPE}" "v0.0.${CIRCLE_BUILD_NUM}"
git push --follow-tags origin master

git log --oneline --graph --decorate
