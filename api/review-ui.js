module.exports = async (_req, res) => {
  res.setHeader('Content-Type', 'text/html; charset=utf-8');
  return res.status(200).send(`<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>OpenClaw Lead Review</title>
  <style>
    :root { --bg:#0b1020; --panel:#121933; --text:#eef2ff; --muted:#b5bfdc; --accent:#6ea8fe; --accent-2:#8b5cf6; --border:rgba(255,255,255,.12); }
    * { box-sizing:border-box; }
    body { margin:0; font-family:Inter,ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif; background:linear-gradient(180deg,#08101d 0%,#0d1430 100%); color:var(--text); }
    .page { max-width:1040px; margin:0 auto; padding:48px 20px 80px; }
    .hero { padding:48px 0 32px; }
    .eyebrow { color:var(--accent); font-weight:700; letter-spacing:.04em; text-transform:uppercase; margin-bottom:12px; }
    h1 { font-size:clamp(2.4rem,5vw,4.5rem); line-height:1.02; margin:0 0 18px; }
    .lede,p { color:var(--muted); font-size:1.05rem; line-height:1.65; }
    .grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(220px,1fr)); gap:18px; margin-top:22px; }
    .card { background:rgba(255,255,255,.04); border:1px solid var(--border); border-radius:18px; padding:22px; }
    .intake-form { display:grid; gap:14px; max-width:720px; }
    .intake-form label { display:grid; gap:8px; color:var(--text); font-weight:600; }
    .intake-form input { width:100%; padding:12px 14px; border-radius:12px; border:1px solid var(--border); background:rgba(255,255,255,.04); color:var(--text); font:inherit; }
    .button { display:inline-block; padding:12px 18px; border-radius:12px; text-decoration:none; font-weight:700; border:1px solid var(--border); background:linear-gradient(90deg,var(--accent),var(--accent-2)); color:white; }
  </style>
</head>
<body>
  <main class="page">
    <section class="hero">
      <div class="eyebrow">OpenClaw Admin</div>
      <h1>Lead review</h1>
      <p class="lede">Protected admin view for pilot requests.</p>
    </section>
    <section class="section alt">
      <form id="admin-form" class="intake-form">
        <label>Admin token<input type="password" id="admin-token" required></label>
        <button class="button primary" type="submit">Load leads</button>
      </form>
      <div id="lead-list" class="grid three"></div>
    </section>
  </main>
  <script>
    const form = document.getElementById('admin-form');
    const root = document.getElementById('lead-list');
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      root.innerHTML = '<article class="card"><p>Loading…</p></article>';
      const token = document.getElementById('admin-token').value;
      const res = await fetch('/api/leads', { headers: { 'x-admin-token': token } });
      const data = await res.json().catch(() => ({}));
      if (!res.ok) {
        root.innerHTML = '<article class="card"><p>' + (data.error || 'Failed to load leads.') + '</p></article>';
        return;
      }
      const leads = data.leads || [];
      if (!leads.length) {
        root.innerHTML = '<article class="card"><p>No leads yet.</p></article>';
        return;
      }
      root.innerHTML = '';
      for (const lead of leads) {
        const el = document.createElement('article');
        el.className = 'card';
        el.innerHTML =
          '<h2>' + (lead.name || '—') + '</h2>' +
          '<p><strong>Business:</strong> ' + (lead.business || '—') + '</p>' +
          '<p><strong>Email:</strong> ' + (lead.email || '—') + '</p>' +
          '<p><strong>Primary channel:</strong> ' + (lead.primary_channel || '—') + '</p>' +
          '<p><strong>Problem:</strong> ' + (lead.problem || '—') + '</p>' +
          '<p><strong>Win:</strong> ' + (lead.win || '—') + '</p>' +
          '<p><strong>Submitted:</strong> ' + (lead.created_at || '—') + '</p>' +
          '<p><strong>Discord notified:</strong> ' + (lead.discord_notified ? 'yes' : 'no') + '</p>';
        root.appendChild(el);
      }
    });
  </script>
</body>
</html>`);
};
