require 'formula'

class Nvmish < Formula
  homepage 'https://github.com/goodeggs/homebrew-delivery-eng/'
  url 'https://github.com/goodeggs/homebrew-delivery-eng.git'
  version '1.0.0'

  depends_on 'jq'
  depends_on 'nvm'

  skip_clean 'bin'

  def install
    bin.install 'nvmish'
    (bin+'nvmish').chmod 0755

    ohai <<-'EOF'

      To run nvmish automatically when changing directories:

      add these lines to your .zshrc:

          function __nvmish() { nvmish chpwd }
          chpwd_functions=(${chpwd_functions[@]} "__nvmish")

      or these lines to your .bash_profile:

          # TBD
    
    EOF

  end

end
