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
    version '1.24.0-dev.4.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.1/sdk/dartsdk-linux-x64-release.zip'
      sha256 '43bad5e35e8f5f26943d5d2221e6e01babae0556160fc2882239107acf9ebfd0'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.1/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'd3033960887f48bd15f2d0c91771796311829793840856896959aa4552e7061c'
    end

    resource 'content_shell' do
      version '1.24.0-dev.4.1'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.1/dartium/content_shell-linux-x64-release.zip'
        sha256 'db84b0fea2be94d1cb21985a9c7a7e8a397d0232d3d42adfb69513ee24e07fa0'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.1/dartium/content_shell-linux-ia32-release.zip'
        sha256 '&lt;?xml'
      end
    end

    resource 'dartium' do
      version '1.24.0-dev.4.1'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.1/dartium/dartium-linux-x64-release.zip'
        sha256 'cdaa3fd884afccf7f0635c9751ea1c131b84d2b0ffacdd492b59ecce1fcbac9a'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.4.1/dartium/dartium-linux-ia32-release.zip'
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
