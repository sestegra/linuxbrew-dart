require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.24.2'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.2/sdk/dartsdk-linux-x64-release.zip'
    sha256 'f774330896e60df918848075f3f1d9ada414bcce4fe81504e2646a79536eb333'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.2/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '5b71cfe2331bea13227521c101bc7b3e8cfc8418c45615e6ea9dccf056bd323b'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.25.0-dev.2.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.25.0-dev.2.1/sdk/dartsdk-linux-x64-release.zip'
      sha256 'b1c9b2a97ea90aaad9d2dc7a572979232f1590ab753edc120c02a681efb42d71'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.25.0-dev.2.1/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '04eccb205907ce36ee8dac6d89143d1a7a7e5d672e89db6756227b25bd16a053'
    end

    resource 'content_shell' do
      version '1.25.0-dev.2.1'
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.25.0-dev.2.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '0b8172f8581d334945f5a18058130d4a6a9248c28d73375022b9df4a411fe0d9'
    end

    resource 'dartium' do
      version '1.25.0-dev.2.1'
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.25.0-dev.2.1/dartium/dartium-linux-x64-release.zip'
      sha256 '5627162179fa5fde1878bf0b68449b0f5c3bb75df6c8b93faa28ce06c05890cf'
      end
    end
  end

  resource 'content_shell' do
    version '1.24.2'
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.2/dartium/content_shell-linux-x64-release.zip'
    sha256 '42ef09f2b2458db647e371ccfa3a50202200a5c61063c084c85211115d01c23f'
    end
  end

  resource 'dartium' do
    version '1.24.2'
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.24.2/dartium/dartium-linux-x64-release.zip'
    sha256 '20144321b664d8ae13a9c674a667cb1ff7d7f0cdfb0f0897804e885e73b39f6e'
    end
  end

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]

    if build.with? 'dartium'
      dartium_binary = 'chrome'
      prefix.install resource('dartium')
      (bin+"dartium").write shim_script dartium_binary
    end

    if build.with? 'content-shell'
      content_shell_binary = 'content_shell'
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
