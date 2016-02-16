class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  url "https://github.com/goodeggs/platform/releases/download/v1.0.3/ranch-osx-1.0.3.tar.gz"
  sha256 "d58d0a7fb855bc00e0e153fe4f4f85093c10eadafe1c5af94994b3205e981b8c"

  def install
    bin.install "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
