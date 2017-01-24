require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.21.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 '40a5ddbaf5bf911120c2ebe78c7c1eb01c858146e6ffa1c5cdc6cbc1ad12cfda'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '607a4178be9368a1ce20bb585db35953c32a2c677607234c7bfd4a208c1335c9'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.22.0-dev.9.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.1/sdk/dartsdk-linux-x64-release.zip'
      sha256 'f5b4213a43a1ed0e2c19a5680a4be5ebc8d519ff02f3583e1683b39d22ad8152'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.1/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'e62980d3bcc0cb43cb1207b5a8e5440549931ea3c45cba3b7f0998e45eed8ac2'
    end

    resource 'content_shell' do
      version '1.22.0-dev.9.1'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.1/dartium/content_shell-linux-x64-release.zip'
        sha256 '2d1e7c1aac724bcee96441c2902c53f8a258b1b475cf4a22bc5342ae5f07be01'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.1/dartium/content_shell-linux-ia32-release.zip'
        sha256 '132de0da2173b631845a5969f9a4e8e6a57312570379cc659312d26029583c33'
      end
    end

    resource 'dartium' do
      version '1.22.0-dev.9.1'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.1/dartium/dartium-linux-x64-release.zip'
        sha256 '52029e6e289df4e73f2086d42201870819843ff299ec1181c9cff792198c577b'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.1/dartium/dartium-linux-ia32-release.zip'
        sha256 '70693cbe757fbb6852cd2e0cf0d75e706f977ced81d2b49a8aa42d79e489b288'
      end
    end
  end

  resource 'content_shell' do
    version '1.21.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '686abb96a0731974412bf181c1a894254a78848d547ce1d2bc6b5181125d2897'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 '1a783b201cca1e70079201986feb2f18cfbf90ac2faa5b5d64b918a875b059cb'
    end
  end

  resource 'dartium' do
    version '1.21.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/dartium/dartium-linux-x64-release.zip'
      sha256 '375cbc567a0cf270529c678dd0f544dcb8af80d5ff2471d9c5c4ce195fc498df'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/dartium/dartium-linux-ia32-release.zip'
      sha256 '8ef7433ea25b92304c06103975a3964e52234a0a74c55b83979dab2a8ca96058'
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
