class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.0.0"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.0.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "4014a1e8755d2d32cc1573b731a4a53acdf6dfca3e26ee437f63fe768501d336"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.0.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "3164a9de70bf11ab5b20af0d51c8b3303f2dce584604dce33bea0040bdc0bbba"
  end

  devel do
    version "2.1.0-dev.7.1"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.0-dev.7.1/sdk/dartsdk-linux-x64-release.zip"
      sha256 "816eecd29f22144675e77d7c58f9c8423befc13bb685e873f7111d1b16633fdf"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.0-dev.7.1/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "d5ba8560230c98200ff49da6478a3815c45ff77a91861e3bb4e900d039aac260"
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
