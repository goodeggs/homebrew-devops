class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "9.11.2"
  url "http://ranch-updates.goodeggs.com/stable/ranch/#{version}/darwin-amd64.gz"
  sha256 "8a760b4b20e880eb8e14121a6ddae1781ca52e33e2619ce7d54ce8a32340dc03"

  def install
    bin.install "darwin-amd64" => "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
