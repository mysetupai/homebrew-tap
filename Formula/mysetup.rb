# Homebrew formula for the mysetup CLI. Rendered for each release by
# engine/scripts/release-manifest.ts from engine/packaging/homebrew/mysetup.rb.in in
# github.com/Steveybrown/mysetup.ai; publish the result as Formula/mysetup.rb in the tap
# github.com/mysetupai/homebrew-tap. Do not edit the published copy by hand.
#
# It installs the signed, notarised macOS universal binary (or the static Linux binary)
# from mysetup.ai. There is deliberately no `service` block: background operation is
# opt-in through `mysetup service enable`, which registers the version-independent
# opt/ path, so `brew services` and our agent never both start a host.
class Mysetup < Formula
  desc "Keep your AI agent skills in sync across your computers (preview)"
  homepage "https://mysetup.ai"
  # The macOS universal binary is the default; Linux selects its static build per CPU.
  url "https://mysetup.ai/cli/releases/0.2.25/mysetup-0.2.25-macos-universal.tar.gz"
  sha256 "515ce50eb39d3d05bf6789b653c8ebcc71a030b678b9925e2163d7c3bfde1b26"
  license :cannot_represent

  livecheck do
    url "https://mysetup.ai/cli/version"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  on_macos do
    depends_on macos: :sonoma
  end

  on_linux do
    on_intel do
      url "https://mysetup.ai/cli/releases/0.2.25/mysetup-0.2.25-linux-x86_64.tar.gz"
      sha256 "ef31b344a77de01c5629e65209ad9c75d46085ba63919bee34eb7780f5c6d76b"
    end
    on_arm do
      url "https://mysetup.ai/cli/releases/0.2.25/mysetup-0.2.25-linux-arm64.tar.gz"
      sha256 "4770edd4474c6a08841c21c89bd27ca43c53e9a03e6bca7999e3ab933342bec6"
    end
  end

  def install
    bin.install "mysetup"
  end

  def caveats
    <<~EOS
      Get started:

        mysetup onboard

      Sign in, choose your skills and connect another computer.
      Setup turns on background sync after your skills are ready, where supported.
      Nothing is published.

      After upgrading:      mysetup status (updates the background engine safely)
      Before uninstalling:  mysetup self uninstall
                            (your skills are never removed)

      All commands: mysetup help
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mysetup --version")
    assert_match "\"ok\":true", shell_output("#{bin}/mysetup doctor --offline --json")
    assert_match "\"installed\":false", shell_output("#{bin}/mysetup service status --json")
  end
end
