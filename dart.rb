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
    version '1.18.0-dev.1.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.1.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '5a67c2b7aa0ba17e190388705e8aa9914a31b284ec3a7f72626783cb399d0321'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.1.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '0875f04b3e2aa036a20331dd9ffefd4e869d5fe29b598821e459e718597fe418'
    end

    resource 'content_shell' do
      version '1.18.0-dev.1.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.1.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '7308d6b6e330cdc7cf7dad056d730ab95e21c6f0daa7d055c3f84fb565541332'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.1.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'b7dae5e6b17b010ee0877355b85f55a04569c06e5108a33b3ca63534ebf67a90'
      end
    end

    resource 'dartium' do
      version '1.18.0-dev.1.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.1.0/dartium/dartium-linux-x64-release.zip'
        sha256 '4822d2847fb8e07168748dea325b6d8eaa240843e377b38e5c9a818f00c6d3f1'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.1.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '3dcfaa62f28dd793c474929d73c05e3c19a479635f5b4b34308b69eb4cd57f0b'
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
