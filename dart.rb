require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.19.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 '032c623d1189305f024a0d0f8da9686e640ef64fa2903b856879322401e489bd'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'b78ff13f09c290a78af2992b0ddd0ff660c47fad0566abec566b5954aa0a472d'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.20.0-dev.3.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.3.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '7fd6abca23f94fc0e1d6f9f2b2bb32ae24aecfbd544ce40b8ef8aac2f393d46d'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.3.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'c7173799e89f86f812a5f5a1115ccd44b6fd9d206b977a712d3993f74008a586'
    end

    resource 'content_shell' do
      version '1.20.0-dev.3.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.3.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'b32f46706e0431cfc2330148336d2aaad58e626f24aaaf01593bfc1b7ffaaee5'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.3.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '3591ca4ae1da13e8217283b9691895742d17e87d9a59bfee0a6a3db63ac5b16b'
      end
    end

    resource 'dartium' do
      version '1.20.0-dev.3.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.3.0/dartium/dartium-linux-x64-release.zip'
        sha256 '0dfdbf843cef44526e5e06ac907748fbfea7122786abc2653b88f19edd43a454'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.3.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '62b912b79ba6eaa5c274dbe62e71e1760c35c753be44fe3fd49cc562c3f58b15'
      end
    end
  end

  resource 'content_shell' do
    version '1.19.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/dartium/content_shell-linux-x64-release.zip'
      sha256 'f22e8bc3c1a69ec00b895a607319bc2b329573d9d186a70c43423d9ac303fa79'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 'af82ce44a2d596ce0c7cf21a803dd4539a9598e1cff33b136c74897b2219aaa7'
    end
  end

  resource 'dartium' do
    version '1.19.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/dartium/dartium-linux-x64-release.zip'
      sha256 'a5de751685e4fb48da45babb3d5d50b7dfe0bf657f4fab79706ab8978e048f53'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/dartium/dartium-linux-ia32-release.zip'
      sha256 'fd1cf1c990b8f246a01bcb2745f4936c6309a2797994822c445025477c0e8e18'
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
