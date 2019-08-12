class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.4.1"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.4.1/sdk/dartsdk-linux-x64-release.zip"
    sha256 "2b9f7c1f4ecd9b1e2a2f770f84e44646c930adecc5f96e273d5b26c3f924a003"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.4.1/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "ff1f044055410f229f3ed7afe1617f92c06e400c19245c37dc1ed8e6c9e33b48"
  end

  devel do
    version "2.5.0-dev.2.0"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.5.0-dev.2.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "6400ac3c4ae4f7a9287f4f90086857ee104105840323f83bd37d2032231f9623"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.5.0-dev.2.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "e297d902cce3c8d5da79c1f708ba6c053c8c43668566999451f588aa0f4a38d8"
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
