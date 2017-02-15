require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.22.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 'f474bdd9f9bbd5811f53ef07ad8109cf0abab58a9438ac3663ef41e8d741a694'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '7fcb361377b961c5b78f60091d1339ebde6e060ff130cbc780e935718f92e84d'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.23.0-dev.0.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.0.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '035e3ce3e5f7d1e18025d68367068da33452c30bbe16d22eee41e3db6aa41748'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.0.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '58db21d6b7ff8f28465950cb7343888a26ad9839696c455d253549749be6397f'
    end

    resource 'content_shell' do
      version '1.23.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.0.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'fa00355a56a2871ecb514b497a33e0c3c5b6564d3235ce1977b2c32ccade3a79'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.0.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'fa7fc3e3c8372497fb6b83b21d8994d37b67e00ec60f8db52a180cde44f72c8c'
      end
    end

    resource 'dartium' do
      version '1.23.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.0.0/dartium/dartium-linux-x64-release.zip'
        sha256 '0d2faed52fd227966a62730e3e28642497522cc22688d2790d2383ec293d36ef'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.0.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '828458687d79b4d859de8de9d3ad3f25c7742b2d18f08f182f98919b0325142a'
      end
    end
  end

  resource 'content_shell' do
    version '1.22.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/dartium/content_shell-linux-x64-release.zip'
      sha256 '74aeb28716b78dc59e63b09cf62862cc88bb782f642f8d2f831691e3b35ec709'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 'c9d6d96a94a3500831c74105d387ad07290027951899faf488b5cca56d083c20'
    end
  end

  resource 'dartium' do
    version '1.22.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/dartium/dartium-linux-x64-release.zip'
      sha256 '888c510ed6b7763f22f6c6188b7c2303fd4a03e467c32e45e1b5dd2ed7adcfba'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/dartium/dartium-linux-ia32-release.zip'
      sha256 'e91249d5c8ed62cf2101b7ef080068abc47185150cdb21bfae7f823803b7bc91'
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
