class Phpxray < Formula
  desc "A fast PHP static analyzer written in Rust"
  homepage "https://github.com/benpoulson/phpxray"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.2.0/phpxray-aarch64-apple-darwin.tar.xz"
      sha256 "371fa962645242b4765a772b380b0b7ac171060f23ab31d1c93580a448f2e978"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.2.0/phpxray-x86_64-apple-darwin.tar.xz"
      sha256 "6046dcd074f06447397f26584a9e42289b1f7febf3d75b02bcaa3483060a9957"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.2.0/phpxray-aarch64-unknown-linux-musl.tar.xz"
      sha256 "7829894eeca37af5434b2beac6099adef785fe952fa6c025389734a3a0b1b10d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.2.0/phpxray-x86_64-unknown-linux-musl.tar.xz"
      sha256 "9a3aba435cb75c1a8a98256ceca22452a7e1a66d231e14d28b0adbb5006559dc"
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
