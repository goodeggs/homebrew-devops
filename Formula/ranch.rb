class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  version "9.5.0"
  url "https://github.com/goodeggs/platform/releases/download/v#{version}/ranch-Darwin-x86_64"
  sha256 "9de25c47bf737c4364b79c223b6138032a8386631ae842ba58050c6cc1d32b13"

  def install
    bin.install "ranch-Darwin-x86_64" => "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
