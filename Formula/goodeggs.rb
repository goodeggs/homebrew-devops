class Goodeggs < Formula
  desc "Good Eggs CLI"
  homepage "https://github.com/goodeggs/goodeggs-cli"
  version "1.0.2"
  url "https://github.com/goodeggs/goodeggs-cli/releases/download/v#{version}/goodeggs-Darwin-x86_64", :using => GitHubPrivateRepositoryReleaseDownloadStrategy
  sha256 "9aebe04603852d7b39403d72881210b04ac64844ef58159a2afddfb52754e156"

  def install
    bin.install "goodeggs-Darwin-x86_64" => "goodeggs"
  end

  test do
    output = shell_output(bin/"goodeggs --version")
    assert_match version.to_s, output
  end
end
