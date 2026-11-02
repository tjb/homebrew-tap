class Savestate < Formula
  desc "Mac CLI and MCP server that lets coding agents drive iOS app debug state"
  homepage "https://github.com/tjb/SaveState"
  url "https://github.com/tjb/SaveState/archive/refs/tags/0.1.0.tar.gz"
  sha256 "8919d1289d3cbadd65eced92f4220b9f6589a93d9776d9c69f8fad657e7a3f1e"
  license "MIT"

  depends_on xcode: ["26.0", :build]
  depends_on :macos

  on_macos do
    depends_on macos: :sequoia
  end

  def install
    cd "CLI" do
      system "swift", "build", "--disable-sandbox", "-c", "release", "--product", "savestate"
      bin.install ".build/release/savestate"
    end
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/savestate --version").strip

    initialize = '{"jsonrpc":"2.0","id":1,"method":"initialize","params":' \
                 '{"protocolVersion":"2025-03-26","capabilities":{},' \
                 '"clientInfo":{"name":"brew","version":"1"}}}'
    assert_match '"name":"savestate"', pipe_output("#{bin}/savestate mcp", "#{initialize}\n")
  end
end
