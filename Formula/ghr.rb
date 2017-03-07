class Ghr < Formula
  desc "Upload multiple artifacts to GitHub Release in parallel"
  homepage "http://tcnksm.github.io/ghr/"
  version "0.5.4"
  url "https://github.com/tcnksm/ghr/releases/download/v#{version}_v#{version}_darwin_amd64.zip"
  sha256 "c473cd89813e1c94f30887d53a8cd0fced2a8ec6cd100444ba81ce45b32f09eb"

  def install
    bin.install "ghr"
  end

  test do
    output = shell_output(bin/"ghr --help")
    assert_match "Usage", output
  end
end
