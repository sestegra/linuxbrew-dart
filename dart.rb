require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.18.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 '6247d4528ca4ad45507823df3da6b8cfb38ff93b023ab094aed1b0cb4bdaf336'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '2484535d00aaf1f75739738c87f6a54b77ae67c5628c777062bafaf7725b8cee'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.19.0-dev.7.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '1d6f74af90b3701a6b5a3af6c7fc118b6f9ff11eafc5f2969cf3cf8c6699a94e'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'dbcf4c6b51689d420f378a1328c10aa2a1ff343b4a3cd9dda9146f4a37375a12'
    end

    resource 'content_shell' do
      version '1.19.0-dev.7.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '403c4c9d5057f664af5aa0b39feea2236f58283f357174d2fac11dde2dc2b766'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '7a4f2659e9265dea8785c3405bb201df4cd41dd7322e38c20e54fa519151704f'
      end
    end

    resource 'dartium' do
      version '1.19.0-dev.7.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.0/dartium/dartium-linux-x64-release.zip'
        sha256 '12acbda3714598b5af0a7039c1b14eaff37fbac6d747dabcb7f7a6e2a02843fb'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'abb765507448a811b8509a843d2cba2096729b9788d9ba17f539619a8bc06cd3'
      end
    end
  end

  resource 'content_shell' do
    version '1.18.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '3a150b106db2445a6b76002fd0e4876972fbbe8a654e59dcb7ab89fc03a23ba6'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 '287c8ab839de1896978cf897235afdd15f8980fffe7b97959fbe8c90e7df5c76'
    end
  end

  resource 'dartium' do
    version '1.18.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/dartium/dartium-linux-x64-release.zip'
      sha256 '3c3b8109f40a464c9b9fcf642814ee7753f50243aac75b77fe655e26d6d5123b'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/dartium/dartium-linux-ia32-release.zip'
      sha256 'a33ced75c2b794ca19b0b4fdefe4d8f09e8a3b1be12559c933129db3d57cbe1b'
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
