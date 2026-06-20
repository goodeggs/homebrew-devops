class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/ranch-cli"
  version "10.12.0"
  url "http://ranch-updates.goodeggs.com/stable/ranch/#{version}/darwin-amd64.gz"
  sha256 "7ce95f681f3f261d76b3ec33dd1c31f8c95d646b33e8dd48c116fad801d63b63"

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
