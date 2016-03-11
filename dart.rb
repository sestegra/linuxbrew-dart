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
    version '1.16.0-dev.0.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.0.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '9ea5118637d936ff08c3614be775803ceed27a49bc6a01437e779dc119a02623'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.0.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'ed929dc0958ded61e059d0b94354c3dc1440198d110510cfd05cc119b78229b8'
    end

    resource 'content_shell' do
      version '1.16.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.0.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '584cbdd988ed17c714850f1904044cdde6dcb69495c4fc8658ba1d679a0e1e96'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.0.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '2f92f0e261efebea15a9472c0f29cb598de73017e6fba5b65afeb6c21aa6352c'
      end
    end

    resource 'dartium' do
      version '1.16.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.0.0/dartium/dartium-linux-x64-release.zip'
        sha256 'd06e14cb2b7ad90fceb481f1252271af717f58e84b9d48ed4ce355a22644ad06'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.0.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '6dd678fa3660bfb086e6241c13de415b11f175ab978d5ce2824ddf59738a5ca3'
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
