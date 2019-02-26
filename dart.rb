class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.1.1"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.1.1/sdk/dartsdk-linux-x64-release.zip"
    sha256 "b223f095e2eb836481b6d5041d23a627745f0b45f70f9ce31cc1fbc68e9a9f90"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.1.1/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "8c7d359f00f3569dffd9d02fc213cd895a5c3e524d386cf65c89c2373630ca7e"
  end

  devel do
    version "2.2.0-dev.2.1"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.2.0-dev.2.1/sdk/dartsdk-linux-x64-release.zip"
      sha256 "8a656f41df8601380f3317c66a99daa62667e132ead19414c81b98acc695d3b3"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.2.0-dev.2.1/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "8260a6ce5eaa4df2eeaf747dad5dab15a92f7f045e63b68914d1f0a23cb62ee2"
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
