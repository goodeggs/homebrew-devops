class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/ranch-cli"
  version "10.0.3"
  url "http://ranch-updates.goodeggs.com/stable/ranch/#{version}/darwin-amd64.gz"
  sha256 "df82c0c1de0499cb5d9e50dcc7688fc6df4fe15ef7c4231d969942e2a48850b3"

  depends_on "autossh"
  depends_on "dnsmasq"

  def install
    bin.install "darwin-amd64" => "ranch_real"
    File.open('ranch', 'w') do |file|
      file.write <<-EOS
#!/bin/bash

set -eo pipefail

# Make sure and clean up
trap "exit" INT TERM ERR
trap "kill 0" EXIT

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
sshcmd='ssh -o ExitOnForwardFailure=yes -l admin -N'
export RANCH_SOCKS_PROXY='socks5://127.0.0.1:8015'

case "$RANCH_ENDPOINT" in
  *huevosbuenos.com*)
    export RANCH_ENDPOINT="https://ranch-api-staging.internal.huevosbuenos.com"
    $sshcmd -D 8015 jump.us-east-1.dev-aws.goodeggs.com "sleep 3600" &
    ;;
  *)
    export RANCH_ENDPOINT="https://ranch-api.internal.goodeggs.com"
    $sshcmd -D 8015 jump.us-east-1.prod-aws.goodeggs.com "sleep 3600" &
    ;;
  esac
sleep 1
$script_dir/ranch_real "$@"
    EOS
  end
    bin.install "ranch"
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
