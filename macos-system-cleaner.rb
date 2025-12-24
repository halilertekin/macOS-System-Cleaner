class MacosSystemCleaner < Formula
  desc "A collection of scripts to clean RAM, cache and IDEs for improved macOS system performance"
  homepage "https://github.com/halilertekin/macOS-System-Cleaner"
  url "https://github.com/halilertekin/macOS-System-Cleaner/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "REPLACE_WITH_ACTUAL_SHA256"  # Will be replaced with actual SHA256 of the tarball
  license "MIT"

  def install
    # Install all scripts
    bin.install "main_cleaner.sh" => "msc"
    prefix.install Dir["scripts/*"]
    prefix.install %w[LICENSE README.md README.tr.md install.sh package.json .npmignore]

    # Make scripts executable
    chmod 0755, bin/"msc"
    chmod 0755, Dir[prefix/"scripts/*"]
    chmod 0755, prefix/"main_cleaner.sh"
    chmod 0755, prefix/"install.sh"
  end

  def caveats
    <<~EOS
      macOS System Cleaner has been installed!

      To use the command directly:
        msc [command]

      For more information:
        msc --help

      To install bash/zsh aliases:
        source #{prefix}/install.sh --bash-alias    # for bash
        source #{prefix}/install.sh --zsh-alias     # for zsh
    EOS
  end

  test do
    # Test that the main command exists
    system "#{bin}/msc", "--help"
  end
end