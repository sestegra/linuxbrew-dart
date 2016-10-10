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
    version '1.20.0-dev.10.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.2/sdk/dartsdk-linux-x64-release.zip'
      sha256 'b2f20a1e3365e5f999e23f453353b7e70481f5d265613fa8a801a1ac91df1be0'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.2/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'dbad5a3cdaf84ae406ac8d565349ddf359607d1700dd032f2565c05bf0cbf83e'
    end

    resource 'content_shell' do
      version '1.20.0-dev.10.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.2/dartium/content_shell-linux-x64-release.zip'
        sha256 'f5551dd2debeba1f70136887dff203d747818ab14ceadf9ba2ec42a42b6475b3'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.2/dartium/content_shell-linux-ia32-release.zip'
        sha256 '639bd2443599c926858f18c739dd50c22a317acc2e831d03fe7fc091ae1b69bd'
      end
    end

    resource 'dartium' do
      version '1.20.0-dev.10.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.2/dartium/dartium-linux-x64-release.zip'
        sha256 '704e28e36e6fdde05fdad4792d54b14b400fd68f2222bd8e6ad06f8629075e49'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.10.2/dartium/dartium-linux-ia32-release.zip'
        sha256 '7ba1aff012a6ddd69d905ab283fd71d62140d02ca3d7f3760831f1d9b6358be7'
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
