# Yes borrowed from rbenv. Couldn't take my mind off that implementation

Gem.post_install do |installer|

  if installer.spec.executables.any? && installer.bin_dir == Gem.default_bindir
    installer.spec.executables.each do |executable|
     `asdf reshim ruby #{RUBY_VERSION} bin/#{executable}`
    end
  end

end
