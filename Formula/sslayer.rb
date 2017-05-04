class Sslayer < Formula
  desc 'SSL terminating reverse proxy for the Good Eggs ecosystem'
  homepage 'https://github.com/goodeggs/homebrew-delivery-eng'
  url 'https://github.com/goodeggs/homebrew-delivery-eng.git'
  version '1.2.0'

  depends_on 'nginx'

  def install
    bin.install 'sslayer'
  end

  def caveats
    <<-EOS.undent
      To complete the install of sslayer, you must run:
        - sudo sslayer setup
        - sudo brew services start sslayer
    EOS
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{bin}/sslayer</string>
            <string>start</string>
            <string>#{Formula["nginx"].opt_bin}/nginx</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end

end
