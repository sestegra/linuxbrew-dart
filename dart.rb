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
    version '1.14.0-dev.6.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.6.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '7c092bc9338dd9de32458e9d934c7f855611e27b19e1dfb9eb68a9a53d6feb80'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.6.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '073db442cfd3d04571f8e0f050fc4793a946908db1002937f7333748970eef62'
    end

    resource 'content_shell' do
      version '1.14.0-dev.6.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.6.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '72b1612fbb7ca2cd00ace59ccecccda2dee44a7f9153307f2183ab5f65ef5ccd'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.6.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '242e679c91f323629ffef22cac469d009cc5102498df8656dba15ae78ddb8704'
      end
    end

    resource 'dartium' do
      version '1.14.0-dev.6.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.6.0/dartium/dartium-linux-x64-release.zip'
        sha256 '1c9681211e933f51583bf838de1cd149c8ac5918782c1e505edb82334c2126cf'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.14.0-dev.6.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'b44e741cfdf6620c3274487bf41de7918656eed5e6494d4802695b7fba83c6bd'
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
