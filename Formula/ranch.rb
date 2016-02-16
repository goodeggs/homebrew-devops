class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "1.0.4"
  url "https://github.com/goodeggs/platform/releases/download/v#{version}/ranch_#{version}_darwin_amd64.zip"
  sha256 "3cd4de7d31d4a9fac92eb8ff80c65305582e8d6b37326b3463c4ec657eee2af6"

  def install
    bin.install "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
