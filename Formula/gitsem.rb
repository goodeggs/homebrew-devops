class Gitsem < Formula
  desc "a command line utility for managing semantically versioned (semver) git tags"
  homepage "https://github.com/Clever/gitsem"
  version "1.0.4"
  url "https://github.com/Clever/gitsem/releases/download/#{version}/gitsem-v#{version}-darwin-amd64.tar.gz"
  sha256 "f0c3b9ff1b6f2c2849a1e341bfdfd5be30f865b45ca5e0ffe315eb46cb7c1f17"

  def install
    bin.install "gitsem"
  end

  test do
    output = shell_output(bin/"gitsem --help")
    assert_match "Usage", output
  end
end
