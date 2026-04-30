import pg from "pg";
import "dotenv/config";

const { Pool } = pg;

// ── Tạo connection pool ────────────────────────────────────────
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  // Supabase yêu cầu SSL trên production
  ssl:
    process.env.NODE_ENV === "production"
      ? { rejectUnauthorized: false }
      : false,
  max: 10, // Tối đa 10 connection đồng thời
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 5000,
});

// ── Log khi pool có lỗi nền ────────────────────────────────────
pool.on("error", (err) => {
  console.error("[DB] Unexpected pool error:", err.message);
});

// ── Hàm query tiện dụng ────────────────────────────────────────
/**
 * Chạy một câu SQL.
 * @param {string} text  - Câu SQL với placeholder $1, $2...
 * @param {Array}  params - Mảng giá trị tương ứng
 * @returns {Promise<pg.QueryResult>}
 */
export const query = (text, params) => pool.query(text, params);

/**
 * Lấy một client từ pool để dùng transaction.
 * Nhớ gọi client.release() sau khi xong.
 * @returns {Promise<pg.PoolClient>}
 */
export const getClient = () => pool.connect();

/**
 * Chạy nhiều query trong một transaction.
 * Tự động ROLLBACK nếu có lỗi.
 * @param {(client: pg.PoolClient) => Promise<T>} fn
 */
export const withTransaction = async (fn) => {
  const client = await getClient();
  try {
    await client.query("BEGIN");
    const result = await fn(client);
    await client.query("COMMIT");
    return result;
  } catch (err) {
    await client.query("ROLLBACK");
    throw err;
  } finally {
    client.release();
  }
};

// ── Kiểm tra kết nối khi khởi động ───────────────────────────
export const testConnection = async () => {
  const client = await pool.connect();
  const { rows } = await client.query("SELECT NOW() AS now");
  client.release();
  return rows[0].now;
};

export default pool;
