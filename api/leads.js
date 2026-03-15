const { ensureSchema, sql } = require('./_lib/db');

module.exports = async (req, res) => {
  if (req.method !== 'GET') return res.status(405).json({ error: 'Method not allowed' });
  const adminToken = process.env.ADMIN_TOKEN;
  const provided = req.headers['x-admin-token'] || req.query.token;
  if (!adminToken || provided !== adminToken) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  try {
    await ensureSchema();
    const result = await sql`
      SELECT id, created_at, name, business, email, website, contact_channel, primary_channel, problem, win, discord_notified
      FROM leads
      ORDER BY created_at DESC
      LIMIT 200;
    `;
    return res.status(200).json({ leads: result.rows });
  } catch (error) {
    console.error('leads error', error);
    return res.status(500).json({ error: 'Failed to fetch leads.' });
  }
};
