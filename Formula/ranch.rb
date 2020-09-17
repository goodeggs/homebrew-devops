class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/ranch-cli"
  version "10.2.0"
  url "http://ranch-updates.goodeggs.com/stable/ranch/#{version}/darwin-amd64.gz"
  sha256 "5e5aacad122af1121feaac9d58e769d43489acf4b6e6ee2eadc261cbd841758c"

  depends_on "autossh"
  depends_on "netcat"

  def install
    bin.install "darwin-amd64" => "ranch_real"
    shell "curl -sSO 'http://ranch-updates.goodeggs.com/stable/ranch/#{version}/ranch-wrapper.sh'"
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
