class Ranch < Formula
  desc "Ranch Platform CLI"
  homepage "https://github.com/goodeggs/platform/tree/master/cmd/ranch"
  url "https://github.com/goodeggs/platform/archive/v1.0.1.tar.gz"
  sha256 "1823305347114129f241d06f4a2b2abcde71e4079475c7abf6bb0d3a8c0edf4d"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    path = buildpath/"src/github.com/goodeggs/platform"
    path.install Dir["*"]

    cd path/"cmd/ranch" do
      system "go", "build"
      bin.install "ranch"
    end
  end

  test do
    output = shell_output(bin/"ranch version")
    assert_match version.to_s, output
  end
end
