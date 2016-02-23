class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "1.0.5"
  url "https://github.com/goodeggs/platform/releases/download/v#{version}/ranch_#{version}_darwin_amd64.zip"
  sha256 "c5dfe658f08a37291f9e4c758f2a5f51cdc70be835f724eef498bfb79e442f67"

  def install
    bin.install "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
