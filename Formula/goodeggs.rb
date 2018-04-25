class Goodeggs < Formula
  desc "Good Eggs CLI"
  homepage "https://github.com/goodeggs/goodeggs-cli"
  version "1.0.3"
  url "https://github.com/goodeggs/goodeggs-cli/releases/download/v#{version}/goodeggs-Darwin-x86_64", :using => GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "6d9e37f8879c238e4018cab352569e66f03ac40009895d17e694a788feaf6fed"

  def install
    bin.install "goodeggs-Darwin-x86_64" => "goodeggs"
  end

  test do
    output = shell_output(bin/"goodeggs --version")
    assert_match version.to_s, output
  end
end
