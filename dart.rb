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
    version "2.3.2-dev.0.1"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.2-dev.0.1/sdk/dartsdk-linux-x64-release.zip"
      sha256 "45eb7926528e3c230e93a26488bbbbd79704113edb68a1a9575f0058989cdf28"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.2-dev.0.1/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "d2ad2fd01d17c5ec14b6aa8cdb00a8afbdcb321f2c9ef9f85143763ab338aacc"
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
