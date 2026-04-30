import "dotenv/config";
import app from "./src/app.js";
import { testConnection } from "./src/config/db.js";
// Firebase tự init khi import – chỉ cần import 1 lần ở đây
import "./src/config/firebase.js";

const PORT = process.env.PORT || 3000;

const start = async () => {
  try {
    // 1. Kiểm tra kết nối PostgreSQL
    const dbTime = await testConnection();
    console.log(`[DB]  Connected – server time: ${dbTime}`);

    // 2. Khởi động HTTP server
    app.listen(PORT, () => {
      console.log(
        `[APP] TKB API running on port ${PORT} (${process.env.NODE_ENV})`,
      );
      console.log(`[APP] Health check: http://localhost:${PORT}/health`);
    });
  } catch (err) {
    console.error("[FATAL] Startup failed:", err.message);
    process.exit(1);
  }
};

start();
