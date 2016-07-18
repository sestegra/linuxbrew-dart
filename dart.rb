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
    version '1.18.0-dev.4.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.2/sdk/dartsdk-linux-x64-release.zip'
      sha256 'd9e0183f36de454e5165dc4b604749eb9565954ca88484f85e09d2c8697fb296'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.2/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'e68a16610c8cb477475d30cf7a725564f51fc15798b5670300e99cf4d806ab9b'
    end

    resource 'content_shell' do
      version '1.18.0-dev.4.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.2/dartium/content_shell-linux-x64-release.zip'
        sha256 '52c16a9c0f4c1d48c7b381104c78fb4456193e4681170d972d6d6156e7a51fe4'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.2/dartium/content_shell-linux-ia32-release.zip'
        sha256 'e6465a16b2a1ee83392b2ba6e2f62b1a73088c68fcd4bb663f6ede8d551ba00e'
      end
    end

    resource 'dartium' do
      version '1.18.0-dev.4.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.2/dartium/dartium-linux-x64-release.zip'
        sha256 '487f742c2ed6478dfc3376f5c2f6a7ad9a468b3bac747f1a20bc9f8708231d80'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.2/dartium/dartium-linux-ia32-release.zip'
        sha256 '855e72a2d82542748b45325b92b01230004b483d2ca4e66b4645943ce90f32d0'
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
