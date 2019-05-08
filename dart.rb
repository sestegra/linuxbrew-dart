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
