require 'formula'

class Devops < Formula
  homepage 'https://github.com/goodeggs/homebrew-delivery-eng/'
  url 'https://github.com/goodeggs/homebrew-delivery-eng.git'
  version '1.0.1'

  depends_on 'vault'
  depends_on 'jq'

  def install
    bin.install 'devops'
  end

  def test
    system "devops | grep mongo 2>&1"
  end

end
