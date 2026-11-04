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
  url "https://mysetup.ai/cli/releases/0.2.7/mysetup-0.2.7-macos-universal.tar.gz"
  sha256 "dc875f245cc2229e6063ac35c9ce5eaaed58217717c3244792080c44a8e64632"
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
      url "https://mysetup.ai/cli/releases/0.2.7/mysetup-0.2.7-linux-x86_64.tar.gz"
      sha256 "78b23b5ade3aa58eec5bfb9e678f6b2f34acedb31668e23f9cbf7800e32b8ca0"
    end
    on_arm do
      url "https://mysetup.ai/cli/releases/0.2.7/mysetup-0.2.7-linux-arm64.tar.gz"
      sha256 "872ee1f017fd1846daad713fe9e335dfe4cb8d6b477ff2d648915d29ef91c0fa"
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

      After upgrading:      mysetup status (updates the background engine safely)
      Development pin:      mysetup runtime ensure (review returning to installed updates)
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
