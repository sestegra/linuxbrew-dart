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
    version "2.2.0-dev.1.1"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.2.0-dev.1.1/sdk/dartsdk-linux-x64-release.zip"
      sha256 "f6a7d7e07b6ad093c1cd90f452fc74b7d580001bb07e654b1ef4d3b07a07d0aa"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.2.0-dev.1.1/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "e1838f2558740466bf759b8d447ac8bb63e02b233d47365336c3484ae8cad6e2"
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
