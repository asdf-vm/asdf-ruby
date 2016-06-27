# asdf-ruby

[![Build Status](https://travis-ci.org/asdf-vm/asdf-ruby.svg?branch=master)](https://travis-ci.org/asdf-vm/asdf-ruby)

Ruby plugin for [asdf](https://github.com/asdf-vm/asdf) version manager

## Install

```
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
```

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Ruby.

When installing Ruby using `asdf install`, you can pass custom configure options with the following env vars:

* `RUBY_CONFIGURE_OPTIONS` - use only your configure options
* `RUBY_EXTRA_CONFIGURE_OPTIONS` - append these configure options along with ones that this plugin already uses

## Migrating from another Ruby version manager

### `.ruby-version` file

asdf uses the `.tool-versions` for auto-switching between software versions.
To ease migration, you can you have it read an existing `.ruby-version` file to
find out what version of Ruby should be used. To do this, add the following to
`$HOME/.asdfrc`:

    legacy_version_file = yes

### Rubies

asdf installs Rubies to `$HOME/.asdf/installs/ruby`, the directory structure is
the same as other version managers, so you can just move the Rubies to this
directory:

#### RVM

    mkdir ~/.asdf/installs/
    mv ~/.rvm/rubies ~/.asdf/installs/ruby/

#### rbenv

    mkdir ~/.asdf/installs/
    mv ~/.rbenv/versions ~/.asdf/installs/ruby/

#### chruby

    mkdir ~/.asdf/installs/
    mv ~/.rubies ~/.asdf/installs/ruby/
