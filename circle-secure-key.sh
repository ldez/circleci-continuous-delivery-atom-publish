#!/bin/sh
set -e

## Here, you will need to replace <org@email>, <somewhere>, <encrypted_key>
USER_EMAIL="lfernandez.dev@gmail.com"
# USER_EMAIL='<org@email>'
PROJECT_DIRECTORY='/home/ldez/sources/ldez/travis/circleci-continuous-delivery-atom-publish'
# PROJECT_DIRECTORY='<somewhere>'
readonly SSH_KEY_NAME='circleci_rsa'

## Generate SSH key if necessary.
generateKey() {

  cd ${PROJECT_DIRECTORY}
  mkdir -p .circleci

  if [ ! -e ~/.ssh/${SSH_KEY_NAME} ]; then
    ## First you create a RSA public/private key pair just for CircleCI.
    ssh-keygen -t rsa -C "${USER_EMAIL}" -f ~/.circleci/${SSH_KEY_NAME}
  else
    echo "SSH key ${SSH_KEY_NAME} already exists"
  fi

  ## Copy to clipboard.
  ## https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account
  xclip -sel clip < ~/.ssh/${SSH_KEY_NAME}.pub

  echo 'The public SSH key has been copied into the clipboard.'
  echo 'Go on https://github.com/:user/:repo/settings/keys.'
  echo '* Paste your key into the "Key" field.'
  echo '* Click "Add key".'
  echo '* Confirm the action by entering your GitHub password.'
}

#################
## Main Action ##
#################

## Generate SSH key if necessary.
generateKey
