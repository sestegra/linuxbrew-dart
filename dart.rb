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
    version '1.20.0-dev.9.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.9.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 'b69c820030bb8276a9693d5c0d2931efbe3bd464e1564d578235fbf43023bbe5'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.9.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '60e5d7fa2391ed9587d14ff0ffa10054e4a0208c00f60c94088ca9ed2edd0ae1'
    end

    resource 'content_shell' do
      version '1.20.0-dev.9.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.9.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '5af8d274145a18675ad93db54cb0a04f9c055fd8eaacc268aa230a759f55b27d'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.9.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'fb2e4d9edbf0b94ae3dd5cf0849f34c131f79c3c427afc39d07326e31b07c3ee'
      end
    end

    resource 'dartium' do
      version '1.20.0-dev.9.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.9.0/dartium/dartium-linux-x64-release.zip'
        sha256 'd58e2183d7fc8da369d413996f5f9356541472e8cc5fa33277a7ba46b4b6d99f'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.9.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '421fe70b2fa385ddaa140618a47036b8e3ec4ac10e4089ce41f536002e549187'
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
