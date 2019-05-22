class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.3.1"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.3.1/sdk/dartsdk-linux-x64-release.zip"
    sha256 "6b422e0b5ef7414db6c2bdf34618db5fbb97ead399728f75f409891d3b02c0f7"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.3.1/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "01da3083abd45d3e4454b8002f69749159806044d58f38567c9b5dcf72a66880"
  end

  devel do
    version "2.3.2-dev.0.0"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.2-dev.0.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "bdca2f32fa44bee5f28d05fe94eb5561dc2f2fcdf2101a0bdfdbab0e5c4e86c7"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.2-dev.0.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "e67fce7a03749842c43ee4b39a46e756441399a519125a0337ad6a7517907b5e"
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
