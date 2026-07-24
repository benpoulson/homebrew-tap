class Phpxray < Formula
  desc "A fast PHP static analyzer written in Rust"
  homepage "https://github.com/benpoulson/phpxray"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.1.0/phpxray-aarch64-apple-darwin.tar.xz"
      sha256 "d8248eeecdeaaabf1ac7099d4f6d906fb7c78e19a46fc615e55966403524ad79"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.1.0/phpxray-x86_64-apple-darwin.tar.xz"
      sha256 "f63af1085683b202b3a5338160f7f7fa9b7dc654b0868cdb33bfbc6b1528d76e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.1.0/phpxray-aarch64-unknown-linux-musl.tar.xz"
      sha256 "9d2c59f022b4240e43d8a7ae2f3761275dd2eea41abeb0e75776ef63bee1db1f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.1.0/phpxray-x86_64-unknown-linux-musl.tar.xz"
      sha256 "586b0f623dabc73a57659332ac7378f08026768757758129ec50cdc28d03a9e1"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "phpxray" if OS.mac? && Hardware::CPU.arm?
    bin.install "phpxray" if OS.mac? && Hardware::CPU.intel?
    bin.install "phpxray" if OS.linux? && Hardware::CPU.arm?
    bin.install "phpxray" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
