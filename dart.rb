require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.22.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 'f474bdd9f9bbd5811f53ef07ad8109cf0abab58a9438ac3663ef41e8d741a694'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '7fcb361377b961c5b78f60091d1339ebde6e060ff130cbc780e935718f92e84d'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.23.0-dev.1.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.1.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '97bec45048847f4c38dfcac126d2f4f6245fb097b11afc934d5a5aadda88d4a1'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.1.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '55d35f924b9ac6d4e930854a1f3e6d704aba0eac424cd806b736cde394ae14b4'
    end

    resource 'content_shell' do
      version '1.23.0-dev.1.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.1.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '4a590e9f56e3695c9c3d31e0882c44a1cfe7000a7309466275ea3fcbc486a2f4'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.1.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '&lt;?xml'
      end
    end

    resource 'dartium' do
      version '1.23.0-dev.1.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.1.0/dartium/dartium-linux-x64-release.zip'
        sha256 'ad31b35c4c471aa4b26831682cd7b9a5d353a0c2b68ac18e2b95387904f5a53a'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.23.0-dev.1.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '&lt;?xml'
      end
    end
  end

  resource 'content_shell' do
    version '1.22.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/dartium/content_shell-linux-x64-release.zip'
      sha256 '74aeb28716b78dc59e63b09cf62862cc88bb782f642f8d2f831691e3b35ec709'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 'c9d6d96a94a3500831c74105d387ad07290027951899faf488b5cca56d083c20'
    end
  end

  resource 'dartium' do
    version '1.22.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/dartium/dartium-linux-x64-release.zip'
      sha256 '888c510ed6b7763f22f6c6188b7c2303fd4a03e467c32e45e1b5dd2ed7adcfba'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.22.0/dartium/dartium-linux-ia32-release.zip'
      sha256 'e91249d5c8ed62cf2101b7ef080068abc47185150cdb21bfae7f823803b7bc91'
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
