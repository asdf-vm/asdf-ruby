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

You may also apply custom patches before building with `RUBY_APPLY_PATCHES`, e.g.

```
RUBY_APPLY_PATCHES=$'dir/1.patch\n2.patch\nhttp://example.com/3.patch' asdf install ruby 2.4.1
RUBY_APPLY_PATCHES=$(curl -s https://raw.githubusercontent.com/rvm/rvm/master/patchsets/ruby/2.1.1/railsexpress) asdf install ruby 2.1.1
```

## Default gems

asdf-ruby can automatically install a set of default gems right after
installing a Ruby version. To enable this feature, provide a
`$HOME/.default-gems` file that lists one gem per line, for example:

```
bundler
pry
gem-ctags
```

## Migrating from another Ruby version manager

### `.ruby-version` file

asdf uses the `.tool-versions` for auto-switching between software versions.
To ease migration, you can have it read an existing `.ruby-version` file to
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
    mv -T ~/.rbenv/versions ~/.asdf/installs/ruby/

#### chruby

    mkdir ~/.asdf/installs/
    mv ~/.rubies ~/.asdf/installs/ruby/
