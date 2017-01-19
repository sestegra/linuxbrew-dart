require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.21.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 '40a5ddbaf5bf911120c2ebe78c7c1eb01c858146e6ffa1c5cdc6cbc1ad12cfda'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '607a4178be9368a1ce20bb585db35953c32a2c677607234c7bfd4a208c1335c9'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.22.0-dev.9.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 'd250c7d68ee45354e0599003e8730788b1ddd1d3148184f8eeeb121cbd78ecc4'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '0c4a9a778b53e81204b926463bb5a54596f05de6fb8cbfdeeeff73cd07b6d797'
    end

    resource 'content_shell' do
      version '1.22.0-dev.9.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'a38930dc863d30d71ebbbfc59f04d3443e94c95a3b4fd4a4c560e9a9ca500c1e'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '659863b5a679a52396752afb6b89fa6aaa1c4f0dda0c08b66e8803cb0f92f2c0'
      end
    end

    resource 'dartium' do
      version '1.22.0-dev.9.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.0/dartium/dartium-linux-x64-release.zip'
        sha256 '5ddf33322c4113278e947e436623fff07c1e76eee1885ed54b810909f56cc8ef'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.9.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '2c1655e5ad1ce719111b151cb127815368c4e6239af210840bf55d2df9578307'
      end
    end
  end

  resource 'content_shell' do
    version '1.21.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '686abb96a0731974412bf181c1a894254a78848d547ce1d2bc6b5181125d2897'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 '1a783b201cca1e70079201986feb2f18cfbf90ac2faa5b5d64b918a875b059cb'
    end
  end

  resource 'dartium' do
    version '1.21.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/dartium/dartium-linux-x64-release.zip'
      sha256 '375cbc567a0cf270529c678dd0f544dcb8af80d5ff2471d9c5c4ce195fc498df'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.1/dartium/dartium-linux-ia32-release.zip'
      sha256 '8ef7433ea25b92304c06103975a3964e52234a0a74c55b83979dab2a8ca96058'
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
