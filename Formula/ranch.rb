class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/ranch-cli"
  version "10.8.5"
  url "http://ranch-updates.goodeggs.com/stable/ranch/#{version}/darwin-amd64.gz"
  sha256 "a501df53e52d9d67cae8bd537f10e4e503a292930fccd1d5e4bc0233e877110a"

  depends_on "autossh"
  depends_on "netcat"

  def install
    bin.install "darwin-amd64" => "ranch_real"
    curl_download "http://ranch-updates.goodeggs.com/stable/ranch/#{version}/ranch-wrapper.sh", to: "ranch-wrapper.sh"
    bin.install "ranch-wrapper.sh" => "ranch"
  end

  def caveats
    <<~EOS
    - If you need access to the staging ranch-api there's some ENV vars you need set, talk to the platform team for assistance
    EOS
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
