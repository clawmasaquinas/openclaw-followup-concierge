const { sql } = require('@vercel/postgres');

async function ensureSchema() {
  await sql`
    CREATE TABLE IF NOT EXISTS leads (
      id SERIAL PRIMARY KEY,
      created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      name TEXT NOT NULL,
      business TEXT,
      email TEXT NOT NULL,
      website TEXT,
      contact_channel TEXT,
      primary_channel TEXT,
      problem TEXT NOT NULL,
      win TEXT,
      discord_notified BOOLEAN NOT NULL DEFAULT FALSE
    );
  `;
}

module.exports = { sql, ensureSchema };
