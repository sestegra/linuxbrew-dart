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
    version '1.24.0-dev.6.8'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.6.8/sdk/dartsdk-linux-x64-release.zip'
      sha256 '550c009cdd241eaab98133caa46b8583457a63762789b5ead63a2a5e6ed2ceca'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.6.8/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '74b56dcfb72df7fb6e1547fa74f0a3487bc257bf1f6eb0f4a2808b1a59acf536'
    end

    resource 'content_shell' do
      version '1.24.0-dev.6.8'
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.6.8/dartium/content_shell-linux-x64-release.zip'
      sha256 'd42b1de44083f1b05cb11326eeae89251378086a94c457695533dc3946929cc1'
    end

    resource 'dartium' do
      version '1.24.0-dev.6.8'
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.6.8/dartium/dartium-linux-x64-release.zip'
      sha256 '60e364690084c06ae3f60126114e1dc9960e4d666b709384259d1d268883934d'
      end
    end
  end

  resource 'content_shell' do
    version '1.23.0'
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.23.0/dartium/content_shell-linux-x64-release.zip'
    sha256 '056e68527d64269a14009adf5327bf141702bab2c0005b5bbbc38a8f164c8fa5'
    end
  end

  resource 'dartium' do
    version '1.23.0'
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.23.0/dartium/dartium-linux-x64-release.zip'
    sha256 '11b5ce6d36a981374bf6180407b6d9ee09754716108a4d4f59f5687068497817'
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
