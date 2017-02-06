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
    version '1.22.0-dev.10.4'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.4/sdk/dartsdk-linux-x64-release.zip'
      sha256 '0a337447d4a2fe9824a4b5f0e13ead8e2ea3330703aa3fec2f5e77638d5e2a4b'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.4/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '883af222f97c87b4d2106452c2ec0779d1d4d3c610770bc96412f75a6e6f73c4'
    end

    resource 'content_shell' do
      version '1.22.0-dev.10.4'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.4/dartium/content_shell-linux-x64-release.zip'
        sha256 '463d95c0b09588184575a4df3b92128118ff3fae0fa26cea5064a23384830d83'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.4/dartium/content_shell-linux-ia32-release.zip'
        sha256 'c493a3fc11ae445cd44d9b54ccc250401f2eb178988df2d9cd3232d2c92e18de'
      end
    end

    resource 'dartium' do
      version '1.22.0-dev.10.4'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.4/dartium/dartium-linux-x64-release.zip'
        sha256 '958df11d710fbbaa268bbf3bba7443e9839488af4ac6bb8870d03aee549bd7d1'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.4/dartium/dartium-linux-ia32-release.zip'
        sha256 '06a7c1acb7f88cb9b918ac754078f424fffa44de6d472fccb0ab63769a78d277'
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
