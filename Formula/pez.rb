class Pez < Formula
  desc "A Rust-based plugin manager for fish."
  homepage "https://github.com/tetzng/pez"
  version "0.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tetzng/pez/releases/download/v0.3.4/pez-aarch64-apple-darwin.tar.xz"
      sha256 "b6462714f044d3171c778912bea8eb8688f3fa908a1cc9e0bf8c091d663599e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tetzng/pez/releases/download/v0.3.4/pez-x86_64-apple-darwin.tar.xz"
      sha256 "b804fe3b1b83a9a53fa8896f1492121eccea56aee42722919deb7dbfd341617d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tetzng/pez/releases/download/v0.3.4/pez-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "981da1b5ae1cf9f36a82c3b6b53b314daafb3919c32314441cde95e74ababf5c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tetzng/pez/releases/download/v0.3.4/pez-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a3cb95db7255ba756781d67c434c144021079156d6e5c50cd1648cbd4446eacb"
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
