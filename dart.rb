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
    version '1.17.0-dev.6.4'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.4/sdk/dartsdk-linux-x64-release.zip'
      sha256 '1df8fd670fbf9b56631d03de2b6411c59544d004bdc362aa2530ab78c8dd0c35'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.4/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '802565cdc2bae02796a856db2f9340a254e94ba3a9fbaee42ac69ba2cdef35bf'
    end

    resource 'content_shell' do
      version '1.17.0-dev.6.4'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.4/dartium/content_shell-linux-x64-release.zip'
        sha256 'e9bd9bf5af14fb24e62a70bb91713a9a1aa4f8cef6c85e3e51aa0993cb53b737'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.4/dartium/content_shell-linux-ia32-release.zip'
        sha256 '1d9f8a9bf4037e6d6211fdd093f5895ae8e3283032e8d6b5be0a36caa84c3c66'
      end
    end

    resource 'dartium' do
      version '1.17.0-dev.6.4'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.4/dartium/dartium-linux-x64-release.zip'
        sha256 '439611d95f1ef0e0225977f70e42c957aa6e5e0d223956366ef3c4b45f727429'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.17.0-dev.6.4/dartium/dartium-linux-ia32-release.zip'
        sha256 '011e60f0b105e33ab8977f451da08d128e0b05e0d057a4aab3edfb772a3c58b3'
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
