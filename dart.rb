require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.15.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.15.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 '159f360cd09b3b8247bc241193265f5b3b9d8111727c2a031ba4473424f65864'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.15.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'a0d9af1eceaed0552d6f063080967fabc26f7753666824e4c7783fe0dac6c94a'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.16.0-dev.5.5'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.5.5/sdk/dartsdk-linux-x64-release.zip'
      sha256 '7b3b3db5214566ae329458d56fc418ca913afacbb2cd513eb54c774bdde5028b'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.5.5/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '2cabaa457a22cc47aedf2eeefa1b81d1b33a78a01386dc32ef108b7902a24117'
    end

    resource 'content_shell' do
      version '1.16.0-dev.5.5'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.5.5/dartium/content_shell-linux-x64-release.zip'
        sha256 '078e5c7602ef32b29d742b6a7a0b936773cf1dbe1f193ce46a2f94118ce7ff25'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.5.5/dartium/content_shell-linux-ia32-release.zip'
        sha256 '89f6545e48c3ee313a63c1628ad1ae6d30462758f5c48f3f76e3ad3ed148036c'
      end
    end

    resource 'dartium' do
      version '1.16.0-dev.5.5'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.5.5/dartium/dartium-linux-x64-release.zip'
        sha256 '3b5f37e2eb79a9cb7f12c671df18f00ff336dcabcb2f71b1bbed06bd3a8e3176'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.5.5/dartium/dartium-linux-ia32-release.zip'
        sha256 '25cc2d15eeb44e484243610bdfca91c974591dd3a00e8c5014aefc5e8a8842ba'
      end
    end
  end

  resource 'content_shell' do
    version '1.15.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.15.0/dartium/content_shell-linux-x64-release.zip'
      sha256 '8e4ea26e0df4a6b37b2dd7e11465e6ac68e46e4813bf1b9bb741928fd382d853'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.15.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 'f387bf2517cf97537b30d6091f363dae3fc4fe619c63c8fe0190a2491c662846'
    end
  end

  resource 'dartium' do
    version '1.15.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.15.0/dartium/dartium-linux-x64-release.zip'
      sha256 'bd85b422bc461884918161d18593519d6a4b7c1b29f88c4481ddfe1269d7ce72'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.15.0/dartium/dartium-linux-ia32-release.zip'
      sha256 'c6c742849b06b463b32ddc0354ddbee017907ed54a0fdc60c71c6ad7e85f52f5'
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
