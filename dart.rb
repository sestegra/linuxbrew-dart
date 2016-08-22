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
    version '1.19.0-dev.7.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.2/sdk/dartsdk-linux-x64-release.zip'
      sha256 'e3fbb9c1e4e69371e57be4e73b96dd02211c85e462f60f978b865d63c3e3b06e'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.2/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '14ac86bbd02779d8178e5f8125121a2cc9e698417101b3fbacd40c6bc15923e9'
    end

    resource 'content_shell' do
      version '1.19.0-dev.7.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.2/dartium/content_shell-linux-x64-release.zip'
        sha256 'f530d43aad240e30c5166c7f80ac8178777e58203b738090cbe244deb4e9c53c'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.2/dartium/content_shell-linux-ia32-release.zip'
        sha256 '97d769ee6526e54dc49b44b0029edc60dbc3d7d2222b5d6160e4ea031244d6e8'
      end
    end

    resource 'dartium' do
      version '1.19.0-dev.7.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.2/dartium/dartium-linux-x64-release.zip'
        sha256 '9fde44fc81bb41bfc856edb68951bde32e0aeef06e27d423627be1fb14fe1701'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.2/dartium/dartium-linux-ia32-release.zip'
        sha256 '67f24c5dc4ba427f2b13e35e1a5a7d4b7c5c0424cf266efae5700a6cb72e79fe'
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
