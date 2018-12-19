class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.1.0"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.1.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "24673028fbc506dbded6c273b3f5fb8f0f169bd900083d0113ddd5ce0a8adcb6"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.1.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "db84d4fe7671f61d95797362b63e0588a721d8a3086d77517f4e1619e1a9318c"
  end

  devel do
    version "2.1.1-dev.0.0"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.1-dev.0.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "7051639d8b135c60568bf4b7b42dc43b2d819fb4a5d1c8da0587467d68bfdefe"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.1-dev.0.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "0d64466ac46d4d699c98c9f77f83520693eb6cbb73bfbf7dab0774d640df507d"
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
