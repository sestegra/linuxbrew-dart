require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.18.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 'c2dfe8a548eb4920ca879d4329cfecaa140dd5a07291fd7ea9b8dd2f51452a08'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'f1d5179330044350a4506a108169f296cf3ac125404ad529eff87b235cb2da66'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.19.0-dev.2.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.2.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '7c4d0ae79f6b41a84bedaa7678fc6effe7b9aecf095dc6cd84cde42df93d20ce'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.2.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '30660b27ab294b10ccf6c8bf4890cde03d0b50c2554508897cdf4656eebb040f'
    end

    resource 'content_shell' do
      version '1.19.0-dev.2.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.2.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '6f1c36220d383a8a543da3323e097418b093851ed100563d9d82f2ada993b5d6'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.2.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '13feb3991dfa4f1c30b15458eb63fc4c0d45145acbc51b95836483da3b6c40b8'
      end
    end

    resource 'dartium' do
      version '1.19.0-dev.2.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.2.0/dartium/dartium-linux-x64-release.zip'
        sha256 '0d0e009b456ed9cddcd22d0beddbad612cd9ab90b637b3f7cab3f35485553daa'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.2.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '8a2535bc648e8ebb0b56f191245e878267fa574d4ad4d27564ff505abe5d066b'
      end
    end
  end

  resource 'content_shell' do
    version '1.18.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.0/dartium/content_shell-linux-x64-release.zip'
      sha256 '052e9efd08abf5aa7d9cb67d307b82100ede1a064b76ce47e91c839c869934c6'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 'b280b82d99e0f1784e9c2baa02261c7a8f5b33b5311d604c19b6fe95bb62017d'
    end
  end

  resource 'dartium' do
    version '1.18.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.0/dartium/dartium-linux-x64-release.zip'
      sha256 'a1e68c82ffe8924aabfcffb2cb5ebce2aac9dcbd4fba71fafae13778fb7a64a5'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.0/dartium/dartium-linux-ia32-release.zip'
      sha256 '50e9b07aa85f2eafc0d927feaf48865e6a4ba5c288c116ffa3852a7f6262e4a3'
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
