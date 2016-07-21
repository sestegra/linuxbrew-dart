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
    version '1.18.0-dev.4.4'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.4/sdk/dartsdk-linux-x64-release.zip'
      sha256 '769ad3c1af099e575e6a17d3c817f39473899f8d956fa68d8c4a30ed196b9f2d'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.4/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'a88fb65764c9e3cc9f99516493949e20d0b2785345c184e3e6df32b5bd7a1a2e'
    end

    resource 'content_shell' do
      version '1.18.0-dev.4.4'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.4/dartium/content_shell-linux-x64-release.zip'
        sha256 '39e5b2d4a861b9872874b0847cf38e1d48d0ec2e105981e3dda4a4a147b4cd1c'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.4/dartium/content_shell-linux-ia32-release.zip'
        sha256 '5a94691ded5f52a002c33e34cd6a0e9fa7ee5268e00b599700314efde31e811d'
      end
    end

    resource 'dartium' do
      version '1.18.0-dev.4.4'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.4/dartium/dartium-linux-x64-release.zip'
        sha256 '8adc30100196d0ebfa10e8520f1122d13f2c0d09554feff6c799e3d02ccf98e2'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.4/dartium/dartium-linux-ia32-release.zip'
        sha256 '026db3bace5e72c3d541c98f1ea4fa4105909e4bb2cb330c35b6762271165b82'
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
