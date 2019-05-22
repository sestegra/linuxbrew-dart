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
    version "2.3.1-dev.0.0"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.1-dev.0.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "1d73ece270078dcf86ac85bcf2d4556f242f90f8be5a6bb1ddf9afe05778efac"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.3.1-dev.0.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "8add83e693849abd0a3570f9bb3839f1865350bf506d13dca66b6762afbc48c7"
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
