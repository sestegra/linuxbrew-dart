require 'formula'

class Dart < Formula
  homepage 'https://www.dartlang.org/'

  version '1.14.0'
  if MacOS.prefer_64_bit?
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.0/sdk/dartsdk-linux-x64-release.zip'
    sha256 'fad51d0782cdbf553a24436934c9efc453b31b2347930d116b74ef4d4efd0927'
  else
    url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.0/sdk/dartsdk-linux-ia32-release.zip'
    sha256 '4202776559dfe909ef780c17ada5670a764882dd2bfced868325efac0ec1af32'
  end

  option 'with-content-shell', 'Download and install content_shell -- headless Dartium for testing'
  option 'with-dartium', 'Download and install Dartium -- Chromium with Dart'

  devel do
    version '1.15.0-dev.0.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.0.0/sdk/dartsdk-linux-x64-release.zip'
      sha256 'be399ccdcf55da6622e7327ebb0c115e9ca59fe6f95de3d799f9fa6c18836c07'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.0.0/sdk/dartsdk-linux-ia32-release.zip'
      sha256 '02162bcc4dc52857d23afc7ed7ded8af371c84d9676061cb864f32d11118295d'
    end

    resource 'content_shell' do
      version '1.15.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.0.0/dartium/content_shell-linux-x64-release.zip'
        sha256 '71908e9b33df5ef8f2e524f39782e88dac15df52692c9435fbdc2967f11c4836'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.0.0/dartium/content_shell-linux-ia32-release.zip'
        sha256 'f303c7032b72c18a94014c5fb5c038e62bcaf8f49b3d4c6cd5aabe4c28f0b2f0'
      end
    end

    resource 'dartium' do
      version '1.15.0-dev.0.0'
      if MacOS.prefer_64_bit?
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.0.0/dartium/dartium-linux-x64-release.zip'
        sha256 'd0f80f385c462dc4dcbcf5c509d367d5f18c08e0da5eacec9f94e90cde579819'
      else
        url 'https://storage.googleapis.com/dart-archive/channels/dev/release/1.15.0-dev.0.0/dartium/dartium-linux-ia32-release.zip'
        sha256 '0ce1458b2c2dc2bedcfbfeb3b2c2ec5bd54236339470130319b4bdd32dc7e8cf'
      end
    end
  end

  resource 'content_shell' do
    version '1.14.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.0/dartium/content_shell-linux-x64-release.zip'
      sha256 'b5ac2d67b58ee1c9573e6f99f7cea9c67d26150e4bf9a72539ac27438b8c6353'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.0/dartium/content_shell-linux-ia32-release.zip'
      sha256 'efab8e155731831bd2c5e51064d6f60f1106a6762fc6e4b75d09a998e2e4ee18'
    end
  end

  resource 'dartium' do
    version '1.14.0'
    if MacOS.prefer_64_bit?
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.0/dartium/dartium-linux-x64-release.zip'
      sha256 'd0749023667bf59d8c30a5a519cf1c7ebab2813dc850709842db2924ea395c40'
    else
      url 'https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.0/dartium/dartium-linux-ia32-release.zip'
      sha256 'c76e55bf19e5b1802f5b6f477ee90e253d32c3a7aa08f9915a0aebfbc128822a'
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
