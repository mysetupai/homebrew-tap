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
  url "https://mysetup.ai/cli/releases/0.2.24/mysetup-0.2.24-macos-universal.tar.gz"
  sha256 "c3a8c21d6f12bab5e4912d6e6d8377a75da63e70e52267a5a978c233b35769bf"
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
      url "https://mysetup.ai/cli/releases/0.2.24/mysetup-0.2.24-linux-x86_64.tar.gz"
      sha256 "90677952fe15f25b46272547013916fc82d1f00d65a30238650b1985ad5cd1eb"
    end
    on_arm do
      url "https://mysetup.ai/cli/releases/0.2.24/mysetup-0.2.24-linux-arm64.tar.gz"
      sha256 "873915d05e2f752fb7ac47b5ceb9d0a38bd8bd1cc71eb22a0f8d66c314e5caf8"
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
