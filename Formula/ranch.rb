class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "8.1.0"
  url "https://github.com/goodeggs/platform/releases/download/v#{version}/ranch-Darwin-x86_64"
  sha256 "af1e0eb36ef5f0c460ba645e32b72d5a7ebf24e08e6a2e9c3a25767d518f3f93"

  def install
    bin.install "ranch-Darwin-x86_64" => "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
