require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.22.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 '90379279c892eef670c8160bc97d1e9857bc806c1c0ade616c8f3f8bc4360c26'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '4441cf941f12829bf3d3ff481a3c74b80f89693d68bd8cb60a461c20f7be6ec9'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.23.0-dev.11.4'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.11.4/sdk/dartsdk-linux-x64-release.zip'
      sha256 '82f5cf0aa3b0ea5de448124b06f24457dc97258506da7138b805b061c1fc3b90'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.11.4/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '4c1e1e2cf31aa4cc95952d5aa22a2f182f34625c02aea7947da3e7e48bc8545f'
    end

    resource 'content_shell' do
      version '1.23.0-dev.11.4'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.11.4/dartium/content_shell-linux-x64-release.zip'
        sha256 '072e02cba15d6490742d11a5739ce8fe5d43f5404c530ae33c71982c4b87ac5c'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.11.4/dartium/content_shell-linux-ia32-release.zip'
        sha256 '&lt;?xml'
      end
    end

    resource 'dartium' do
      version '1.23.0-dev.11.4'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.11.4/dartium/dartium-linux-x64-release.zip'
        sha256 '3b8e1c45c8c5b687a4f37eea32ddc4225efc0adad402d5e21e5022852d1fc9f4'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.11.4/dartium/dartium-linux-ia32-release.zip'
        sha256 '&lt;?xml'
      end
    end
  end

  resource 'content_shell' do
    version '1.22.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.1/dartium/content_shell-linux-x64-release.zip'
      sha256 'a7431ce392ddae4ff92b8ac0c53798cf270501ddeb232ef583ab2229f795209d'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 '&lt;?xml'
    end
  end

  resource 'dartium' do
    version '1.22.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.1/dartium/dartium-linux-x64-release.zip'
      sha256 '5472e4eb1aac7f6810c3700e0a0fad514bf081364c5e7b02c8da9d44f1713ff4'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.1/dartium/dartium-linux-ia32-release.zip'
      sha256 '&lt;?xml'
    end
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]

    if build.with? 'dartium'
      dartium_binary = 'chrome'
      prefix.install resource('dartium')
      (bin+"dartium").write shim_script dartium_binary
    end

    if build.with? 'content-shell'
      content_shell_binary = 'content_shell'
      prefix.install resource('content_shell')
      (bin+"content_shell").write shim_script content_shell_binary
    end
  end

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      exec "#{prefix}/#{target}" "$@"
    EOS
  end

  def caveats; <<-EOS.undent
    Please note the path to the Dart SDK:
      #{opt_libexec}

    --with-dartium:
      To use with IntelliJ, set the Dartium execute home to:
        #{opt_prefix}/chrome
    EOS
  end

  test do
    (testpath/'sample.dart').write <<-EOS.undent
      void main() {
        print(r"test message");
      }
    EOS

    assert_equal "test message\n", shell_output("#{bin}/dart sample.dart")
  end
end
