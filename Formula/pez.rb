class Pez < Formula
  desc "A Rust-based plugin manager for fish."
  homepage "https://github.com/tetzng/pez"
  version "0.3.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tetzng/pez/releases/download/v0.3.5/pez-aarch64-apple-darwin.tar.xz"
      sha256 "22bc17f3970ec236a725e5858f30cacb1ba24dd81088faffe9e69842ca795257"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tetzng/pez/releases/download/v0.3.5/pez-x86_64-apple-darwin.tar.xz"
      sha256 "b19fc6725218aa0e3a4bb9f8599245bed58bb34576af69452fa21444af9e6c2b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tetzng/pez/releases/download/v0.3.5/pez-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bcb932f1bd047e889aa33089b8faaf761c93e14314f48c62b829de9af7b4307b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tetzng/pez/releases/download/v0.3.5/pez-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "10ae302978949f8f7cf8bc804d48ba2fe6ec39a945b75db035f709195015fe7f"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-pc-windows-gnu":            {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
    bin.install "pez" if OS.mac? && Hardware::CPU.arm?
    bin.install "pez" if OS.mac? && Hardware::CPU.intel?
    bin.install "pez" if OS.linux? && Hardware::CPU.arm?
    bin.install "pez" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
