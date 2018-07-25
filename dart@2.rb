class DartAT2 < Formula
  desc "The Dart 2 SDK"
  homepage "https://www.dartlang.org/"
  version "2.0.0-dev.69.3"

  keg_only :versioned_formula

  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.69.3/sdk/dartsdk-linux-x64-release.zip"
    sha256 "f5cef746a46cb7e01ae8efe2e664d16250515364dcfcb70854a3e68839a97d9d"
  else
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.69.3/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "1a6ee11656adf9a38c2b8c67bb19c5bc784e55672a8b1a2969a2269cdf4fd492"
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

    --with-dartium:
      To use with IntelliJ, set the Dartium execute home to:
        #{opt_prefix}/chrome
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
