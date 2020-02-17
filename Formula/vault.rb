require 'formula'

class Vault < Formula
  homepage 'https://github.com/goodeggs/homebrew-devops/'
  url 'https://github.com/goodeggs/homebrew-devops.git'
  version '1.0.0'

  def install
    bin.install 'vault'
  end

  def test
    system "$(brew --prefix vault)/vault help"
  end
end
