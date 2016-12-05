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
    version '1.21.0-dev.11.3'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.3/sdk/dartsdk-linux-x64-release.zip'
      sha256 'de8d7112f43e208002cdbdc2e033634686e75f70cd9a03e5379e42571f8b4f47'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.3/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'd80677d79fd48e2bd8e9f5b3b118ff4fa202a45052d363dd36638835b25f3f97'
    end

    resource 'content_shell' do
      version '1.21.0-dev.11.3'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.3/dartium/content_shell-linux-x64-release.zip'
        sha256 '6ce24fffc811e8d6109f77a04b3f781a26a887d29a3cd45360f133aeedebb708'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.3/dartium/content_shell-linux-ia32-release.zip'
        sha256 '62576ada11f25fe46190796d48094c5f63dd82ec2eb85bec1da854f6465611d0'
      end
    end

    resource 'dartium' do
      version '1.21.0-dev.11.3'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.3/dartium/dartium-linux-x64-release.zip'
        sha256 '6cef8cc4a2571d4fc223dcd44603869849f8e704d1c068f9b1c406f8a61e0686'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.21.0-dev.11.3/dartium/dartium-linux-ia32-release.zip'
        sha256 '0051cfdb39730f0cbc89b492643e2ecbb303b859811f2e1a51977c20c2537153'
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
