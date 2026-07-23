class Quay < Formula
  desc "Cross-platform CLI for sharing AI agent skills (SKILL.md format) between people and orgs via any git host."
  homepage "https://github.com/evgeniiPerov/quay"
  version "0.13.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.13.4/quay-aarch64-apple-darwin.tar.xz"
      sha256 "d3867f7017f16ca5b0a63f27d4a1ae936bf00d20fbd0b6c8eda3107207004d33"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.13.4/quay-x86_64-apple-darwin.tar.xz"
      sha256 "76c26c776ab98a12b648ca1fe12bbcb288bda5c728651c5db5a2d80619d7c208"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.13.4/quay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "57c1eae381210464b258e8063d23224fff5439db37f2d739e2477885aaad11b9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.13.4/quay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "03bfc586a3e0b7f139add8fbd7047d52a719cb6fa3db610669a1bc40e7e16011"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
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
    bin.install "quay" if OS.mac? && Hardware::CPU.arm?
    bin.install "quay" if OS.mac? && Hardware::CPU.intel?
    bin.install "quay" if OS.linux? && Hardware::CPU.arm?
    bin.install "quay" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
