class Savestate < Formula
  desc "Mac CLI and MCP server that lets coding agents drive iOS app debug state"
  homepage "https://github.com/tjb/SaveState"
  url "https://github.com/tjb/SaveState/archive/refs/tags/0.2.1.tar.gz"
  sha256 "9bd6d35f6c8120d99aa62be1435d7219bf656fb0a00536b68b7ca8ff8a78d441"
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
    # Stdin stays open until the reply arrives, as it does with a real MCP client.
    reply = IO.popen([bin/"savestate", "mcp"], "r+") do |server|
      server.puts initialize
      server.flush
      server.gets
    end
    assert_match '"name":"savestate"', reply
  end
end
