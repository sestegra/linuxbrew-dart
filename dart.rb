require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.21.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 '71c18fefa005017a34c2381872c3b189e0a3983ff4a510821d9e862e6e2a4e91'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'a0f2e41516a322503127ef367bf81929bb08eb0b03d68c4894c9b91aa91b4e82'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.22.0-dev.6.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.6.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '657c757e74d0ed52d7abff9aa5ad478be06c248e1136c31cc1b6fe74b09cbc91'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.6.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'cf773db90d5b63ba97f80678041c2c687e77bc80db90e1bd8d9f77430b635347'
    end

    resource 'content_shell' do
      version '1.22.0-dev.6.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.6.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'e9c02efe22bd93301bf571ef6c48aae1ea718b6c1ba0cb1bd855c3a21498ea8d'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.6.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '7bf63ed82b624e0357e87cd3b960d976e3e4fbc37179cd711e319ef7b4237a41'
      end
    end

    resource 'dartium' do
      version '1.22.0-dev.6.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.6.0/dartium/dartium-linux-x64-release.zip'
        sha256 'aae88158842cbd42b6a66e568192608af9723e4f0db17380fb63ac685342c4c2'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.6.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'cfa01007d704c13650df7bf5364066f55a1d9d9416548870a2e46f2de4731410'
      end
    end
  end

  resource 'content_shell' do
    version '1.21.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.0/dartium/content_shell-linux-x64-release.zip'
      sha256 '4e8e71ae1fb8a5a1cc96da0227bacf9335ae3687a633a51f846349c2843f549c'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 'ff8171937afc68afa0d0d704d564dbd10cf3d8e7ba9a0fb4aa9412b26080fb15'
    end
  end

  resource 'dartium' do
    version '1.21.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.0/dartium/dartium-linux-x64-release.zip'
      sha256 'abc57dcdef5f1b12b3b6482ba215f19c5c1dc8ca53d43ae5832e41a41cc2ae71'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.21.0/dartium/dartium-linux-ia32-release.zip'
      sha256 'c714c9514c2cd39f62c94ddb2274c4c99b560eaeca9a715e88967167ecd33605'
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
