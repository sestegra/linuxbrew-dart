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
    version '1.20.0-dev.10.3'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.3/sdk/dartsdk-linux-x64-release.zip'
      sha256 'dcbf41b5ea0f577aff098ed5d1dc62cc744be1311ce70e522eeccd7f2db9c282'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.3/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '1d0ba17ed695b717afb32449d5c85d15bfbcd602def62478ed937ee5fff65d24'
    end

    resource 'content_shell' do
      version '1.20.0-dev.10.3'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.3/dartium/content_shell-linux-x64-release.zip'
        sha256 '1da81437477a0017f28bc2cc17f3e45a50bbe388ab0fc4ab6575c8139df64637'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.3/dartium/content_shell-linux-ia32-release.zip'
        sha256 '4ab12fbe5d87229e7fb028c44f137ea64384138600940f98d67cfba33a614c2b'
      end
    end

    resource 'dartium' do
      version '1.20.0-dev.10.3'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.3/dartium/dartium-linux-x64-release.zip'
        sha256 'c4af655ca8a7665cfb953bd04d6b67cc0a46f09991c00889775b22534da288b7'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.3/dartium/dartium-linux-ia32-release.zip'
        sha256 'fd8b8f6f5a7b5d9120b2958de91c6bfcf6a023a32d376161fddd913cf1cf6ae4'
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
