# asdf-ruby

[![Build Status](https://travis-ci.org/asdf-vm/asdf-ruby.svg?branch=master)](https://travis-ci.org/asdf-vm/asdf-ruby)

Ruby plugin for [asdf](https://github.com/asdf-vm/asdf) version manager

## Install

```
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
```

Please make sure you have the required [system dependencies](https://github.com/postmodern/ruby-install#requirements) installed before trying to install Ruby.

By default, asdf-ruby will try to rely as much as it can on your [package manager](https://github.com/postmodern/ruby-install#features) for both using ruby-install as well as fetching necessary dependencies to build from source.

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Ruby.

When installing Ruby using `asdf install`, you can pass custom configure options with the [env vars supported by ruby-install](https://github.com/postmodern/ruby-install#synopsis).

Under the hood, asdf-ruby uses [ruby-install](https://github.com/postmodern/ruby-install) to build and install Ruby, check its [README](https://github.com/postmodern/ruby-install) for more information about build options and the [requirements](https://github.com/postmodern/ruby-install#requirements) section for any issues encountered during installation of ruby versions.

You may also apply custom patches before building with `RUBY_APPLY_PATCHES`, e.g.

```sh
RUBY_APPLY_PATCHES=$'dir/1.patch\n2.patch\nhttp://example.com/3.patch' asdf install ruby 2.4.1
RUBY_APPLY_PATCHES="https://raw.githubusercontent.com/rvm/rvm/master/patchsets/ruby/2.1.1/railsexpress" asdf install ruby 2.1.1
```

Although unecessary with ruby-install, you can still pass custom options

```sh
RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.1)" asdf install ruby 2.4.0
```

```sh
RUBY_CONFIGURE_OPTS="--enable-shared --enable-dtrace CFLAGS="-O3"" asdf install ruby 2.4.0
```

By default asdf-ruby uses the latest release of ruby-install, but you can choose your own branch/tag through the `ASDF_RUBY_INSTALL_VERSION` variable:

```sh
ASDF_RUBY_INSTALL_VERSION="v0.8.0" asdf install ruby 2.6.4
```

```sh
ASDF_RUBY_INSTALL_VERSION="master" asdf install ruby 2.6.4
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

If you are migrating from version manager that supported fuzzy matching in `.ruby-version`
like [rvm](https://github.com/rvm/rvm) or [chruby](https://github.com/postmodern/chruby),
note that you might have to change `.ruby-version` to include full version (e.g. change `2.6` to `2.6.1`).
