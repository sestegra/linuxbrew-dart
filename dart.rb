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
    version "2.1.2-dev.0.0"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.2-dev.0.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "bbe65c884ec1348dfd992e6ad5742394a6fbb45b1782ef2c1e2ebd5c454df0b7"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.2-dev.0.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "2b10268f81b224ff13aa02c16412f7c081a5aeef040aac7356923b7aa7bdb64a"
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
