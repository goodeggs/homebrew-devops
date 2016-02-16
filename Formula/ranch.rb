class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  url "https://github.com/goodeggs/platform/releases/download/v1.0.2/ranch-osx-1.0.2.tar.gz"
  sha256 "dd7af6a6102c9c56d6235b2dd238cf6695d5ec572d5e2fcbe18606443b465607"

  def install
    bin.install "ranch"
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
