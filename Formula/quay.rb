class Quay < Formula
  desc "Cross-platform CLI for sharing AI agent skills (SKILL.md format) between people and orgs via any git host."
  homepage "https://github.com/evgeniiPerov/quay"
  version "0.15.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.15.1/quay-aarch64-apple-darwin.tar.xz"
      sha256 "95589a150c895ba3bb3f829d791a282d3043e29e24e97a2372c46af290c287a0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.15.1/quay-x86_64-apple-darwin.tar.xz"
      sha256 "df25c3bc90827144c9e0acb59f792d527375b7ac8b402340a2a7518321b9860b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.15.1/quay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "adda129e209ac9d8093c45f3bc97f4572478cc676bd65909d349889283a97e1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.15.1/quay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2af97a0ef6ee8c41599d06b6f12c83d37f1df83e298e6b91ac9d8c99815e3c1c"
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
