class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.4.1"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.4.1/sdk/dartsdk-linux-x64-release.zip"
    sha256 "2b9f7c1f4ecd9b1e2a2f770f84e44646c930adecc5f96e273d5b26c3f924a003"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.4.1/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "ff1f044055410f229f3ed7afe1617f92c06e400c19245c37dc1ed8e6c9e33b48"
  end

  devel do
    version "2.5.0-dev.2.1"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.5.0-dev.2.1/sdk/dartsdk-linux-x64-release.zip"
      sha256 "1090887e19d7d7152cbc5389f088afe166fd119816072affe86ccbe9a27fd38a"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.5.0-dev.2.1/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "64b9dd9852b48633876d06cab3b77c97a28299a3605ccce4c754bb20b6639378"
    end
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
  end

  def shim_script(target)
    <<~EOS
      #!/usr/bin/env bash
      exec "#{prefix}/#{target}" "$@"
    EOS
  end

  def caveats; <<~EOS
    Please note the path to the Dart SDK:
      #{opt_libexec}
    EOS
  end

  test do
    (testpath/"sample.dart").write <<~EOS
      void main() {
        print(r"test message");
      }
    EOS

    assert_equal "test message\n", shell_output("#{bin}/dart sample.dart")
  end
end
