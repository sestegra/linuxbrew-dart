require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.17.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 '7e0cd2d9d2a0ca59efb901a3155357e73a773a90b5f827c5022540204a25b143'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '7aaf3cea34401327195f90a01427e2a59038e2dd3f4e75602c0a59a80c4cc13d'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.18.0-dev.0.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.0.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '8b936764dee41c8554d1f95bf9ddc48d20a7b5711b6cb28f28aaf2c839f54f25'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.0.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '895e7f704ec9ecc5e6239d79ae6737980f506c74a080b3553e9fc59c09704650'
    end

    resource 'content_shell' do
      version '1.18.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.0.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'e5ca66122d7d21e9968495ca55b482323a2749b90491b335afa3a304299de286'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.0.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'f3669d7d1516452ea471fa4e8e85b758eae5feed938449f7ecfadfafa564db84'
      end
    end

    resource 'dartium' do
      version '1.18.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.0.0/dartium/dartium-linux-x64-release.zip'
        sha256 'c82fd9cffdf7aac6444a9a1e823aba7f046314cf84795d66e8937177f2c25935'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.18.0-dev.0.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'e1f4c6bc9c5e297f2cb77d2ba72b80980247e9522f64657612094a8e1c4987e2'
      end
    end
  end

  resource 'content_shell' do
    version '1.17.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.0/dartium/content_shell-linux-x64-release.zip'
      sha256 '389861a7770cbccd7ae2ccc5e8368d0958c156144d93971172be1232ffa70fdc'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 'f952a2ed390ee860aba2162cde75b3428dd55fcf6bb95b7956da2a838701d03a'
    end
  end

  resource 'dartium' do
    version '1.17.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.0/dartium/dartium-linux-x64-release.zip'
      sha256 '01de5dd25d1996e651d72ae969649e840112f4fea545d4241f9a9e41e85412e2'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.17.0/dartium/dartium-linux-ia32-release.zip'
      sha256 '35f4ff3eca708267b7a0a1314ce6ffd8633b2d3fce6de15d8eb1cd15fc2483c1'
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
