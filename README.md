# asdf-ruby

[![Build Status](https://github.com/asdf-vm/asdf-ruby/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/asdf-vm/asdf-ruby/actions/workflows/ci.yml?query=branch%3Amaster++)

Ruby plugin for [asdf](https://github.com/asdf-vm/asdf) version manager

## Install

```
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
```

Please make sure you have the required [system dependencies](https://github.com/rbenv/ruby-build/wiki#suggested-build-environment) installed before trying to install Ruby. It is also recommended that you [remove other ruby version managers before using asdf-ruby](#troubleshooting)

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Ruby.

When installing Ruby using `asdf install`, you can pass custom configure options with the [env vars supported by ruby-build](https://github.com/rbenv/ruby-build#custom-build-configuration).

Under the hood, asdf-ruby uses [ruby-build](https://github.com/rbenv/ruby-build) to build and install Ruby, check its [README](https://github.com/rbenv/ruby-build/blob/master/README.md) for more information about build options and the [troubleshooting](https://github.com/rbenv/ruby-build/wiki#troubleshooting) wiki section for any issues encountered during installation of ruby versions.

You may also apply custom patches before building with `RUBY_APPLY_PATCHES`, e.g.

```
RUBY_APPLY_PATCHES=$'dir/1.patch\n2.patch\nhttp://example.com/3.patch' asdf install ruby 2.4.1
RUBY_APPLY_PATCHES=$(curl -s https://raw.githubusercontent.com/rvm/rvm/master/patchsets/ruby/2.1.1/railsexpress) asdf install ruby 2.1.1
```

> **_NOTE:_**  This plugin does not automatically fetch new Ruby versions. Running `asdf plugin-update ruby` will update asdf-ruby and ensure the latest versions of Ruby are available to install.

By default asdf-ruby uses a recent release of ruby-build, however instead you can choose your own branch/tag through the `ASDF_RUBY_BUILD_VERSION` variable:

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

## Troubleshooting

> **_NOTE:_**  The most common issue reported for this plugin is a missing Ruby version. If you are not seeing a recent Ruby version in the list of available Ruby versions it's likely due to having an older version of this plugin. Run `asdf plugin-update ruby` to get the most recent list of Ruby versions.

If you are moving to asdf-ruby from another Ruby version manager, it is recommended to completely uninstall the old Ruby version manager before installing asdf-ruby.

If you install asdf and asdf-ruby and it doesn't make `ruby` and `irb` available in your shell double check that you have installed asdf correctly. Make sure you have [system dependencies](https://github.com/rbenv/ruby-build/wiki#suggested-build-environment) installed BEFORE running `asdf install ruby <version>`. After installing a Ruby with asdf, run `type -a ruby` to see what rubies are currently on your `$PATH`. The asdf `ruby` shim should be listed first, if it is not asdf is not installed correctly.

Correct output from `type -a ruby` (asdf shim is first in the list):

```
ruby is /Users/someone/.asdf/shims/ruby
ruby is /usr/bin/ruby
```

Incorrect output `type -a ruby`:

```
ruby is /usr/bin/ruby
```
