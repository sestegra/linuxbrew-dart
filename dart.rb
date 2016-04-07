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
    version '1.16.0-dev.4.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.4.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '57cbabd5a01031d8ccda6f298cdb94bb8098aae611d881e0a5c864da6a2f6605'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.4.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '3ccb7c874b6fc8c6dc621ebc0b7986c50c21844c7298dbc31f24d34fe7688533'
    end

    resource 'content_shell' do
      version '1.16.0-dev.4.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.4.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '855885112f77026dfefd963178e8a985bade5b1a19c31864d6010eed9a19c7e4'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.4.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'abea5ac4abaad4372ca1bd3e1fb6d5f1a9d4d7f105994d9caa4e5d7356011767'
      end
    end

    resource 'dartium' do
      version '1.16.0-dev.4.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.4.0/dartium/dartium-linux-x64-release.zip'
        sha256 '06b978f45ddca0b75512e594bdefb47f65da8008b7c0850505014b7463751d07'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.4.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'd01d19a3687c874211eaf0682b6ccc699f20cec1d2cb44ef80b0c545210b5d78'
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
