require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.23.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.23.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 'f57b4bdf64961963cf82362bf3834b058aa1db838a0c4543689c73e304718563'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.23.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '2add504a7b4b8de2dad151e86894c17f04abb31eaa2fb475cf00d4ad1281a6e6'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.24.0-dev.4.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.2/sdk/dartsdk-linux-x64-release.zip'
      sha256 '229a6d99cfee5c4798ca81d3e5c5633271c566869c74505ee3e1c90c789211ba'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.2/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '34549f6fc54fb34e1e200af9d13c71e981b4d17e86b3d0e13b949be923d955e6'
    end

    resource 'content_shell' do
      version '1.24.0-dev.4.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.2/dartium/content_shell-linux-x64-release.zip'
        sha256 '2ed0f1abafea836461e7789b4caacc0ee10893a4768b69405d935e92130b9db8'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.2/dartium/content_shell-linux-ia32-release.zip'
        sha256 '&lt;?xml'
      end
    end

    resource 'dartium' do
      version '1.24.0-dev.4.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.2/dartium/dartium-linux-x64-release.zip'
        sha256 '545b7f769e3baac8152e63c2184560e3073270a787896aee76b6f1b60a887a85'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.2/dartium/dartium-linux-ia32-release.zip'
        sha256 '&lt;?xml'
      end
    end
  end

  resource 'content_shell' do
    version '1.23.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.23.0/dartium/content_shell-linux-x64-release.zip'
      sha256 '056e68527d64269a14009adf5327bf141702bab2c0005b5bbbc38a8f164c8fa5'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.23.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 '&lt;?xml'
    end
  end

  resource 'dartium' do
    version '1.23.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.23.0/dartium/dartium-linux-x64-release.zip'
      sha256 '11b5ce6d36a981374bf6180407b6d9ee09754716108a4d4f59f5687068497817'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.23.0/dartium/dartium-linux-ia32-release.zip'
      sha256 '&lt;?xml'
    end
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]

    if build.with? 'dartium'
      dartium_binary = 'chrome'
      prefix.install resource('dartium')
      (bin+"dartium").write shim_script dartium_binary
    end

    if build.with? 'content-shell'
      content_shell_binary = 'content_shell'
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
