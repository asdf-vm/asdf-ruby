# Yes totally inspired by rbenv. It's like I couldn't take my mind off that implementation

Gem.post_install do |installer|
  puts installer.spec.executables.inspect
  puts installer.bin_dir.inspect
  # if installer.spec.executables.any? && installer.bin_dir == Gem.default_bindir
     # TODO read from dir name
     # `asdf reshim ruby #{RUBY_VERSION} installer.spec.executables`
  # end
end
