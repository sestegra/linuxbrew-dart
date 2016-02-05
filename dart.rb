require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.14.1'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.1/sdk/dartsdk-linux-x64-release.zip'
    sha256 '495e979cff40eb3222f04f4810b6f6ed3dc58e867c10e30cad813e7567b34c92'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.1/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '1392bca3259acb7ebe08f22752c58909c2728d19e8776962556fbfd8cc779b2c'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.15.0-dev.1.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 '24f6f564693c51475c070b992c8d59ef8739aa101afde5561997132df5f82201'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '8f0a612d160133300c8c04e8208441f7960da4945bb61b86ea4373e31638b89f'
    end

    resource 'content_shell' do
      version '1.15.0-dev.1.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/dartium/content_shell-linux-x64-release.zip'
        sha256 'f7e4fbc6ac7607cb0b4d7ad0269648c9b80fc2c1dd6c1124d3d54e2551037933'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 '87e67259e974e7855d95634581e8a9e2e6fd99e7dc455cda9311c0b62c9122c7'
      end
    end

    resource 'dartium' do
      version '1.15.0-dev.1.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/dartium/dartium-linux-x64-release.zip'
        sha256 '18d785346a08b874fcc149d3780c48be21a6bbb1b34446db2306ff9f243f25ac'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.1.0/dartium/dartium-linux-ia32-release.zip'
        sha256 'cd71dd70b0c31722e5674c8e8d4081a37b78fe905e10d8994f3f385aeb01d6c9'
      end
    end
  end

  resource 'content_shell' do
    version '1.14.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.1/dartium/content_shell-linux-x64-release.zip'
      sha256 '64a929afffdacdc1faa26594fd5334cc022650b9d7cc45d53b9889487e8c37f9'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.1/dartium/content_shell-linux-ia32-release.zip'
      sha256 'f674fe853493cfc2ad73b198f76ece37a70594affa1e385e04c3ee41969274bb'
    end
  end

  resource 'dartium' do
    version '1.14.1'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.1/dartium/dartium-linux-x64-release.zip'
      sha256 '5c8b67b4660c80ac5eb936853e14e07eecda3279acc22ccae82d20569a98b830'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.1/dartium/dartium-linux-ia32-release.zip'
      sha256 '9b30f6e51105be2bba2e17f5383b2394a934adca61ee66267af35927f5707614'
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
