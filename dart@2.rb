class DartAT2 < Formula
  desc "The Dart 2 SDK"
  homepage "https://www.dartlang.org/"
  version "2.0.0-dev.68.0"

  keg_only :versioned_formula

  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.68.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "9ce95f3fa184bc10978d740b23bd0b949634ec3ba5a46bc869a079690a1d0ecf"
  else
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.68.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "36e9044eb43bf63f8de501fa9db4b5d7062ccff12337d9ce429fe6f69d3ab3c8"
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
