const fs = require('node:fs');
const path = require('node:path');

const REQUIRED_TIER1_ANGLES = ['form', 'meaning', 'usage', 'context', 'contrast'];
const REQUIRED_TIER1_BLOOM = ['L1', 'L2', 'L3', 'L4'];

function validateTier1Templates(templates, { itemId = '' } = {}) {
  const scoped = (templates || []).filter((template) => !itemId || template.item_id === itemId);
  const failures = [];
  const label = itemId || '(all tier1 templates)';

  if (scoped.length < 10) {
    failures.push(`${label}: templates below 10 (${scoped.length})`);
  }

  const angles = new Set(scoped.map((template) => template.angle));
  for (const angle of REQUIRED_TIER1_ANGLES) {
    if (!angles.has(angle)) failures.push(`${label}: missing angle ${angle}`);
  }

  const blooms = new Set(scoped.map((template) => template.bloom_level));
  for (const bloom of REQUIRED_TIER1_BLOOM) {
    if (!blooms.has(bloom)) failures.push(`${label}: missing bloom ${bloom}`);
  }

  const seenIds = new Set();
  for (const template of scoped) {
    const templateId = template.template_id || template.id || '';
    if (!templateId) failures.push(`${label}: template missing template_id`);
    if (seenIds.has(templateId)) failures.push(`${label}: duplicate template_id ${templateId}`);
    seenIds.add(templateId);
    for (const field of [
      'item_id',
      'tier',
      'angle',
      'bloom_level',
      'prompt_template',
      'answer_template',
      'distractor_strategy',
    ]) {
      if (!String(template[field] || '').trim()) {
        failures.push(`${templateId || label}: missing ${field}`);
      }
    }
    const consumers = template.consumerRoutes || template.consumer_routes || [];
    if (!Array.isArray(consumers) || consumers.length === 0) {
      failures.push(`${templateId || label}: missing consumerRoutes`);
    }
  }

  return {
    passed: failures.length === 0,
    failures,
    counts: {
      templates: scoped.length,
      angles: angles.size,
      bloomLevels: blooms.size,
    },
  };
}

function validateAuthoredBank(payload, { itemId = '' } = {}) {
  const questions = payload?.questions || [];
  const grouped = new Map();
  for (const question of questions) {
    if (question.tier !== 'tier1') continue;
    grouped.set(question.item_id, [...(grouped.get(question.item_id) || []), question]);
  }
  const failures = [];
  const itemReports = [];
  const ids = itemId ? [itemId] : [...grouped.keys()].sort();
  for (const id of ids) {
    const report = validateTier1Templates(grouped.get(id) || [], { itemId: id });
    itemReports.push({ item_id: id, ...report });
    failures.push(...report.failures);
  }
  return {
    passed: failures.length === 0,
    failures,
    counts: {
      tier1Items: ids.length,
      tier1Templates: [...grouped.values()].reduce((sum, items) => sum + items.length, 0),
    },
    itemReports,
  };
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'));
}

function parseArgs(argv) {
  const args = {
    bankPath: path.join(process.cwd(), 'assets', 'data', 'content', 'grammar_practice', 'authored_bank.json'),
  };
  for (let i = 2; i < argv.length; i += 1) {
    const key = argv[i];
    const next = argv[i + 1];
    if (key === '--bank') args.bankPath = next, i += 1;
    else if (key === '--item-id') args.itemId = next, i += 1;
    else if (key === '--json') args.json = true;
  }
  return args;
}

if (require.main === module) {
  const args = parseArgs(process.argv);
  const report = validateAuthoredBank(readJson(args.bankPath), { itemId: args.itemId || '' });
  if (args.json) {
    process.stdout.write(`${JSON.stringify(report, null, 2)}\n`);
  } else {
    process.stdout.write(
      `Phase G templates: ${report.counts.tier1Templates} templates across ${report.counts.tier1Items} tier1 items\n`,
    );
    for (const failure of report.failures.slice(0, 80)) {
      process.stdout.write(`- ${failure}\n`);
    }
    if (report.failures.length > 80) {
      process.stdout.write(`... ${report.failures.length - 80} more failures\n`);
    }
  }
  if (!report.passed) process.exitCode = 1;
}

module.exports = {
  REQUIRED_TIER1_ANGLES,
  REQUIRED_TIER1_BLOOM,
  validateTier1Templates,
  validateAuthoredBank,
};
