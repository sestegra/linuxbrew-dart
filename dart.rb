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
    version '1.14.0-dev.7.2'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.2/sdk/dartsdk-linux-x64-release.zip'
      sha256 '16c2648b64d86c1cb93f6bc7fb92e209d6195fe23312ab5341c58dfdccb04993'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.2/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '2e0de0fd629c434d738d783c8dd57168cc1c77ee0e02da00e0d4158e36f2fc34'
    end

    resource 'content_shell' do
      version '1.14.0-dev.7.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.2/dartium/content_shell-linux-x64-release.zip'
        sha256 'bd5a7a174b88d9dcfad810119dc367292de7b9d98d5dc1791838d33f1ee3a87e'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.2/dartium/content_shell-linux-ia32-release.zip'
        sha256 'f487349befa6e9eea64630fded8c0ba905351676108f90baa5712a647a0f8300'
      end
    end

    resource 'dartium' do
      version '1.14.0-dev.7.2'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.2/dartium/dartium-linux-x64-release.zip'
        sha256 'c3172036e2b0dd3b8ec274cc784ee0a9197b050ce9a326c03479a45cdbe7d3f6'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.7.2/dartium/dartium-linux-ia32-release.zip'
        sha256 'b22cd43b0c04406fd1c6f093bd5c9661175cd94e69f5d8683515f182397183cd'
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
