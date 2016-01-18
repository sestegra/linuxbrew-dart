require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.13.2'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.13.2/sdk/dartsdk-linux-x64-release.zip'
    sha256 '25f7aac7bbd5142df4e1d632452fbb5678148fab5e77669f7b6571dd467611e4'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.13.2/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '6ed7c5d222d63a2bd53d501e68bd39375532454fe85d4a2beaeef920403da11b'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.14.0-dev.7.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.1/sdk/dartsdk-linux-x64-release.zip'
      sha256 'df453e5d5fb4c609db4bb0ff5dbc1093bd681dfb4abeba52a7f2c62b24396ca2'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.1/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'e8c85d1bf0c137ee3a640b9a821ba8ab2b34d9f3df65cd108d6f5e6b5fb769bf'
    end

    resource 'content_shell' do
      version '1.14.0-dev.7.1'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.1/dartium/content_shell-linux-x64-release.zip'
        sha256 '52a01fc31d043cee0d12e1bb494c1c9f9f7a5e14d071dfeb0f87e83bf7301408'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.1/dartium/content_shell-linux-ia32-release.zip'
        sha256 'ec14ae4278623fec859bd8d718d51ad4e4fc0c344700b3cd97d5e9ee17999c5d'
      end
    end

    resource 'dartium' do
      version '1.14.0-dev.7.1'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.1/dartium/dartium-linux-x64-release.zip'
        sha256 'e4b938040d412ffcca10c65bd07191b0a1c7198a19f0f88663b08eff3a1f2d2e'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.1/dartium/dartium-linux-ia32-release.zip'
        sha256 '295a83570bf89fbb8bfcb142f99f93f4c2b654f6a654f8b8316dd4a0527a7708'
      end
    end
  end

  resource 'content_shell' do
    version '1.13.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.13.2/dartium/content_shell-linux-x64-release.zip'
      sha256 'e808588ace9a8088d4c0d0be77282a4f45ea0828a1831478bd9081f65c00291c'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.13.2/dartium/content_shell-linux-ia32-release.zip'
      sha256 'b0ef13ee46623c49443570b2ba6f757e751a1ab7f072665d5a32780e933967aa'
    end
  end

  resource 'dartium' do
    version '1.13.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.13.2/dartium/dartium-linux-x64-release.zip'
      sha256 'ae77eb4869aa90aa2c3e79c375d30c5cf787671a93d1d7247a710301afdcf0ab'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.13.2/dartium/dartium-linux-ia32-release.zip'
      sha256 'a38f6724c58ea7d634a23e28cae5ea5399d9cac9495810b23b00f41f91a0b68c'
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
