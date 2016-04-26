require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.16.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 '9c30fa631bf4ef533de5e4e30093b5165195da561aa68e4e7b007d9432e75623'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 'd1f1281d4bbf517afa6e99e51d39971e929a2b8ff3fad901d6c00a40f57c75aa'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.16.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '9c30fa631bf4ef533de5e4e30093b5165195da561aa68e4e7b007d9432e75623'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 'd1f1281d4bbf517afa6e99e51d39971e929a2b8ff3fad901d6c00a40f57c75aa'
    end

    resource 'content_shell' do
      version '1.16.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '3fb0c1d3daef35d1884a22e81973c2e2c441de30010cc771b21ec53d5a6c64f1'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '4b26ec48fe984db6e6ccfc914281f36041242381885efcc8972736774cd9dba6'
      end
    end

    resource 'dartium' do
      version '1.16.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0/dartium/dartium-linux-x64-release.zip'
        sha256 '1f90cbfa9862597a92378642c10f9945608e3d6794bfd574189c57a3550d5abb'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.16.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '514d210e73697b56661226abc2708c62bccd29ea4fef906dfc3e51064ad2242d'
      end
    end
  end

  resource 'content_shell' do
    version '1.16.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.0/dartium/content_shell-linux-x64-release.zip'
      sha256 '3fb0c1d3daef35d1884a22e81973c2e2c441de30010cc771b21ec53d5a6c64f1'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 '4b26ec48fe984db6e6ccfc914281f36041242381885efcc8972736774cd9dba6'
    end
  end

  resource 'dartium' do
    version '1.16.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.0/dartium/dartium-linux-x64-release.zip'
      sha256 '1f90cbfa9862597a92378642c10f9945608e3d6794bfd574189c57a3550d5abb'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.16.0/dartium/dartium-linux-ia32-release.zip'
      sha256 '514d210e73697b56661226abc2708c62bccd29ea4fef906dfc3e51064ad2242d'
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
