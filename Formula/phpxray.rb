class Phpxray < Formula
  desc "A fast PHP static analyzer written in Rust"
  homepage "https://github.com/benpoulson/phpxray"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.3.0/phpxray-aarch64-apple-darwin.tar.xz"
      sha256 "5966101c5825fb721e0fd881b9721d81d257d8de4a66caef2d7759cf846d04c2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.3.0/phpxray-x86_64-apple-darwin.tar.xz"
      sha256 "6275fb0e00eb17a644b866981ec3f3b161ac4bd5cf2610827769d881ad89f522"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.3.0/phpxray-aarch64-unknown-linux-musl.tar.xz"
      sha256 "aa74a87049cbcc8f25be71aa2ea84edefde2a66e767e2d44a935b75af7b7307d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/benpoulson/phpxray/releases/download/v0.3.0/phpxray-x86_64-unknown-linux-musl.tar.xz"
      sha256 "b2ebe6a232f822598ccf73038121c09c3bff4445e35622ab750862a138231eab"
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
