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
    version "2.2.1-dev.3.1"
    if MacOS.prefer_64_bit?
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.2.1-dev.3.1/sdk/dartsdk-linux-x64-release.zip"
      sha256 "88476ee77b39aa2de30d564126d0077efba85168ac91445e5ed92fe981b2cc81"
    else
      url "https://storage.googleapis.com/dart-archive/channels/dev/release/2.2.1-dev.3.1/sdk/dartsdk-linux-ia32-release.zip"
      sha256 "eb76f74b729b2c9696402ce023f64c2a6bbb82a9de494f5f3cc97e20f5f19de9"
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
