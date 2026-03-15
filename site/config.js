const fs = require('fs');
const path = require('path');

function loadDotEnv(filePath) {
  if (!fs.existsSync(filePath)) return;
  const lines = fs.readFileSync(filePath, 'utf8').split(/\r?\n/);
  for (const line of lines) {
    const s = line.trim();
    if (!s || s.startsWith('#') || !s.includes('=')) continue;
    const idx = s.indexOf('=');
    const key = s.slice(0, idx).trim();
    const value = s.slice(idx + 1).trim();
    if (!(key in process.env)) process.env[key] = value;
  }
}

const envPath = path.join(__dirname, '.env');
loadDotEnv(envPath);

module.exports = {
  port: Number(process.env.PORT || 8080),
  host: process.env.HOST || '127.0.0.1',
  businessName: process.env.BUSINESS_NAME || 'OpenClaw Follow-up Concierge',
  adminPath: process.env.ADMIN_PATH || '/admin.html',
};
