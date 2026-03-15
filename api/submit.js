const { ensureSchema, sql } = require('./_lib/db');

async function sendDiscordLeadNotification(lead) {
  const token = process.env.DISCORD_BOT_TOKEN;
  const channelId = process.env.DISCORD_CHANNEL_ID;
  if (!token || !channelId) return false;

  const lines = [
    '📥 **New pilot request**',
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
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST,OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');
  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  try {
    await ensureSchema();
    const body = typeof req.body === 'string' ? JSON.parse(req.body || '{}') : (req.body || {});
    const lead = {
      name: (body.name || '').trim(),
      business: (body.business || '').trim(),
      email: (body.email || '').trim(),
      website: (body.website || '').trim(),
      contact_channel: (body.contact_channel || '').trim(),
      primary_channel: (body.primary_channel || '').trim(),
      problem: (body.problem || '').trim(),
      win: (body.win || '').trim(),
    };

    if (!lead.name || !lead.email || !lead.problem) {
      return res.status(400).json({ error: 'Name, email, and problem are required.' });
    }

    const inserted = await sql`
      INSERT INTO leads (name, business, email, website, contact_channel, primary_channel, problem, win)
      VALUES (${lead.name}, ${lead.business}, ${lead.email}, ${lead.website}, ${lead.contact_channel}, ${lead.primary_channel}, ${lead.problem}, ${lead.win})
      RETURNING id, created_at, name, business, email, website, contact_channel, primary_channel, problem, win, discord_notified;
    `;

    const savedLead = inserted.rows[0];
    const discordOk = await sendDiscordLeadNotification(savedLead);
    if (discordOk) {
      await sql`UPDATE leads SET discord_notified = TRUE WHERE id = ${savedLead.id};`;
      savedLead.discord_notified = true;
    }

    return res.status(200).json({ ok: true, lead: savedLead });
  } catch (error) {
    console.error('submit error', error);
    return res.status(500).json({ error: 'Failed to save pilot request.' });
  }
};
