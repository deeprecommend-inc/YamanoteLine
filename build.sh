# プロジェクトディレクトリの作成（存在しない場合）
mkdir -p yamanote-line-project
cd yamanote-line-project

# package.jsonの作成（存在しない場合）
if [ ! -f package.json ]; then
    npm init -y
fi

# 必要なファイルの作成
cat > index.html << EOL
<!DOCTYPE html>
<html lang="ja">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>山手線駅マップと動画表示</title>
    <style>
      body,
      html {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
        height: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: #f0f0f0;
      }
      #map-container {
        position: relative;
        width: 600px;
        height: 600px;
      }
      .station {
        position: absolute;
        transform: translate(-50%, -50%);
        cursor: pointer;
        display: flex;
        align-items: center;
        white-space: nowrap;
      }
      .station-name {
        font-size: 12px;
        order: 2;
        margin-left: 5px;
      }
      .station-dot {
        width: 10px;
        height: 10px;
        background-color: white; /* 点の色を白に変更 */
        border: 2px solid #7ac142; /* 緑の枠線を追加 */
        border-radius: 50%;
        order: 1;
      }
      #video-popup {
        display: none;
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.9);
        z-index: 1000;
      }
      #video-player {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 90%;
        height: 90%;
      }
      #close-button {
        position: absolute;
        top: 20px;
        right: 20px;
        color: white;
        font-size: 30px;
        cursor: pointer;
      }
      #line-name {
        position: absolute;
        top: 45%;
        left: 50%;
        transform: translate(-50%, -50%);
        font-size: 36px;
        font-weight: bold;
        color: #000;
      }
      #line-name-en {
        position: absolute;
        top: 55%;
        left: 50%;
        transform: translate(-50%, -50%);
        font-size: 18px;
        color: #666;
      }
      #circle-line {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 500px;
        height: 500px;
        border: 15px solid #7ac142;
        border-radius: 50%;
      }
    </style>
  </head>
  <body>
    <div id="map-container">
      <div id="circle-line"></div>
      <div id="line-name">山手線</div>
      <div id="line-name-en">Yamanote Line</div>
    </div>
    <div id="video-popup">
      <span id="close-button">&times;</span>
      <video id="video-player" controls>
        <source src="" type="video/mp4" />
        お使いのブラウザは動画タグをサポートしていません。
      </video>
    </div>

    <script>
      const stations = [
        "東京",
        "神田",
        "秋葉原",
        "御徒町",
        "上野",
        "鶯谷",
        "日暮里",
        "西日暮里",
        "田端",
        "駒込",
        "巣鴨",
        "大塚",
        "池袋",
        "目白",
        "高田馬場",
        "新大久保",
        "新宿",
        "代々木",
        "原宿",
        "渋谷",
        "恵比寿",
        "目黒",
        "五反田",
        "大崎",
        "品川",
        "田町",
        "浜松町",
        "新橋",
        "有楽町",
      ];

      const mapContainer = document.getElementById("map-container");
      const videoPopup = document.getElementById("video-popup");
      const videoPlayer = document.getElementById("video-player");
      const closeButton = document.getElementById("close-button");

      stations.forEach((station, index) => {
        const angle = (index / stations.length) * 2 * Math.PI - Math.PI / 2;
        const radius = 265;
        const x = 300 + radius * Math.cos(angle);
        const y = 300 + radius * Math.sin(angle);

        const stationElement = document.createElement("div");
        stationElement.classList.add("station");
        stationElement.style.left = `${x}px`;
        stationElement.style.top = `${y}px`;

        const nameElement = document.createElement("div");
        nameElement.classList.add("station-name");
        nameElement.textContent = station;

        const dotElement = document.createElement("div");
        dotElement.classList.add("station-dot");

        // 駅名の位置調整
        if (x < 300) {
          stationElement.style.flexDirection = "row-reverse";
          nameElement.style.marginRight = "5px";
          nameElement.style.marginLeft = "0";
        }

        stationElement.appendChild(nameElement);
        stationElement.appendChild(dotElement);
        stationElement.addEventListener("click", () => showVideo(station));

        mapContainer.appendChild(stationElement);
      });

      function showVideo(station) {
        // 実際の動画URLに置き換える必要があります
        const videoUrl = `/api/placeholder/1920/1080`;
        videoPlayer.src = videoUrl;
        videoPopup.style.display = "block";
        videoPlayer.play();
      }

      closeButton.addEventListener("click", () => {
        videoPopup.style.display = "none";
        videoPlayer.pause();
        videoPlayer.currentTime = 0;
      });
    </script>
  </body>
</html>
EOL

cat > server.js << EOL
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
EOL

# 依存関係のインストール（この場合は特に必要ありませんが、将来的な拡張性のため）
npm install

# サーバーの起動
echo "Starting the server..."
node server.js