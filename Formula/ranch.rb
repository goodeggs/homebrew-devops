class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/ranch-cli"
  version "10.0.1"
  url "http://ranch-updates.goodeggs.com/stable/ranch/#{version}/darwin-amd64.gz"
  sha256 "e323c7b9ed4d732481723a3f3cb6d69c70dc595de3a91db6a9b9f74590a6c030"

  depends_on "autossh"
  depends_on "dnsmasq"

  def install
    bin.install "darwin-amd64" => "ranch"
    File.open('ranch-api-resolver-helper', 'w') do |file|
      file.write <<-EOS
#!/bin/bash

set -euo pipefail

configure_dnsmasq() {
  mkdir -p /usr/local/etc
  mkdir -p /usr/local/etc/dnsmasq.d/
  cat << EOF > /usr/local/etc/dnsmasq.conf
conf-dir=/usr/local/etc/dnsmasq.d/,*.conf
EOF
  cat << EOF > /usr/local/etc/dnsmasq.d/goodeggs-internal.conf
address=/ranch-api.internal.goodeggs.com/127.0.0.1
EOF
}

configure_dns_resolver() {
  mkdir -p /private/etc/resolver
  sudo tee /etc/resolver/internal.goodeggs.com > /dev/null << EOF
nameserver 127.0.0.1
EOF
}

configure_dnsmasq
configure_dns_resolver
sudo killall -HUP mDNSResponder
echo 'dnsmasq configured!'
    EOS
  end
    bin.install "ranch-api-resolver-helper"
  end

  plist_options :startup => true
  def plist
    <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>ranch.proxy</string>
    <key>KeepAlive</key>
        <true/>
    <key>RunAtLoad</key>
        <true/>
    <key>EnvironmentVariables</key>
    <dict>
        <key>SSH_AUTH_SOCK</key>
        <string>#{ENV["SSH_AUTH_SOCK"]}</string>
    </dict>
    <key>ProgramArguments</key>
        <array>
            <string>/usr/local/bin/autossh</string>
    <!-- autossh switches -->
            <string>-M</string>
            <string>0</string>
    <!-- ssh switches -->
            <string>-N</string>
            <string>-T</string>
    <string>-o</string>
            <string>ControlMaster=no</string>
    <string>-o</string>
            <string>ServerAliveInterval=60</string>
    <string>-o</string>
            <string>ServerAliveCountMax=3</string>
    <string>-p</string>
            <string>22</string>
    <string>-l</string>
            <string>admin</string>
    <string>-L</string>
            <string>8005:ranch-api.internal.goodeggs.com:443</string>
    <string>jump.us-east-1.prod-aws.goodeggs.com</string>
        </array>
    </dict>
    </plist>
    EOS
  end

  def caveats
    <<~EOS
    - run "ranch-api-resolver-helper" to complete setup.
    - Make sure "sslayer" is updated
    - You may need to "sudo brew services restart dnsmasq" to refresh config
    - Modify your ranch env vars to "export RANCH_ENDPOINT=https://ranch-api.internal.goodeggs.com:8005"
    EOS
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
