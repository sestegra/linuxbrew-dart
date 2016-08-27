require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.19.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 '032c623d1189305f024a0d0f8da9686e640ef64fa2903b856879322401e489bd'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'b78ff13f09c290a78af2992b0ddd0ff660c47fad0566abec566b5954aa0a472d'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.20.0-dev.0.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.0.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 'b190d7426363319adf83ec15f7d155eee24d70b9d9368b61a2d4a7a7168f0e9c'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.0.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'af873bc15c0b39cb01bff51ed410acdc1df6a73cd97fb3b913fbccf32b2926bd'
    end

    resource 'content_shell' do
      version '1.20.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.0.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '6911f07f155a0e58dbc3e539a393706bea9657a4e1dabb29c371bd9cc5d7b19a'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.0.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '4b9981dd2347fd0224ca9f7d88b759e269a71e82dcfbbf4123017d14918cd2ef'
      end
    end

    resource 'dartium' do
      version '1.20.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.0.0/dartium/dartium-linux-x64-release.zip'
        sha256 'fcef6a32ac64a30c10fa072ad900489728f44e45f933172988e8059155c4ee8d'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.20.0-dev.0.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'f0fa5c27124aa74b034d2673684a21f92851bb11b7f0509783253c68a6330ba9'
      end
    end
  end

  resource 'content_shell' do
    version '1.19.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/dartium/content_shell-linux-x64-release.zip'
      sha256 'f22e8bc3c1a69ec00b895a607319bc2b329573d9d186a70c43423d9ac303fa79'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 'af82ce44a2d596ce0c7cf21a803dd4539a9598e1cff33b136c74897b2219aaa7'
    end
  end

  resource 'dartium' do
    version '1.19.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/dartium/dartium-linux-x64-release.zip'
      sha256 'a5de751685e4fb48da45babb3d5d50b7dfe0bf657f4fab79706ab8978e048f53'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.19.0/dartium/dartium-linux-ia32-release.zip'
      sha256 'fd1cf1c990b8f246a01bcb2745f4936c6309a2797994822c445025477c0e8e18'
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
