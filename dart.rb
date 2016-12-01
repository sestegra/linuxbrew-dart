require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.20.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.20.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 'f043ecb8c578684a621613ea846fd0bc94ba40e1faecdd33103473f778405913'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.20.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '8d3ba411ef5bef4959a597cc1b9c2e3bd66f71cbf2986f7b03487e00047d4b85'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.21.0-dev.11.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.1/sdk/dartsdk-linux-x64-release.zip'
      sha256 '4145b64aee8691b8298dbfad9860797ee759de2200b9d54cd8b920a56ee67549'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.1/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'afc41f88ce5b55b6c9ae2115adfbba0691db1aebf5b7af565d4d781d79208017'
    end

    resource 'content_shell' do
      version '1.21.0-dev.11.1'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.1/dartium/content_shell-linux-x64-release.zip'
        sha256 '3aa47d3de550e9d5c9794f89ccdc9141bac5d13d6f8cd344c340d292ff13234e'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.1/dartium/content_shell-linux-ia32-release.zip'
        sha256 '42c37408942b528a194bbf1f468a3b56206d1664a4013cb67308cf1c631c81ff'
      end
    end

    resource 'dartium' do
      version '1.21.0-dev.11.1'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.1/dartium/dartium-linux-x64-release.zip'
        sha256 '7f5abb7c9fa24a22ed621ed3b03f89e1e1fed36af1c00773ca6fb0eca444bc71'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.1/dartium/dartium-linux-ia32-release.zip'
        sha256 'f0b7ae1680cce2a3c7b18174f00ce816fcb04bd8ef9faa479f5a402af9521e53'
      end
    end
  end

  resource 'content_shell' do
    version '1.20.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.20.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '61f25c37df8dd8319f32946f114d26858f3a90fdbd2675ccf47382fbd5c90c2a'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.20.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 'b4a6b7dd33aefbc0f011f4063328e136efa2ffaab262777bc27a1137369faa1b'
    end
  end

  resource 'dartium' do
    version '1.20.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.20.1/dartium/dartium-linux-x64-release.zip'
      sha256 '35d22dae3cfff7a99ad4ca096d8c17ef498a9869f55d17920c21e0642fc4a8a4'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.20.1/dartium/dartium-linux-ia32-release.zip'
      sha256 '8b3bd91241eb61aba279bb7a771abdef95a361a7e01348418e97c5e5776736d9'
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
