class DartAT2 < Formula
  desc "The Dart 2 SDK"
  homepage "https://www.dartlang.org/"
  version "2.4.0"

  keg_only :versioned_formula

  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.4.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "094c862f26ff2f203e5e95801281e9f60eeab3849aed1458f364ee757ed89287"
  else
    url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.4.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "d354d776dd632ab11dabd9842e1d663e976383ee16215e48ee781f27fb18f995"
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
