class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.5.0"
  if OS.mac?
    if Hardware::CPU.is_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.5.0/sdk/dartsdk-macos-x64-release.zip"
      sha256 "e031c10a38a69a4a461ea954b851860ac27d1ca890df1e194777119707d7aa56"
    else
      url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.5.0/sdk/dartsdk-macos-ia32-release.zip"
      sha256 "a595b26f43e35ba8cf405fca670ee96e9aafbf71cd772837cc14745198cf0c37"
    end
  elsif OS.linux?
    if Hardware::CPU.is_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.5.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "5bd5ff07c74bab4f26b24d161b3825e1b78f11ee15cb941c30ba4f31a2a05bef"
    else
      url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.5.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "45caf53e1c2cefd3dd19892f0420acd4e4da3a30713c4ef608a5110350ea4aaf"
    end
  end

  devel do
    version "2.6.0-dev.1.0"
    if OS.mac?
      if Hardware::CPU.is_64_bit?
        url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.6.0-dev.1.0/sdk/dartsdk-macos-x64-release.zip"
        sha256 "ce753c42587a3ad680f0385fa4efe636cab222506eaabe03e5ec82a6976f672e"
      else
        url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.6.0-dev.1.0/sdk/dartsdk-macos-ia32-release.zip"
        sha256 "d72aa802f6327c8583e92a61e3cb3d76ef8129bf2ba432a7840a46c071dc9373"
      end
    elsif OS.linux?
      if Hardware::CPU.is_64_bit?
        url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.6.0-dev.1.0/sdk/dartsdk-linux-x64-release.zip"
        sha256 "1488054f40d0b6034fe713806831f6d124dfe476c171123b23c28a6c4eaaf18f"
      else
        url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.6.0-dev.1.0/sdk/dartsdk-linux-ia32-release.zip"
        sha256 "c379bd752b799ec14c4c3d9434024e20b218888e980ba87973123111a39270ed"
      end
    end
  end

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/dart"
    bin.write_exec_script Dir["#{libexec}/bin/{pub,dart?*}"]
  end

  def shim_script(target)
    <<~EOS
      #!/usr/bin/env bash
      exec "#{prefix}/#{target}" "$@"
    EOS
  end

  def caveats; <<~EOS
    Please note the path to the Dart SDK:
      #{opt_libexec}
    EOS
  end

  test do
    (testpath/"sample.dart").write <<~EOS
      void main() {
        print(r"test message");
      }
    EOS

    assert_equal "test message\n", shell_output("#{bin}/dart sample.dart")
  end
end
