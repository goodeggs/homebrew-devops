class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "7.3.1"
  url "https://github.com/goodeggs/platform/releases/download/v#{version}/ranch-Darwin-x86_64"
  sha256 "9508509a6b85c5e6541f0ab4b47430f7c3f94d2993f9876d80e2962ea4e93c0e"

  def install
    bin.install "ranch-Darwin-x86_64" => "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
