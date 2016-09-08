require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.19.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 'de3634a5572b805172aa3544214a5b1ecf3d16a20956cd5cac3781863cbfdb0a'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'ab6fbcd7b8316cd48a95190cbc156b0ad9b61a68d7897abdeab041c0b43e520e'
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
    version '1.19.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '476d95d63145baac635b351b50c8d5cbcc38e83361c95a1e42dc242719429742'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 '469ca56760af33f3c3daa6493c3cd03a5dc05af6866635a076bc2611a140b1bc'
    end
  end

  resource 'dartium' do
    version '1.19.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.1/dartium/dartium-linux-x64-release.zip'
      sha256 '4552b19cc2c24273999f6ebd870922a0b34d581defe771ca570655b94bb85f14'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.1/dartium/dartium-linux-ia32-release.zip'
      sha256 'e6d23f5dc641a42f9e34bb29ce3df3f7c7fb181934377299db75422ef984b618'
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
