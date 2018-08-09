class DartAT2 < Formula
  desc "The Dart 2 SDK"
  homepage "https://www.dartlang.org/"
  version "2.1.0-dev.0.0"

  keg_only :versioned_formula

  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.0-dev.0.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "d74f42c6b4f4459c8ce83e7b2c84ad3e2874cd1ced4a4876951a37575bf82086"
  else
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.0-dev.0.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "1e303cce42ee5b830575ddf64f6e69039cfe5383d88fbe8d76725067920a4219"
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
