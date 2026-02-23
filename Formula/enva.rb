# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  version "0.0.15"

  on_macos do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-arm64.tar.gz"
      sha256 "ff84cbb90fb6ea3c5a916c7191a0cf1b56dfbf11a09db37042847f710c3338e6"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-amd64.tar.gz"
      sha256 "c1bd64fdc00d488024509b2bba5c94fba154a06efaa26767fa22f04aa66c605c"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-arm64.tar.gz"
      sha256 "744652efe941d543373530016ff27a29b70747237c950080d6ebfb2069efe618"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-amd64.tar.gz"
      sha256 "7584ad91977d8275b71ad5a8e68726355d8d261e96827896a7dbd56bf522c672"
    end
  end

  head "https://github.com/swipentap/enva.git", branch: "main"

  depends_on "dotnet" => :build if build.head?

  def install
    if build.head?
      rid = if OS.mac?
        Hardware::CPU.arm? ? "osx-arm64" : "osx-x64"
      else
        Hardware::CPU.arm? ? "linux-arm64" : "linux-x64"
      end
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
