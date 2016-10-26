require 'formula'

class Nvmish < Formula
  homepage 'https://github.com/goodeggs/homebrew-delivery-eng/'
  url 'https://github.com/goodeggs/homebrew-delivery-eng.git'
  version '3.0.4'

  depends_on 'jq'

  def install
    prefix.install 'nvmish.sh'

    vendor = prefix/'vendor'
    vendor.install Dir['vendor/bash_zsh_support']
  end

  def test
    system "/usr/bin/env bash -c 'source $(brew --prefix nvmish)/nvmish.sh; type nvmish'"
    system "/usr/bin/env zsh -c 'source $(brew --prefix nvmish)/nvmish.sh; type nvmish'"
  end

  def caveats
    <<-EOS.undent
      nvmish depends on nvm, but it is up to you to install it:
          https://github.com/creationix/nvm/blob/master/README.markdown#install-script

      You need to add this line to your .zshrc / .bash_profile / etc:
          source $(brew --prefix nvmish)/nvmish.sh

    EOS
  end

end
