class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.3.2"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.3.2/sdk/dartsdk-linux-x64-release.zip"
    sha256 "b693df23f9ff887ca1f5dd8240a96cb813dba1ec89100bc27b27915f19a1ab04"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.3.2/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "6f659edc1d7f06e1141a6b5db88382b8e2d9fcafd3e9de0b7af3749ce4a9033d"
  end

  devel do
    version "2.3.3-dev.0.0"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.3-dev.0.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "4a446c789d8f1de3e2e18d2001b91ed52cee85cd6fea4a1496e464546813cb71"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.3-dev.0.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "ccc67cacb7a3de49aebd5924c30a0feedb576256d145e2006020b54bd5cef3b0"
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
