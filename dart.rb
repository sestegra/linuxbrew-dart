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
    version '1.15.0-dev.1.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '24f6f564693c51475c070b992c8d59ef8739aa101afde5561997132df5f82201'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '8f0a612d160133300c8c04e8208441f7960da4945bb61b86ea4373e31638b89f'
    end

    resource 'content_shell' do
      version '1.15.0-dev.1.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'f7e4fbc6ac7607cb0b4d7ad0269648c9b80fc2c1dd6c1124d3d54e2551037933'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '87e67259e974e7855d95634581e8a9e2e6fd99e7dc455cda9311c0b62c9122c7'
      end
    end

    resource 'dartium' do
      version '1.15.0-dev.1.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/dartium/dartium-linux-x64-release.zip'
        sha256 '18d785346a08b874fcc149d3780c48be21a6bbb1b34446db2306ff9f243f25ac'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'cd71dd70b0c31722e5674c8e8d4081a37b78fe905e10d8994f3f385aeb01d6c9'
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
