import express from "express";
import helmet from "helmet";
import morgan from "morgan";
import "dotenv/config";

const app = express();

// ── Bảo mật & logging ─────────────────────────────────────────
app.use(helmet());
app.use(morgan(process.env.NODE_ENV === "production" ? "combined" : "dev"));

// ── Parse JSON body ───────────────────────────────────────────
app.use(express.json());

// ── Health check (không cần auth) ────────────────────────────
app.get("/health", (_req, res) => {
  res.json({
    status: "ok",
    env: process.env.NODE_ENV,
    ts: new Date().toISOString(),
  });
});

// ── Routes /api/v1 ───────────────────────────────────────────
// TODO: import và mount từng router khi làm đến giai đoạn tương ứng
// Ví dụ:
// import authRoutes from './modules/auth/auth.routes.js';
// app.use('/api/v1/auth', authRoutes);

// ── 404 handler ───────────────────────────────────────────────
app.use((_req, res) => {
  res.status(404).json({
    success: false,
    error: { code: "NOT_FOUND", message: "Endpoint không tồn tại" },
  });
});

// ── Global error handler ──────────────────────────────────────
// eslint-disable-next-line no-unused-vars
app.use((err, _req, res, _next) => {
  console.error("[ERROR]", err);

  // Lỗi validation từ Zod (middleware/validate.js sẽ throw loại này)
  if (err.name === "ZodError") {
    return res.status(400).json({
      success: false,
      error: { code: "VALIDATION_ERROR", fields: err.flatten().fieldErrors },
    });
  }

  // Lỗi không mong đợi
  const status = err.status ?? 500;
  res.status(status).json({
    success: false,
    error: {
      code: err.code ?? "INTERNAL_ERROR",
      message:
        process.env.NODE_ENV === "production"
          ? "Lỗi server, vui lòng thử lại"
          : err.message,
    },
  });
});

export default app;
