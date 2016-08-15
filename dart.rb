require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.18.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 '6247d4528ca4ad45507823df3da6b8cfb38ff93b023ab094aed1b0cb4bdaf336'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '2484535d00aaf1f75739738c87f6a54b77ae67c5628c777062bafaf7725b8cee'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.19.0-dev.6.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.6.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 'aa7c336d46f87f386f3336b1c3e860afedb7700f759ce6a2006e195619b7da8a'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.6.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '913a4fbb9369fe57c536284c747e5b7db09f0c2f68696e184390c21bebfdf292'
    end

    resource 'content_shell' do
      version '1.19.0-dev.6.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.6.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '20d147d9a0125474f3aee0fb58fe0a98f57cd138aa7a9996bf1846264db6db4d'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.6.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '1f4d555e4b9f4fdd7effa6387d303ea2ad5299459732f6d78e5ad4e3af4c9fc1'
      end
    end

    resource 'dartium' do
      version '1.19.0-dev.6.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.6.0/dartium/dartium-linux-x64-release.zip'
        sha256 'cb2a44130e4dea35ebb4e902005894d0f7e36d57e48abfaffe15b2616fd92fc2'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.6.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'a5ab78f3c513c384680caaeebd02dd8d2e7302ee2e3427ec1809bcabf84dd0a7'
      end
    end
  end

  resource 'content_shell' do
    version '1.18.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '3a150b106db2445a6b76002fd0e4876972fbbe8a654e59dcb7ab89fc03a23ba6'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 '287c8ab839de1896978cf897235afdd15f8980fffe7b97959fbe8c90e7df5c76'
    end
  end

  resource 'dartium' do
    version '1.18.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/dartium/dartium-linux-x64-release.zip'
      sha256 '3c3b8109f40a464c9b9fcf642814ee7753f50243aac75b77fe655e26d6d5123b'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/dartium/dartium-linux-ia32-release.zip'
      sha256 'a33ced75c2b794ca19b0b4fdefe4d8f09e8a3b1be12559c933129db3d57cbe1b'
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
