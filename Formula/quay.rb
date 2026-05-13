class Quay < Formula
  desc "Cross-platform CLI + TUI for sharing AI agent skills (SKILL.md format) between people and orgs via any git host."
  homepage "https://github.com/evgeniiPerov/quay"
  version "0.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.3.2/quay-aarch64-apple-darwin.tar.xz"
      sha256 "e9ee49dfce9e569b97f5f6f8a64cd285612455bf7c19f5ff6bb2bc5c4754280b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.3.2/quay-x86_64-apple-darwin.tar.xz"
      sha256 "8867125c215e4ffd288ea9489494af784a4f5e9bc8a150e2480a6b11bdb5a8ef"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.3.2/quay-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "01148e9b1f775c67df86b266dd72999e94d171c35ac89691c21b9e5f4e4d0501"
    end
    if Hardware::CPU.intel?
      url "https://github.com/evgeniiPerov/quay/releases/download/v0.3.2/quay-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "bb0f7c216ead0e09614dcfcf7fb9e1bc7e129db3fbc1058b45580084fad6641f"
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
