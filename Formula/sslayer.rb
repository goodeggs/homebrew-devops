class Sslayer < Formula
  desc 'SSL-terminating reverse proxy for the Good Eggs ecosystem'
  homepage 'https://github.com/goodeggs/homebrew-delivery-eng'
  url 'https://github.com/goodeggs/homebrew-delivery-eng.git'
  version '2.0.0'

  depends_on 'dnsmasq'
  depends_on 'docker'

  def install
    bin.install 'sslayer'
  end

  def caveats
    has_legacy_hosts = File.foreach("/etc/hosts").grep(/goodeggs\.test/).any?

    caveat = <<~EOS
To complete the install of sslayer, run:
  - sudo sslayer setup
  - sudo sslayer start

Then add the following to #{Utils::Shell.profile}:

  NODE_EXTRA_CA_CERTS="$HOME/Library/Application Support/mkcert/rootCA.pem"
    EOS

    if has_legacy_hosts
      caveat = caveat + <<~EOS

Finally, remove all goodeggs.test entries from your /etc/hosts file.
      EOS
    end

    caveat
  end
end
