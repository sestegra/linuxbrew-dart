class DartAT2 < Formula
  desc "The Dart 2 SDK"
  homepage "https://www.dartlang.org/"
  version "2.0.0-dev.69.0"

  keg_only :versioned_formula

  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.69.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "4e23c5f9a7a1fa854aa099dc5c285249b146a89bd244ef6b6bceb4ee6568edc3"
  else
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.69.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "e8aa24f4c1d1647043f48bd5d0bb3018b24bcdff09cc6dae56b88e0cbb716c8a"
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
