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
  url "https://mysetup.ai/cli/releases/0.2.5/mysetup-0.2.5-macos-universal.tar.gz"
  sha256 "c60212a5f36acd6df73c49cd1ce74bc7a5163adede7945720262d4f6a51badea"
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
      url "https://mysetup.ai/cli/releases/0.2.5/mysetup-0.2.5-linux-x86_64.tar.gz"
      sha256 "649e21bc394268c778d07d982623d43d8123b29eeeb200d25233d1e6bf8c3210"
    end
    on_arm do
      url "https://mysetup.ai/cli/releases/0.2.5/mysetup-0.2.5-linux-arm64.tar.gz"
      sha256 "89dcbe5f29e541367c3921ee9c5b91b7ed63b11514a857761bb25820d31454f7"
    end
  end

  def install
    bin.install "mysetup"
  end

  def caveats
    <<~EOS
      Get started:

        mysetup onboard

      Sign in, choose your skills and connect another device.
      Nothing is published, and background sync stays off until you turn it on.

      After upgrading:      mysetup service restart
      Before uninstalling:  mysetup auth logout, then mysetup self uninstall
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
