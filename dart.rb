require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.24.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 '9c9261e556581035a0a9227efbfde2416317446249db87567a7ccb3b5cc6120b'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'def1e1fb216d50541f77010ed32f87fa06db1a8b34c83bd48e20262c460c3614'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.25.0-dev.0.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.25.0-dev.0.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '6def618759a4f063149f3183ff668df330bf4f0154b3918191c7ddc90921a3f6'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.25.0-dev.0.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '072bf854852bd6608ec29d6aa3e42ba91fc21caea54f37a82ec7748a35e74274'
    end

    resource 'content_shell' do
      version '1.25.0-dev.0.0'
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.25.0-dev.0.0/dartium/content_shell-linux-x64-release.zip'
      sha256 '767bd3cf396832c02dc6cc8da53e8918dbe2ad963ba86ba55503f9678f3ebb32'
    end

    resource 'dartium' do
      version '1.25.0-dev.0.0'
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.25.0-dev.0.0/dartium/dartium-linux-x64-release.zip'
      sha256 '61aed87dbe28701ecf94add121d9b92bbb2f4e8d29a413f48e94220d0c1c7a7f'
      end
    end
  end

  resource 'content_shell' do
    version '1.24.0'
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.0/dartium/content_shell-linux-x64-release.zip'
    sha256 'c4d62a946f1bd7d348d33d16543352dc0de144149b133ff64922958f1177edfc'
    end
  end

  resource 'dartium' do
    version '1.24.0'
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.0/dartium/dartium-linux-x64-release.zip'
    sha256 '1085d5b62b4cacbbe64bb7f5b29458f4314b8883a1163a94c7f5ab0d55dcda10'
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
