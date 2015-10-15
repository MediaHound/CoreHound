
# Setup

To have a consistent development environment, it's best for contributors to have a consistent ruby version and ruby tools.

Follow the steps to setup your ruby environment to work on this iOS project.

## Install Homebrew

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## Install rbenv and ruby-build

```
brew update
brew install rbenv ruby-build
```

## Add to your .zshrc:

```
eval "$(rbenv init -)"
```

## Close and reopen your shell.

## Install a ruby

```
rbenv install 2.2.2
rbenv rehash
```

## (Skip) To create a local ruby:

```
rbenv local 2.2.2
```

## Install rbenv-binstubs plugin

```
mkdir -p ~/.rbenv/plugins
git clone https://github.com/ianheggie/rbenv-binstubs.git ~/.rbenv/plugins/rbenv-binstubs
```

## Update gems on your new ruby:

```
gem update --system
```

## Install bundler:

```
gem install bundler
rbenv rehash
```

## Bundle install our gemfile:

```
bundle install --binstubs
rbenv rehash
```

You should now have the correct ruby installed, with all of the gems we use.

Whenever you move into this directory, your `ruby` will be mapped to the correct version. Executing any of the needed gems will use the correct versions as well.

As an example:

```
rbenv which pod
pod --version # will use the locally installed pod
```
