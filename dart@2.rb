class DartAT2 < Formula
  desc "The Dart 2 SDK"
  homepage "https://www.dartlang.org/"
  version "2.3.0"

  keg_only :versioned_formula

  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "f2b9a2ba51ba71b025075b60dc31ccf5161c7a5a7061ed8e073efb309b718524"
  else
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "b55626c0f855088c04e85fc7856012db281ea68846e9466e1cc0151c2508b432"
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
