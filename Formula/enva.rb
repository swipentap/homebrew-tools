# typed: false
# frozen_string_literal: true

class Enva < Formula
  desc "CLI for enva lab deployment (K3s, LXC, HAProxy, ArgoCD)"
  homepage "https://github.com/swipentap/enva"
  version "0.0.16"

  on_macos do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-arm64.tar.gz"
      sha256 "371c88d3a5164ccbdf6f657d480014eb59325dd2ff0418bad2d178219276b492"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-darwin-amd64.tar.gz"
      sha256 "3e4abdc1691d0647251bab7ab86dfca3c32c13256aad39c7dc76c68191bff499"
    end
  end
  on_linux do
    on_arm do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-arm64.tar.gz"
      sha256 "61f13f48d8d2c8048340bd43bbf97b1c80cd72eb8692ae2c24f25b6992cb3fb8"
    end
    on_intel do
      url "https://github.com/swipentap/enva/releases/download/v#{version}/enva-#{version}-linux-amd64.tar.gz"
      sha256 "cf15cbacc422f5a8cacf563f62f4f3f21cfc2eb20d540df60ebe124d3d1781af"
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
