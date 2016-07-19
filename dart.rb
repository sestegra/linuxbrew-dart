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
    version '1.18.0-dev.4.3'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.3/sdk/dartsdk-linux-x64-release.zip'
      sha256 'd81a1912205fb356e8de6fe6fdc418b2d58ff4c08b9e88c968935c21326ab6ec'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.3/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'c6199ea7a8de518b375d419c9bcb42a420dc209bf24598ccd3cde88eadf3b78a'
    end

    resource 'content_shell' do
      version '1.18.0-dev.4.3'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.3/dartium/content_shell-linux-x64-release.zip'
        sha256 '3cdc390e96e92779e4779595f354f8f31147fa190ce2fdc70d632e80bc841395'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.3/dartium/content_shell-linux-ia32-release.zip'
        sha256 '63509bd04d8068d87edac9457743b2344012e6cdc78f2e652052edf864e3f521'
      end
    end

    resource 'dartium' do
      version '1.18.0-dev.4.3'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.3/dartium/dartium-linux-x64-release.zip'
        sha256 '3d943a3a31442139439b4e47042c3d9d28f0d92b8314ee25d649d4ed0fffc99f'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.4.3/dartium/dartium-linux-ia32-release.zip'
        sha256 '4fba27145a7f8818ce8633e67b5ee2af1d541a8e231b31f3c5158bc31b5fe06c'
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
