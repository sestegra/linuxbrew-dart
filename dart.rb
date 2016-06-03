require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.16.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 'c20a740b35a90418c6c6ef7213262146dfd4e8fef5de1d6bbe9c8b0611b38b05'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'a34fef18d766c85dcd31ce06ea0a7a8516b1e64a3a1535932c96cc2507fbdc49'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.17.0-dev.6.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.2/sdk/dartsdk-linux-x64-release.zip'
      sha256 '1f1bef106533ef5f4d5889d8912df4e6e841f5114faaec3e7edf90be78d60841'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.2/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'f63615f20fbb8dd23dce952d9f299575ae92b61c689c1e7988ec64059133dc0a'
    end

    resource 'content_shell' do
      version '1.17.0-dev.6.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.2/dartium/content_shell-linux-x64-release.zip'
        sha256 'fb91b2fef37516ffd9a70be1ec2a3dbd3069527a90120456b952a766e08c19eb'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.2/dartium/content_shell-linux-ia32-release.zip'
        sha256 '396af66f7e448963651f57b5c2a1907039de24c744e5a37a68dbaa348a8c615a'
      end
    end

    resource 'dartium' do
      version '1.17.0-dev.6.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.2/dartium/dartium-linux-x64-release.zip'
        sha256 'b7f02f4d381ab5c217cfd5194c9d4e61bddbaf861456826cab6cde1bae450bc5'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.2/dartium/dartium-linux-ia32-release.zip'
        sha256 'f28840c724aebc745d4c91818569d61d1c67e1def99cd8d42ea5674f5895af6e'
      end
    end
  end

  resource 'content_shell' do
    version '1.16.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '122c165d425aba60fa5be99321a837dbfefc1529029d87db9181d1f3ab93ef8e'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 '&lt;?xml'
    end
  end

  resource 'dartium' do
    version '1.16.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.1/dartium/dartium-linux-x64-release.zip'
      sha256 'e5c72ac5335cdbf68e2c0478a206ff8483bcc551cee4381caad1b68520f01e75'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.1/dartium/dartium-linux-ia32-release.zip'
      sha256 '&lt;?xml'
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
