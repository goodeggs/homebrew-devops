class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "9.5.0"
  url "https://github.com/goodeggs/platform/releases/download/v#{version}/ranch-Darwin-x86_64"
  sha256 "bde2256e63b7a386651ef3b335976b97868d16af5f15819b824052c90c927e23"

  def install
    bin.install "ranch-Darwin-x86_64" => "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
