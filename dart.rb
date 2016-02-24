require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.14.2'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/sdk/dartsdk-linux-x64-release.zip'
    sha256 'cf2477eb4f6b70e433d9a6fda2dabe8ffd9100fad0a9fc95dd54235a97ff7758'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '0824b6f3173c1816a479fe86af736b9b1366becf582c442e7e4ea0d259ecd97c'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.15.0-dev.4.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.4.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '7840680f534fd621657e93b1de25d4ca3893415017aecab8436e4275c63aa137'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.4.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '6b2fd44c2bf2e8bb20040a1febb4c0959544b1361bb154a1f782bdc5f0cf3097'
    end

    resource 'content_shell' do
      version '1.15.0-dev.4.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.4.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '0d7005a313fd87943f61ec58ec283e1d2d878c161de14887c9e3674cadcdadf0'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.4.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'cbdf875a690f0df5965647117398e5a2c15fdedae4420d9d75f73efdc0e1b0f4'
      end
    end

    resource 'dartium' do
      version '1.15.0-dev.4.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.4.0/dartium/dartium-linux-x64-release.zip'
        sha256 '733a3ef02db9214ff6092cabf267b8aa91d84ec687c0a94f4c6f531caef53427'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.4.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'd7e6fdd137c2c03ef3caa0478b1ad52c6fc8f0c2ddc8e8d8d2e5d6c943dd3b69'
      end
    end
  end

  resource 'content_shell' do
    version '1.14.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/dartium/content_shell-linux-x64-release.zip'
      sha256 '0b3f03d8139baf2375cc9c4818fbd178c26bd516c61d59c887013c4edda354c9'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/dartium/content_shell-linux-ia32-release.zip'
      sha256 '3a0b6a61485053be14c278d81f87383ebb3539210a776c4993d343c692dd27d6'
    end
  end

  resource 'dartium' do
    version '1.14.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/dartium/dartium-linux-x64-release.zip'
      sha256 '7290d600458b431bad951d01f7d5277d67758f53205c384cb1778b7d89bfd2b2'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/dartium/dartium-linux-ia32-release.zip'
      sha256 '2257464177001b52f67f0b8f773f5c36fe89c21733380b1a502e7139429ac6ca'
    end
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]

    if build.with? 'dartium'
      dartium_binary = 'Chromium.app/Contents/MacOS/Chromium'
      prefix.install resource('dartium')
      (bin+"dartium").write shim_script dartium_binary
    end

    if build.with? 'content-shell'
      content_shell_binary = 'Content Shell.app/Contents/MacOS/Content Shell'
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
