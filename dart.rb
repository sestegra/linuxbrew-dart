class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.3.0"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.3.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "f2b9a2ba51ba71b025075b60dc31ccf5161c7a5a7061ed8e073efb309b718524"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.3.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "b55626c0f855088c04e85fc7856012db281ea68846e9466e1cc0151c2508b432"
  end

  devel do
    version "2.3.0-dev.0.5"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.0-dev.0.5/sdk/dartsdk-linux-x64-release.zip"
      sha256 "4b1f49f5f2aa81d098f1ec2e7c0f5b533c2fa9c26e72b98f97bbe11ec099a5cf"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.0-dev.0.5/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "f36105366b6bc24f79b355cb46c2980ed7d1ccf910be12a0acd96a19d1512be3"
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
