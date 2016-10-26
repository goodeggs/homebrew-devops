class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "6.5.1"
  url "https://github.com/goodeggs/platform/releases/download/v#{version}/ranch_#{version}_darwin_amd64.zip"
  sha256 "88dcfd387e7e85bf86a9fcb7570d9668e872b766a7ac5db46bd17d9036840ec8"

  def install
    bin.install "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
