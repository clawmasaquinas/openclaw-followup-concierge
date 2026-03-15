const { ensureSchema, sql } = require('./_lib/db');

module.exports = async (_req, res) => {
  try {
    await ensureSchema();
    const result = await sql`SELECT COUNT(*)::int AS count FROM leads;`;
    return res.status(200).json({ ok: true, leadCount: result.rows[0].count });
  } catch (error) {
    console.error('health error', error);
    return res.status(500).json({ ok: false });
  }
};
