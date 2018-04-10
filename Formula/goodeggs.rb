class Goodeggs < Formula
  desc "Good Eggs CLI"
  homepage "https://github.com/goodeggs/goodeggs-cli"
  version "1.0.1"
  url "https://github.com/goodeggs/goodeggs-cli/releases/download/v#{version}/goodeggs-Darwin-x86_64", :using => GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "d0db4fd03c0eb0e013bb754a5099cef13db9b99f4c85f6b846af440ae8e0b180"

  def install
    bin.install "goodeggs-Darwin-x86_64" => "goodeggs"
  end

  test do
    output = shell_output(bin/"goodeggs --version")
    assert_match version.to_s, output
  end
end
