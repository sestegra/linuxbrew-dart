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
    version '1.20.0-dev.5.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.5.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 'f9fde1d85d10b49932db13714c22bb2242a190092d7207a1302251f8550878a5'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.5.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '28fb9b2b56212d66c3dfb24536756643e22bb6fe8011bdc01d3da17b4202e308'
    end

    resource 'content_shell' do
      version '1.20.0-dev.5.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.5.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'f10d2ace7bc4363b785dff5bc4021ac17da78f6315f8c0f472f83b81d2935b48'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.5.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '750e62a83303d91dc0acc845826c433dfadcafbbee74d5337649eb7f7d2e1529'
      end
    end

    resource 'dartium' do
      version '1.20.0-dev.5.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.5.0/dartium/dartium-linux-x64-release.zip'
        sha256 '9a0c114a4dcff505ac1dde6136faf3f6b150c23f6ee93eb1677ccd661a3cf987'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.5.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '5b510476855d88fcffc941bc2036bb411101f2cb77fe86ccc876c9c9b0577b91'
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
