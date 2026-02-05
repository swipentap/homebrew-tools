# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  version "0.0.9"

  on_arm do
    url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-arm64.tar.gz"
    sha256 "e0074b5d52ea66c45608d68b29236d529ab7eb1574492310cb9d628bb410a233"
  end
  on_intel do
    url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-amd64.tar.gz"
    sha256 "412f617294bcca70cdac27364df6252dd1b81794fb29a39ea1ed36c9c292accc"
  end

  head "https://github.com/swipentap/enva.git", branch: "main"

  depends_on "dotnet" => :build if build.head?

  def install
    if build.head?
      rid = Hardware::CPU.arm? ? "osx-arm64" : "osx-x64"
      system "dotnet", "publish", "src/Enva.csproj",
             "-c", "Release", "-r", rid, "--self-contained", "true", "-o", "publish"
      libexec.install Dir["publish/*"]
      (bin/"enva").write <<~EOS
        #!/bin/sh
        exec "#{libexec}/Enva" "$@"
      EOS
      chmod 0755, bin/"enva"
    else
      bin.install "enva"
    end
  end

  test do
    assert_match "enva", shell_output("#{bin}/enva --help", 0)
  end
end
