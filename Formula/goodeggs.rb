require_relative "../lib/custom_download_strategy.rb"

class Goodeggs < Formula
  desc "Good Eggs CLI"
  homepage "https://github.com/goodeggs/goodeggs-cli"
  version "2.0.1"
  url "https://github.com/goodeggs/goodeggs-cli/releases/download/v#{version}/goodeggs-Darwin-x86_64", :using => CustomGitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "d1e308adcea947b494522dd7c2985c76e7c9c3feba387146aeeb3e950fc97a51"

  def install
    bin.install "goodeggs-Darwin-x86_64" => "goodeggs"
  end

  test do
    output = shell_output(bin/"goodeggs --version")
    assert_match version.to_s, output
  end
end
