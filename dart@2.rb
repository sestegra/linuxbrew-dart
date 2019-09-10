class DartAT2 < Formula
  desc "The Dart 2 SDK"
  homepage "https://www.dartlang.org/"
  version "2.5.0"

  keg_only :versioned_formula

  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.5.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "5bd5ff07c74bab4f26b24d161b3825e1b78f11ee15cb941c30ba4f31a2a05bef"
  else
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.5.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "45caf53e1c2cefd3dd19892f0420acd4e4da3a30713c4ef608a5110350ea4aaf"
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
