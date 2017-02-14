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
    version '1.22.0-dev.10.7'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.7/sdk/dartsdk-linux-x64-release.zip'
      sha256 'e5fe21579f1969bb07cd828082fc05da0e0ca898bce878735750fccd88833bc2'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.7/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '8190d4dcd9b660816948511b6f4e32673bf4678bd3bf99f899e5271c8e5661c6'
    end

    resource 'content_shell' do
      version '1.22.0-dev.10.7'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.7/dartium/content_shell-linux-x64-release.zip'
        sha256 'fb4b547f437fc9ea378753a3dd37e8ae46fcc139786cf8526716485e200d434d'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.7/dartium/content_shell-linux-ia32-release.zip'
        sha256 '80d44f9b9707813f2d6e11bc0b91db671b82ea819a5cd8648d47e13ed3d22f46'
      end
    end

    resource 'dartium' do
      version '1.22.0-dev.10.7'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.7/dartium/dartium-linux-x64-release.zip'
        sha256 'a0aa757e4ac21e7f63fedb3b111f40803dba8627349c0e0ec063a455c6147f21'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.22.0-dev.10.7/dartium/dartium-linux-ia32-release.zip'
        sha256 'b239da6c19fbffbb830874a0524e52de156c94d187355fd535bb845dc84de998'
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
