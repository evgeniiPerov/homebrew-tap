class Quay < Formula
  desc "Cross-platform CLI for sharing AI agent skills (SKILL.md format) between people and orgs via any git host."
  homepage "https://github.com/evgeniiPerov/quay"
  version "0.13.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.13.2/quay-aarch64-apple-darwin.tar.xz"
      sha256 "3d55b32d79765aa222aecbb1e1a056ac1d923adc17ca313f890b8dcb98a9add4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.13.2/quay-x86_64-apple-darwin.tar.xz"
      sha256 "8d45c0449e0ea3ed9ebcd25ef63bea346e3370968eb4093f8fe0c8eb0a6ab807"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.13.2/quay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b6d339d92581b5cf038f5ec15f6444c2a613deaa6a771fe606a970bc9f7b462e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.13.2/quay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3772868ddf1dfd61de837d76f6ac5c7fa76cb126c7678397e3c49e24b7274cd5"
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
