require "formula"

class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "1.24.3"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.3/sdk/dartsdk-linux-x64-release.zip"
    sha256 "e323c97c35e6bc5d955babfe2e235a5484a82bb1e4870fa24562c8b9b800559b"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.3/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "d67b8f8f9186e7d460320e6bce25ab343c014b6af4b2f61369ee83755d4da528"
  end

  devel do
    version "2.0.0-dev.46.0"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.46.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "3de1c73b6f29b4ebb9295509490b2f04407b82cd3b2c3aa89b4b462a69ce0c3d"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.0.0-dev.46.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "03b3161056b9838f7944ada03725bf4f89afcf311652c1d397aa0c44e393a2c1"
    end
  end

  option "with-content-shell", "Download and install content_shell -- headless Dartium for testing"
  option "with-dartium", "Download and install Dartium -- Chromium with Dart"

  resource "content_shell" do
    version "1.24.3"
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.3/dartium/content_shell-linux-x64-release.zip"
    sha256 "42ef09f2b2458db647e371ccfa3a50202200a5c61063c084c85211115d01c23f"
  end

  resource "dartium" do
    version "1.24.3"
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.3/dartium/dartium-linux-x64-release.zip"
    sha256 "20144321b664d8ae13a9c674a667cb1ff7d7f0cdfb0f0897804e885e73b39f6e"
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]

    if build.with? "dartium"
      dartium_binary = "chrome"
      prefix.install resource("dartium")
      (bin+"dartium").write shim_script dartium_binary
    end

    if build.with? "content-shell"
      content_shell_binary = "content_shell"
      prefix.install resource("content_shell")
      (bin+"content_shell").write shim_script content_shell_binary
    end
  end

  def shim_script target
    <<~EOS
      #!/usr/bin/env bash
      exec "#{prefix}/#{target}" "$@"
    EOS
  end

  def caveats; <<~EOS
    Please note the path to the Dart SDK:
      #{opt_libexec}

    --with-dartium:
      To use with IntelliJ, set the Dartium execute home to:
        #{opt_prefix}/chrome
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
