module ReshimInstaller
  def install(options)
    super
    # We don't know which gems were installed, so always reshim.
    `asdf reshim ruby`
  end
end

if defined?(Bundler::Installer)
  Bundler::Installer.prepend ReshimInstaller
else
  maybe_reshim = lambda do |installer|
    # If any gems with executables were installed or uninstalled, reshim.
    `asdf reshim ruby` if installer.spec.executables.any?
  end
  Gem.post_install &maybe_reshim
  Gem.post_uninstall &maybe_reshim
end
