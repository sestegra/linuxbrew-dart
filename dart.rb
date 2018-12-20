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
    version "2.1.1-dev.0.1"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.1-dev.0.1/sdk/dartsdk-linux-x64-release.zip"
      sha256 "05c9b41a1c3b63eb95492e2302d2c1bc22d27d85a5676214676b15fe80c8e602"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.1.1-dev.0.1/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "fe203e7e2294fd4f6a64fc5f7cd3e41a5cdf28994f62245925f47a9883ddabdb"
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
