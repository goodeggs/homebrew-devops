class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/ranch-cli"
  version "10.1.1"
  url "http://ranch-updates.goodeggs.com/stable/ranch/#{version}/darwin-amd64.gz"
  sha256 "45d9d381bc37ff168c7e0f75cf144afd6389f655d79c77286b667dc1d9542350"

  depends_on "autossh"
  depends_on "netcat"

  def install
    bin.install "darwin-amd64" => "ranch_real"
    File.open('ranch', 'w') do |file|
      file.write <<-EOS
#!/bin/bash

set -euo pipefail

# Make sure and clean up
trap "exit" INT TERM ERR
trap "kill 0" EXIT

port="$(jot -r 1 2000 3000)"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
sshcmd='ssh -o UserKnownHostsFile=/dev/null -o ExitOnForwardFailure=yes -o StrictHostKeyChecking=no -l admin -N'
export RANCH_SOCKS_PROXY="socks5://127.0.0.1:${port}"

case "${RANCH_ENDPOINT:-}" in
  *huevosbuenos.com*)
    export RANCH_ENDPOINT="https://ranch-api-staging.internal.huevosbuenos.com"
    $sshcmd -D "${port}" jump.us-east-1.dev-aws.goodeggs.com "sleep 3600" &
    ;;
  *)
    export RANCH_ENDPOINT="https://ranch-api.internal.goodeggs.com"
    $sshcmd -D "${port}" jump.us-east-1.prod-aws.goodeggs.com "sleep 3600" &
    ;;
  esac
while ! nc -z localhost "${port}"; do
  sleep 0.1 # wait for 1/10 of the second before check again
done
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
