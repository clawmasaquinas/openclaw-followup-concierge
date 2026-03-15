const { ensureSchema, sql } = require('./_lib/db');

async function sendDiscordLeadNotification(lead) {
  const token = process.env.DISCORD_BOT_TOKEN;
  const channelId = process.env.DISCORD_CHANNEL_ID;
  if (!token || !channelId) return false;

  const lines = [
    '📥 **Lead notification retry**',
    `**Name:** ${lead.name}`,
    `**Business:** ${lead.business || '—'}`,
    `**Email:** ${lead.email}`,
    `**Website:** ${lead.website || '—'}`,
    `**Preferred contact:** ${lead.contact_channel || '—'}`,
    `**Primary channel:** ${lead.primary_channel || '—'}`,
    `**Problem:** ${lead.problem}`,
    `**14-day win:** ${lead.win || '—'}`,
  ];

  const response = await fetch(`https://discord.com/api/v10/channels/${channelId}/messages`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bot ${token}`,
    },
    body: JSON.stringify({ content: lines.join('\n') }),
  });

  return response.ok;
}

module.exports = async (req, res) => {
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });
  const adminToken = process.env.ADMIN_TOKEN;
  const provided = req.headers['x-admin-token'] || req.query.token;
  if (!adminToken || provided !== adminToken) {
    return res.status(401).json({ error: 'Unauthorized' });
  }

  try {
    await ensureSchema();
    const pending = await sql`
      SELECT id, created_at, name, business, email, website, contact_channel, primary_channel, problem, win
      FROM leads
      WHERE discord_notified = FALSE
      ORDER BY created_at ASC
      LIMIT 25;
    `;

    let sent = 0;
    for (const lead of pending.rows) {
      const ok = await sendDiscordLeadNotification(lead);
      if (ok) {
        await sql`UPDATE leads SET discord_notified = TRUE WHERE id = ${lead.id};`;
        sent += 1;
      }
    }

    return res.status(200).json({ ok: true, attempted: pending.rows.length, sent });
  } catch (error) {
    console.error('retry error', error);
    return res.status(500).json({ error: 'Retry failed.' });
  }
};
