class MacosSystemCleaner < Formula
  desc "A collection of scripts to clean RAM, cache and IDEs for improved macOS system performance"
  homepage "https://github.com/halilertekin/macOS-System-Cleaner"
  url "https://github.com/halilertekin/macOS-System-Cleaner/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"  # Updated SHA256 for v1.1.0
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

      Note: When updating to a new version, the SHA256 hash in the formula
      needs to be updated with the new tarball's hash.
      You can calculate it with: shasum -a 256 <tarball_name>.tar.gz
    EOS
  end

  test do
    # Test that the main command exists
    system "#{bin}/msc", "--help"
  end
end