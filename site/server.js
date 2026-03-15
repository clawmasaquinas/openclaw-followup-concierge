#!/usr/bin/env node
const http = require('http');
const fs = require('fs');
const path = require('path');
const { URL } = require('url');

const config = require('./config');

const ROOT = __dirname;
const DATA_DIR = path.join(ROOT, '..', 'data');
const LEADS_JSON = path.join(DATA_DIR, 'leads.json');
const LEADS_CSV = path.join(DATA_DIR, 'leads.csv');
const PORT = config.port;
const HOST = config.host;

fs.mkdirSync(DATA_DIR, { recursive: true });
if (!fs.existsSync(LEADS_JSON)) fs.writeFileSync(LEADS_JSON, '[]\n');
if (!fs.existsSync(LEADS_CSV)) fs.writeFileSync(LEADS_CSV, 'timestamp,name,business,email,website,contact_channel,primary_channel,problem,win\n');

function send(res, status, body, type='text/html; charset=utf-8') {
  res.writeHead(status, { 'Content-Type': type });
  res.end(body);
}

function escCsv(value='') {
  const s = String(value ?? '');
  return /[",\n]/.test(s) ? '"' + s.replace(/"/g, '""') + '"' : s;
}

function parseBody(req) {
  return new Promise((resolve, reject) => {
    let data = '';
    req.on('data', chunk => {
      data += chunk;
      if (data.length > 1_000_000) {
        reject(new Error('Body too large'));
        req.destroy();
      }
    });
    req.on('end', () => resolve(data));
    req.on('error', reject);
  });
}

function serveFile(reqPath, res) {
  let filePath = path.join(ROOT, reqPath === '/' ? 'index.html' : reqPath.replace(/^\/+/, ''));
  if (!filePath.startsWith(ROOT)) return send(res, 403, 'Forbidden', 'text/plain');
  fs.readFile(filePath, (err, data) => {
    if (err) return send(res, 404, 'Not found', 'text/plain');
    const ext = path.extname(filePath).toLowerCase();
    const types = {
      '.html': 'text/html; charset=utf-8',
      '.css': 'text/css; charset=utf-8',
      '.js': 'application/javascript; charset=utf-8',
      '.md': 'text/plain; charset=utf-8',
      '.json': 'application/json; charset=utf-8'
    };
    send(res, 200, data, types[ext] || 'application/octet-stream');
  });
}

function loadLeads() {
  return JSON.parse(fs.readFileSync(LEADS_JSON, 'utf8'));
}

function saveLead(lead) {
  const leads = loadLeads();
  leads.push(lead);
  fs.writeFileSync(LEADS_JSON, JSON.stringify(leads, null, 2) + '\n');
  const row = [
    lead.timestamp,
    lead.name,
    lead.business,
    lead.email,
    lead.website,
    lead.contact_channel,
    lead.primary_channel,
    lead.problem,
    lead.win,
  ].map(escCsv).join(',') + '\n';
  fs.appendFileSync(LEADS_CSV, row);
}

const server = http.createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);

  if (req.method === 'GET' && url.pathname === '/api/leads') {
    return send(res, 200, JSON.stringify(loadLeads(), null, 2), 'application/json; charset=utf-8');
  }

  if (req.method === 'GET' && url.pathname === '/api/leads.csv') {
    return send(res, 200, fs.readFileSync(LEADS_CSV), 'text/csv; charset=utf-8');
  }

  if (req.method === 'POST' && url.pathname === '/intake') {
    try {
      const raw = await parseBody(req);
      const params = new URLSearchParams(raw);
      const lead = {
        timestamp: new Date().toISOString(),
        name: params.get('name') || '',
        business: params.get('business') || '',
        email: params.get('email') || '',
        website: params.get('website') || '',
        contact_channel: params.get('contact_channel') || '',
        primary_channel: params.get('primary_channel') || '',
        problem: params.get('problem') || '',
        win: params.get('win') || '',
      };
      if (!lead.name || !lead.email || !lead.problem) {
        return send(res, 400, 'Missing required fields', 'text/plain; charset=utf-8');
      }
      saveLead(lead);
      return send(res, 200, `<!doctype html><html><head><meta charset="utf-8"><title>Thanks</title><link rel="stylesheet" href="/styles.css"></head><body><main class="page"><section class="section final"><div class="eyebrow">OpenClaw Follow-up Concierge</div><h1>Thanks — got it.</h1><p class="lede">Your details were captured locally. Next step is manual review and follow-up.</p><p><a class="button primary" href="/">Back to site</a></p></section></main></body></html>`);
    } catch (err) {
      return send(res, 500, 'Server error', 'text/plain; charset=utf-8');
    }
  }

  if (req.method === 'GET') return serveFile(url.pathname, res);
  send(res, 405, 'Method not allowed', 'text/plain; charset=utf-8');
});

server.listen(PORT, HOST, () => {
  console.log(`${config.businessName} running at http://${HOST}:${PORT}`);
});
