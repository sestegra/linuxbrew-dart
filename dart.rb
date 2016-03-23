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
    version '1.16.0-dev.2.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.2.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '6b894843d19c5bbc57c3523ad9ce5206607814f0c57bdc76a81f942f5f5e2765'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.2.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '201053898546e226c956e446181ca04f71b80d896ca57f0cf47d28182d3d6b48'
    end

    resource 'content_shell' do
      version '1.16.0-dev.2.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.2.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'a56393ff615542e6d7545d96c6f3f10e4ac7707ee90c2a5560ca4fa1fbe342d3'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.2.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'd8e04659742796499e7062ae0cfef8c5ba3b36abc159a818686fa2aa9043c848'
      end
    end

    resource 'dartium' do
      version '1.16.0-dev.2.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.2.0/dartium/dartium-linux-x64-release.zip'
        sha256 '7c021df23b1e099ddeb7513ab2fea7c253f1fe07119f12132a80ca417da22a44'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0-dev.2.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'a4742b4bf97cc197b8934b4c61d7b5cbfe6094ab41d3cf5397e9f5ccb5fc67f3'
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
