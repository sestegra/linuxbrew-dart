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
    version '1.24.0-dev.6.9'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.6.9/sdk/dartsdk-linux-x64-release.zip'
      sha256 'b7dfaa1c565c29deae99c350fe5249719f4798ec42f4286f3f3ef35d65aac90a'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.6.9/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'aaf7bf3a5e4fef9aae331710652e6fd7b9491cfd336e93f48d762569ab0aef25'
    end

    resource 'content_shell' do
      version '1.24.0-dev.6.9'
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.6.9/dartium/content_shell-linux-x64-release.zip'
      sha256 '89d98399c81f5464598319c367d5ccb499f2bd1c5723ff96a9353176ab52301e'
    end

    resource 'dartium' do
      version '1.24.0-dev.6.9'
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.24.0-dev.6.9/dartium/dartium-linux-x64-release.zip'
      sha256 'a56e34e4efa8265337a4ba46bf752af3f80de2851be6905871632fa79eb64057'
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
