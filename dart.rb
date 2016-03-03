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
    version '1.15.0-dev.5.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.5.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 'ff39732316240af7383675240cd9ed4265ee7c16d6a2cb9e9d9de1b5f7ffa2ff'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.5.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '17e8de1f26ec0f3eafd63ca8ed35d140df1cb62c5ed91caa8a02fc251e92955c'
    end

    resource 'content_shell' do
      version '1.15.0-dev.5.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.5.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '596b299264ddeb1524b0c9254b05633b8b5dfea8fb0426de66b42e3cfabbd982'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.5.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'ac730e9ed738c2a2cc4564f576e6ca6d73df4ed8e8b89a7552a59d97ad338123'
      end
    end

    resource 'dartium' do
      version '1.15.0-dev.5.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.5.0/dartium/dartium-linux-x64-release.zip'
        sha256 'bffd7b65f1392eac0ceffb646b74b1af8d5818702a8720afe4bf98e7666aee01'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.5.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '5e78292a42df9e2905799d562bb4ff3cf34bb5017f8cf7b7d5aed40efb88b6db'
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
