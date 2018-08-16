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
    version "2.1.0-dev.1.0"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.0-dev.1.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "b97f967fbdb0d677702a9e51deeb697b3086496e3e69ff7b815e213c2f9a181d"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.0-dev.1.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "67e9acd38e889be11254cf439593c52af9eff07b74dc7e6dc62036eb873d59fb"
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
