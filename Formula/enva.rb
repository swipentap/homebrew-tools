# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  version "0.0.1-main.25"

  on_arm do
    url "https://github.com/swipentap/enva/releases/download/v\#{version}/enva-\#{version}-darwin-arm64.tar.gz"
    sha256 "ff6449364097674c9108813a4a46f8f6cb43f449a3c69a2e969232b372ac04fd"
  end
  on_intel do
    url "https://github.com/swipentap/enva/releases/download/v\#{version}/enva-\#{version}-darwin-amd64.tar.gz"
    sha256 "0d95904a481849b7778142336bdfa5d25082c5fef6c29dbe7a2d0b105bb99f5a"
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
