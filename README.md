# asdf-ruby

[![Build Status](https://github.com/asdf-vm/asdf-ruby/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/asdf-vm/asdf-ruby/actions/workflows/ci.yml?query=branch%3Amaster++)

Ruby plugin for [asdf](https://github.com/asdf-vm/asdf) version manager

## Install

```
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
```

Please make sure you have the required [system dependencies](https://github.com/rbenv/ruby-build/wiki#suggested-build-environment) installed before trying to install Ruby.

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Ruby.

When installing Ruby using `asdf install`, you can pass custom configure options with the [env vars supported by ruby-build](https://github.com/rbenv/ruby-build#custom-build-configuration).

Under the hood, asdf-ruby uses [ruby-build](https://github.com/rbenv/ruby-build) to build and install Ruby, check its [README](https://github.com/rbenv/ruby-build/blob/master/README.md) for more information about build options and the [troubleshooting](https://github.com/rbenv/ruby-build/wiki#troubleshooting) wiki section for any issues encountered during installation of ruby versions.

Running `asdf plugin-update ruby` will update asdf-ruby and ensure the latest versions of ruby are available to install.

You may also apply custom patches before building with `RUBY_APPLY_PATCHES`, e.g.

```
RUBY_APPLY_PATCHES=$'dir/1.patch\n2.patch\nhttp://example.com/3.patch' asdf install ruby 2.4.1
RUBY_APPLY_PATCHES=$(curl -s https://raw.githubusercontent.com/rvm/rvm/master/patchsets/ruby/2.1.1/railsexpress) asdf install ruby 2.1.1
```

By default asdf-ruby uses the latest release of ruby-build, but you can choose your own branch/tag through the `ASDF_RUBY_BUILD_VERSION` variable:

```
ASDF_RUBY_BUILD_VERSION=master asdf install ruby 2.6.4
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

You can specify a non-default location of this file by setting a `ASDF_GEM_DEFAULT_PACKAGES_FILE` variable.

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
