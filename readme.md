# Circle CI continuous delivery

[![Build Status](https://circleci.com/gh/ldez/circleci-continuous-delivery-atom-publish/tree/master.svg?style=svg)](https://circleci.com/gh/ldez/circleci-continuous-delivery-atom-publish/tree/master)

This project explains how to manipulate a Git repository within [Circle CI](https://circleci.com/) to publish a tag.

Mainly for simulate the release of an Atom package.


## SSH way

### Generating SSH keys

See [circle-secure-key.sh](circle-secure-key.sh)

[Adding a new SSH key to your GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

In this case you can assume to don't define a passphrase for the SSH key.

### Add SSH key to CircleCI

Go to https://circleci.com/gh/:user/:repo/edit#ssh (ex: https://circleci.com/gh/ldez/circleci-continuous-delivery-atom-publish/edit#ssh)

Click on the button `Add SSH key` and:
- hostname: `github.com`
- add your **private** key.

### Add SSH key to GitHub

Go to https://github.com/:user/:repo/settings/keys (ex: https://github.com/ldez/circleci-continuous-delivery-atom-publish/settings/keys)

Click on the button `Add deploy key` and:
- add your **public** key.
- check `Allow write access`

### Publish

See [publish.sh](.travis/publish.sh)

## Skip Build

### Circle CI

Circle automatically skips the build if the commit contains `[ci skip]` or `[skip ci]`.

- https://circleci.com/docs/1.0/skip-a-build/

Example:

```shell
git commit -m 'My commit message [ci skip]'
```

### AppVeyor

AppVeyor automatically skips the build if the commit contains `[ci skip]` or `[skip ci]` or `[skip appveyor]`.

AppVeyor can use a commits filter defined in `appveyor.yml` : `skip_commits:`

- https://www.appveyor.com/docs/how-to/skip-build

Examples:

```shell
git commit -m 'My commit message [ci skip]'
```

```yml
skip_commits:

  # Regex for matching commit message
  message: /Created.*\.(png|jpg|jpeg|bmp|gif)/

  # Commit author's username, name, email or regexp maching one of these.
  author: John
```
