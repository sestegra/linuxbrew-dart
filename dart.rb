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
    version '1.19.0-dev.7.3'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.3/sdk/dartsdk-linux-x64-release.zip'
      sha256 '70b5e3c095adf0942d8e04ee6f11fbb3184a6c0602d2bb90bbee9e789cf1fa52'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.3/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '0195bcbad22e960444017cee3fdda70e1953c72ba21baa8ade4fa63f50ad6b2d'
    end

    resource 'content_shell' do
      version '1.19.0-dev.7.3'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.3/dartium/content_shell-linux-x64-release.zip'
        sha256 'c488f6ae25332c9bae799d7dc1a7042380816a61c7fd99ac31c3a48255e45b36'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.3/dartium/content_shell-linux-ia32-release.zip'
        sha256 '975a2d1ed69b7723ce85549744751a1ec0d81e64126f61d70569535757f952d2'
      end
    end

    resource 'dartium' do
      version '1.19.0-dev.7.3'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.3/dartium/dartium-linux-x64-release.zip'
        sha256 '7870fe1c74eff7bc01ea8778f409e2916b4b0378d4fce1bf43ef164b183eb704'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.19.0-dev.7.3/dartium/dartium-linux-ia32-release.zip'
        sha256 '33c0cb7ddb6a53e487cde4940c44459cb1913891e12e47b1fcf8043c9fd72984'
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
