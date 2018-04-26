class Goodeggs < Formula
  desc "Good Eggs CLI"
  homepage "https://github.com/goodeggs/goodeggs-cli"
  version "2.0.0"
  url "https://github.com/goodeggs/goodeggs-cli/releases/download/v#{version}/goodeggs-Darwin-x86_64", :using => GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "9ac680ac8ddd08475c1df696fd74ec4c502f140d3a7c6c988f4a50958e586615"

  def install
    bin.install "goodeggs-Darwin-x86_64" => "goodeggs"
  end

  test do
    output = shell_output(bin/"goodeggs --version")
    assert_match version.to_s, output
  end
end
