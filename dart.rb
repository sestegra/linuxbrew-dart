class Dart < Formula
  desc "The Dart SDK"
  homepage "https://www.dartlang.org/"

  version "2.2.0"
  if MacOS.prefer_64_bit?
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.2.0/sdk/dartsdk-linux-x64-release.zip"
    sha256 "89777ceba8227d4dad6081c44bc70d301a259f3c2fdb4c1391961e376ec3af68"
  else
    url "https://storage.googleapis.com/dart-archive/channels/stable/release/2.2.0/sdk/dartsdk-linux-ia32-release.zip"
    sha256 "d6d5edab837301bde218c97b074af8390d5dbe00a99961605159fa9e53609b81"
  end

  devel do
    version "2.2.1-dev.2.0"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.2.1-dev.2.0/sdk/dartsdk-linux-x64-release.zip"
      sha256 "db94ebac87a877bf460927d7a67f83336fbe2fd6a75a4ac570e823b7c871ab53"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.2.1-dev.2.0/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "f73e68a15b8512e48d6c3d1a65bf798dbe6d32a2fecf70141e1031afb13f45f6"
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
