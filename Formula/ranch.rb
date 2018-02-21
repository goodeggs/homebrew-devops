class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "9.4.0"
  url "https://github.com/goodeggs/platform/releases/download/v#{version}/ranch-Darwin-x86_64"
  sha256 "82fd83c518679ba9b8f617a8380066428624e525d7d69a367590d0e4b23e5cab"

  def install
    bin.install "ranch-Darwin-x86_64" => "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
