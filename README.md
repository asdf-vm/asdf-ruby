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

If you provide a `.default-gems` next to the `.tool-versions` file, asdf-ruby
will use that instead.

## Migrating from another Ruby version manager

### `.ruby-version` file

asdf uses the `.tool-versions` for auto-switching between software versions.
To ease migration, you can have it read an existing `.ruby-version` file to
find out what version of Ruby should be used. To do this, add the following to
`$HOME/.asdfrc`:

    legacy_version_file = yes
