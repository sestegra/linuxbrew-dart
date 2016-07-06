require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.17.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 '181145500a777d2906795b5949e95ea7b4932f3701c43959d0dcfea1ef434222'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'ec71e23fa79b89703fdc4f2a85b66d33ceaff7a5de2ec31cc6b38bf556115ad0'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.18.0-dev.4.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '7e9e737b0dc272ac62514c0911474aba894bf9ffd606efb05432209165daaea7'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '569c01df5ef0ce534af1204e89704fde569a35770a61f72977f76f197e5bb336'
    end

    resource 'content_shell' do
      version '1.18.0-dev.4.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'ae250c40a630f4260dbffd3b0875df4b2e9c304d11b5ec39b8508c90537e106e'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '0b79efebfde0af9ce16055992e9092d9b8ae5b2ed7f8cee47ab0b7159bdc5bc0'
      end
    end

    resource 'dartium' do
      version '1.18.0-dev.4.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.0/dartium/dartium-linux-x64-release.zip'
        sha256 'fbaf83ffd9c0c5a562c663a80caf4b5d000f6036f1b55b4152d5d8ad437f066c'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'bf3537967e31976b0fafa1f87c6c854e1c610a71f61388c2f770ca13b1b0e6c1'
      end
    end
  end

  resource 'content_shell' do
    version '1.17.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '662335a00ee9815b2b7a7937d42ddeea63bdce71bf8407ce998e5b35b8fd6e8d'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 'adf7b41ae07522fa38905d88b6f1a7de1060e2279274ec15f92b5b976067927b'
    end
  end

  resource 'dartium' do
    version '1.17.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.1/dartium/dartium-linux-x64-release.zip'
      sha256 '5930026f13b0c5e9a555d231e8587f56175c613bb0ce365d535de7695dcd8642'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.1/dartium/dartium-linux-ia32-release.zip'
      sha256 'a1fa1198e8cb52c73217732db5a3c7d1955f0997fceae98ea7f33d47b3bb65ac'
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
