# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  version "0.0.3"

  on_arm do
    url "https://github.com/swipentap/enva/releases/download/v\#{version}/enva-\#{version}-darwin-arm64.tar.gz"
    sha256 "03d7bf68485690a3e3b21880102c6b7b19802331c516509665c2c9384024fd85"
  end
  on_intel do
    url "https://github.com/swipentap/enva/releases/download/v\#{version}/enva-\#{version}-darwin-amd64.tar.gz"
    sha256 "640ca596cec009af82b40b39e2d2b84bffba48540140a05d13b6b176c89aa89b"
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
        exec "\#{libexec}/Enva" "$@"
      EOS
      chmod 0755, bin/"enva"
    else
      bin.install "enva"
    end
  end

  test do
    assert_match "enva", shell_output("\#{bin}/enva --help", 0)
  end
end
