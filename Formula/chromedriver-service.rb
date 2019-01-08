class ChromedriverService < Formula
  desc "Adds a service for Chromedriver"
  homepage "https://sites.google.com/a/chromium.org/chromedriver/"
  url "https://raw.githubusercontent.com/goodeggs/homebrew-devops/master/.empty.tgz" # fake it
  sha256 "863b571777ca92b569c1b61491fc0fe5f3e5e6b0ce77655e2ab10e639c3764e2"
  version "1.0"

  depends_on :chromedriver

  bottle :unneeded

  def install
    prefix.install 'empty'
  end

  plist_options :manual => "chromedriver"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>homebrew.mxcl.chromedriver-service</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>/usr/local/bin/chromedriver</string>
      </array>
      <key>ServiceDescription</key>
      <string>Chrome Driver</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/chromedriver-error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/chromedriver-output.log</string>
    </dict>
    </plist>
    EOS
  end

end
