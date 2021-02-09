# asdf-ruby

[![Build Status](https://travis-ci.org/asdf-vm/asdf-ruby.svg?branch=master)](https://travis-ci.org/asdf-vm/asdf-ruby)

Ruby plugin for [asdf](https://github.com/asdf-vm/asdf) version manager

## Install

```
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
```

Please make sure you have the required [system dependencies](https://github.com/rbenv/ruby-build/wiki#suggested-build-environment) installed before trying to install Ruby.

## Use

Check [asdf](https://github.com/asdf-vm/asdf) readme for instructions on how to install & manage versions of Ruby.

When installing Ruby using `asdf install`, you can pass custom configure options with the [env vars supported by ruby-build](https://github.com/rbenv/ruby-build#custom-build-configuration).

Under the hood, asdf-ruby uses [ruby-build](https://github.com/rbenv/ruby-build) to build and install Ruby, check its [README](https://github.com/rbenv/ruby-build/blob/master/README.md) for more information about build options and the [troubleshooting](https://github.com/rbenv/ruby-build/wiki#troubleshooting) wiki section for any issues encountered during installation of ruby versions.

### Patches

You may also apply custom patches before building with `RUBY_APPLY_PATCHES`, e.g.

```
RUBY_APPLY_PATCHES=$'dir/1.patch\n2.patch\nhttp://example.com/3.patch' asdf install ruby 2.4.1
RUBY_APPLY_PATCHES=$(curl -s https://raw.githubusercontent.com/rvm/rvm/master/patchsets/ruby/2.1.1/railsexpress) asdf install ruby 2.1.1
```

If you're maintaining multiple versions of Ruby with version specific patches, you
can use `RUBY_APPLY_VERSION_PATCHES` to specify which patches should be applied
to specific Ruby versions:

```
RUBY_APPLY_VERSION_PATCHES=$'<ruby_version1>=<patch_path1>,<patch_path2>\n<ruby_version2>=<patch_path1>,<patch_path2>'
```

For example:

```
export RUBY_APPLY_VERSION_PATCHES=$'2.4.1=/tmp/2.4.1_1.patch,/tmp/2.4.1_2.patch\n2.1.1=http://example.com/3.patch'

asdf install ruby 2.4.1
asdf install ruby 2.1.1
```

The ability to specify multiple, version specific patches is most useful when
used in conjuction with a `.tool-versions` file such as:

```
ruby 2.4.1 2.1.1
```

With `RUBY_APPLY_VERSION_PATCHES` already exported, running an `asdf install`
will now ensure the correct version specific patches are applied as needed.

### ruby-build version

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
