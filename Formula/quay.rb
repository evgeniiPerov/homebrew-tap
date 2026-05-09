class Quay < Formula
  desc "Cross-platform CLI + TUI for sharing AI agent skills (SKILL.md format) between people and orgs via any git host."
  homepage "https://github.com/evgeniiPerov/quay"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.1.1/quay-aarch64-apple-darwin.tar.xz"
      sha256 "84c717703ffa4ca4b3c799e1817a26bd7ccf4b11134f5e2d30220553a5f6839c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.1.1/quay-x86_64-apple-darwin.tar.xz"
      sha256 "5993b24f886a34a1d459d700ac2c9a3eb3542092cf9a5801d72d8670b126b1c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.1.1/quay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "888bbf38a22ff2f92fcdfc72b078a949977c53d89244f28b5f0c6dfc68e22740"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.1.1/quay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3458afa15cabab7ea854b04eb47fcd74907206c19d34f3500ac5364bd39fce1c"
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
