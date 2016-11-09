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
    version '1.21.0-dev.5.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.5.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 'e48b6709c0b57f8c9b22554c241d10559cd59165432782053a9f4e41392ed18d'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.5.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '4942eaedd7bfc9069a3cc2d8a52439be396d844d5136cda31d0172d55a4f3b1e'
    end

    resource 'content_shell' do
      version '1.21.0-dev.5.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.5.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '88523a419d9442aec0ef45cab25eb472b871e7e5b4fb9cdaafdcab2c18c6b49c'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.5.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'a895c9e01459048a8c2c0b39e19a178864bbed6878eb7dd6c88156e6a64015ef'
      end
    end

    resource 'dartium' do
      version '1.21.0-dev.5.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.5.0/dartium/dartium-linux-x64-release.zip'
        sha256 '17509eb61224623531c8db1900966f4ee76634826f009344f92004cf77dea017'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.5.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'cf236498cb7057f2c3ffa2f83c28a3f63045c919c6aab3ad0c1d20b8ebc811ed'
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
