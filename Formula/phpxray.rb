class Phpxray < Formula
  desc "A fast PHP static analyzer written in Rust"
  homepage "https://github.com/benpoulson/phpxray"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.3.0/phpxray-aarch64-apple-darwin.tar.xz"
      sha256 "44c0ea11c7a18f2cf48cce8c95a9f00612284cd960f771b5b59fcda2d91f4ae4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.3.0/phpxray-x86_64-apple-darwin.tar.xz"
      sha256 "73a0ad5f06c3fe903010cd718e9b185d2d302913e4b4f42f29066926abd8367f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.3.0/phpxray-aarch64-unknown-linux-musl.tar.xz"
      sha256 "c66debec983f1efcb0a16845701b385ba2e02a823e0985e4935ba6a850274e0e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.3.0/phpxray-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ab2c63215651cf209d3e62e441bc44d4d227490c2829365cdeecd48e1b1b0de1"
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
