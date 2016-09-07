class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "5.4.0"
  url "https://github.com/goodeggs/platform/releases/download/v#{version}/ranch_#{version}_darwin_amd64.zip"
  sha256 "cae1648886a837152043c561f34a1a2d9caddfebe77f82ece70a695a5d9274bd"

  def install
    bin.install "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
