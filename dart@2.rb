class DartAT2 < Formula
  desc "The Dart 2 SDK"
  homepage "https://www.dartlang.org/"
  version "2.3.1"

  keg_only :versioned_formula

  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.1/sdk/dartsdk-linux-x64-release.zip"
    sha256 "6b422e0b5ef7414db6c2bdf34618db5fbb97ead399728f75f409891d3b02c0f7"
  else
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.1/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "01da3083abd45d3e4454b8002f69749159806044d58f38567c9b5dcf72a66880"
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
