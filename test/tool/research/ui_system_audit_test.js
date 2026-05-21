const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const {
  auditUiSystem,
  renderMarkdown,
} = require('../../../tool/research/audit_ui_system');

function writeFile(root, file, text) {
  const full = path.join(root, file);
  fs.mkdirSync(path.dirname(full), { recursive: true });
  fs.writeFileSync(full, text, 'utf8');
}

test('audits widget inventory, usage counts, duplicates, and screen style drift', () => {
  const root = fs.mkdtempSync(path.join(os.tmpdir(), 'jpstudy-ui-audit-'));
  writeFile(
    root,
    'lib/features/home/widgets/sample_card.dart',
    `
import 'package:flutter/material.dart';
class SampleCard extends StatelessWidget {
  const SampleCard({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    color: const Color(0xFF00AA00),
  );
}
class OtherCard extends StatelessWidget {
  const OtherCard({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(height: 12);
}
`,
  );
  writeFile(
    root,
    'lib/features/home/screens/home_screen.dart',
    `
import 'package:flutter/material.dart';
import '../widgets/sample_card.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SampleCard(),
      Text('x', style: TextStyle(fontSize: 17, color: Colors.red)),
    ],
  );
}
`,
  );

  const report = auditUiSystem({ repoRoot: root, generatedAt: '2026-05-22' });

  assert.equal(report.summary.componentCount, 2);
  assert.equal(report.components.find((c) => c.name === 'SampleCard').usageCount, 1);
  assert.ok(report.duplicateFamilies.some((family) => family.family === 'Card'));
  assert.ok(
    report.styleViolations.some(
      (file) =>
        file.file === 'lib/features/home/screens/home_screen.dart' &&
        file.counts.hardcodedTextStyle > 0 &&
        file.counts.hardcodedMaterialColor > 0,
    ),
  );

  const markdown = renderMarkdown(report);
  assert.match(markdown, /SampleCard/);
  assert.match(markdown, /Recommended dedupe targets/);
  assert.match(markdown, /lib\/features\/home\/screens\/home_screen\.dart/);
});
