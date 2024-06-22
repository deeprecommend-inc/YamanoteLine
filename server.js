// server.js
const http = require("http");
const fs = require("fs");
const path = require("path");

const server = http.createServer((req, res) => {
  if (req.url === "/" || req.url === "/index.html") {
    fs.readFile(path.join(__dirname, "index.html"), (err, content) => {
      if (err) {
        res.writeHead(500);
        res.end("Error loading index.html");
      } else {
        res.writeHead(200, { "Content-Type": "text/html" });
        res.end(content);
      }
    });
  } else if (req.url.startsWith("/api/placeholder")) {
    // プレースホルダー画像のリクエストを処理
    res.writeHead(200, { "Content-Type": "image/svg+xml" });
    res.end(
      '<svg xmlns="http://www.w3.org/2000/svg" width="720" height="480" viewBox="0 0 720 480"><rect width="100%" height="100%" fill="#ddd"/><text x="50%" y="50%" font-family="Arial" font-size="24" fill="#666" text-anchor="middle" dy=".3em">Placeholder Video</text></svg>'
    );
  } else {
    res.writeHead(404);
    res.end("Not Found");
  }
});

const PORT = 9999;
server.listen(PORT, () =>
  console.log(`Server running on http://localhost:${PORT}`)
);
