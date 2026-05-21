const fs = require('node:fs');
const path = require('node:path');

const repoRoot = path.resolve(__dirname, '..', '..');

const WIDGET_CLASS_RE =
  /class\s+([A-Za-z_][A-Za-z0-9_]*)\s+extends\s+(?:StatelessWidget|StatefulWidget|ConsumerWidget|ConsumerStatefulWidget|HookWidget)/g;

const FAMILY_SUFFIXES = [
  'Card',
  'Button',
  'Chip',
  'Badge',
  'Panel',
  'Hero',
  'Surface',
  'Section',
  'Header',
  'Tile',
  'Dialog',
  'EmptyState',
  'ErrorState',
  'Loading',
  'Grid',
  'List',
];

const DEDUPE_TARGETS = {
  Card: 'AppCard / AppSectionCard',
  Button: 'AppButton',
  Chip: 'AppChip',
  Badge: 'AppBadge',
  Panel: 'AppSection + AppCard',
  Hero: 'AppSection hero variant',
  Surface: 'AppCard surface variant',
  Section: 'AppSection',
  Header: 'AppSection header slot',
  Tile: 'AppListTile',
  Dialog: 'AppDialog shell',
  EmptyState: 'AppEmptyState',
  ErrorState: 'AppEmptyState(error)',
  Loading: 'AppEmptyState(loading)',
  Grid: 'AppResponsiveGrid',
  List: 'AppListSection',
};

const STYLE_RULES = [
  {
    key: 'hardcodedEdgeInsets',
    label: 'EdgeInsets numeric without AppSpacing',
    re: /EdgeInsets\.(?:all|only|symmetric|fromLTRB)\([^;\n]*\d/,
    ignore: (line) => line.includes('AppSpacing'),
  },
  {
    key: 'hardcodedSizedBox',
    label: 'SizedBox numeric without AppSpacing',
    re: /SizedBox\([^;\n]*(?:height|width):\s*\d/,
    ignore: (line) => line.includes('AppSpacing'),
  },
  {
    key: 'hardcodedColor',
    label: 'Color(0x...) literal',
    re: /Color\(0x[0-9A-Fa-f]{6,8}\)/,
  },
  {
    key: 'hardcodedMaterialColor',
    label: 'Colors.* direct material color',
    re: /Colors\.[A-Za-z]/,
    ignore: (line) => line.includes('Colors.transparent'),
  },
  {
    key: 'hardcodedTextStyle',
    label: 'TextStyle fontSize numeric',
    re: /fontSize:\s*\d/,
  },
  {
    key: 'hardcodedRadius',
    label: 'BorderRadius numeric without radius token',
    re: /(?:BorderRadius|Radius)\.circular\(\s*\d/,
    ignore: (line) => /RadiusTokens|AppRadius|radiusTokens/.test(line),
  },
  {
    key: 'customShadow',
    label: 'BoxShadow outside elevation token',
    re: /BoxShadow\(/,
    ignore: (line) => /ElevationTokens|AppElevation|elevationTokens/.test(line),
  },
];

function auditUiSystem({
  repoRoot: root = repoRoot,
  generatedAt = new Date().toISOString(),
} = {}) {
  const dartFiles = listFiles(path.join(root, 'lib'), (file) =>
    file.endsWith('.dart') && !file.endsWith('.g.dart'),
  );
  const relFiles = dartFiles.map((file) => rel(root, file));
  const componentFiles = dartFiles.filter((file) => isComponentFile(rel(root, file)));
  const screenFiles = dartFiles.filter((file) => isScreenFile(rel(root, file)));
  const allLibText = new Map(
    dartFiles.map((file) => [rel(root, file), fs.readFileSync(file, 'utf8')]),
  );

  const components = [];
  for (const file of componentFiles) {
    const relative = rel(root, file);
    const text = fs.readFileSync(file, 'utf8');
    for (const name of widgetClasses(text)) {
      const usageCount = usageCountFor(name, allLibText) - declarationCountFor(name, text);
      components.push({
        name,
        location: relative,
        usageCount: Math.max(0, usageCount),
        family: componentFamily(name),
      });
    }
  }

  const duplicateFamilies = duplicateFamilyReport(components);
  const styleViolations = styleViolationReport({
    root,
    componentFiles,
    screenFiles,
  });

  return {
    generatedAt,
    scope: {
      componentRoots: ['lib/widgets', 'lib/features/*/widgets'],
      screenRoots: ['lib/features/*/screens', 'lib/features/**/*_screen.dart'],
      dartFileCount: relFiles.length,
    },
    summary: {
      componentCount: components.length,
      componentFileCount: componentFiles.length,
      screenFileCount: screenFiles.length,
      duplicateFamilyCount: duplicateFamilies.length,
      styleViolationFileCount: styleViolations.length,
      styleViolationCount: styleViolations.reduce((sum, file) => sum + file.total, 0),
    },
    components: components.sort((a, b) =>
      a.location === b.location
        ? a.name.localeCompare(b.name)
        : a.location.localeCompare(b.location),
    ),
    duplicateFamilies,
    styleViolations,
    recommendedDedupeTargets: duplicateFamilies.map((family) => ({
      family: family.family,
      target: DEDUPE_TARGETS[family.family] || 'Foundation primitive',
      candidates: family.components.map((component) => component.name),
    })),
  };
}

function renderMarkdown(report) {
  const lines = [
    '# UI Audit - 2026-05-22',
    '',
    `Generated: ${report.generatedAt}`,
    '',
    '## Scope',
    '',
    '- Component roots: `lib/widgets/`, `lib/features/*/widgets/`',
    '- Inline-style audit roots: `lib/features/*/screens/`, `lib/features/**/*_screen.dart`',
    `- Dart files scanned: ${report.scope.dartFileCount}`,
    '',
    '## Summary',
    '',
    '| Metric | Count |',
    '|---|---:|',
    `| Custom widget classes | ${report.summary.componentCount} |`,
    `| Component files | ${report.summary.componentFileCount} |`,
    `| Screen files audited | ${report.summary.screenFileCount} |`,
    `| Duplicate visual families | ${report.summary.duplicateFamilyCount} |`,
    `| Files with style violations | ${report.summary.styleViolationFileCount} |`,
    `| Total style violation hits | ${report.summary.styleViolationCount} |`,
    '',
    '## Component Inventory',
    '',
    '| Component | Location | Usage count | Family |',
    '|---|---|---:|---|',
  ];

  for (const component of report.components) {
    lines.push(
      `| \`${component.name}\` | \`${component.location}\` | ${component.usageCount} | ${component.family || '-'} |`,
    );
  }

  lines.push(
    '',
    '## Duplicate Families',
    '',
    '| Family | Components | Recommended dedupe target |',
    '|---|---|---|',
  );
  for (const family of report.duplicateFamilies) {
    lines.push(
      `| ${family.family} | ${family.components
        .map((component) => `\`${component.name}\``)
        .join(', ')} | ${DEDUPE_TARGETS[family.family] || 'Foundation primitive'} |`,
    );
  }

  lines.push(
    '',
    '## Recommended dedupe targets',
    '',
    '| Target | Replace / absorb |',
    '|---|---|',
  );
  for (const target of report.recommendedDedupeTargets) {
    lines.push(`| ${target.target} | ${target.candidates.map((item) => `\`${item}\``).join(', ')} |`);
  }

  lines.push(
    '',
    '## Style Violations',
    '',
    'Counts below are grouped per file. Samples are first hits only; fix order should follow files with highest totals and shared component surfaces first.',
    '',
    '| File | Scope | Total | Violation counts | Samples |',
    '|---|---|---:|---|---|',
  );
  for (const file of report.styleViolations) {
    const counts = Object.entries(file.counts)
      .filter(([, count]) => count > 0)
      .map(([key, count]) => `${key}=${count}`)
      .join('<br>');
    const samples = file.samples
      .map((sample) => `L${sample.line}: ${escapeTable(sample.rule)} - \`${escapeTable(sample.text)}\``)
      .join('<br>');
    lines.push(`| \`${file.file}\` | ${file.scope} | ${file.total} | ${counts} | ${samples} |`);
  }

  lines.push(
    '',
    '## H.2/H.3 Refactor Notes',
    '',
    '- Move numeric spacing/radius/elevation/color/type values into `lib/theme/tokens/`.',
    '- Start component-library extraction from the highest-duplication families: Card, Panel, Button, Chip, Header.',
    '- Keep existing `AppPageShell`, `AppSectionCard`, `AppFeatureCard`, `AppStatusChip`, and `AppFluidGrid` behavior as migration references, then wrap or replace them with `lib/widgets/foundation/` primitives.',
    '- Screens with inline `EdgeInsets`, `SizedBox`, `fontSize`, `Colors.*`, or `BorderRadius.circular(...)` should be refactored after tokens exist to avoid churn.',
    '',
  );

  return `${lines.join('\n')}\n`;
}

function writeAuditDoc({
  repoRoot: root = repoRoot,
  outputPath = path.join(root, 'docs', 'research', 'ui-audit-2026-05-22.md'),
  generatedAt,
} = {}) {
  const report = auditUiSystem({ repoRoot: root, generatedAt });
  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, renderMarkdown(report), 'utf8');
  return report;
}

function isComponentFile(relative) {
  const normalized = slash(relative);
  return (
    normalized.startsWith('lib/widgets/') ||
    /^lib\/features\/[^/]+\/widgets\/.+\.dart$/.test(normalized)
  );
}

function isScreenFile(relative) {
  const normalized = slash(relative);
  return (
    /^lib\/features\/[^/]+\/screens\/.+\.dart$/.test(normalized) ||
    /^lib\/features\/[^/]+\/[^/]*_?screen\.dart$/.test(normalized) ||
    /^lib\/features\/[^/]+\/[^/]*_screen_parts\.dart$/.test(normalized)
  );
}

function widgetClasses(text) {
  const names = [];
  let match;
  WIDGET_CLASS_RE.lastIndex = 0;
  while ((match = WIDGET_CLASS_RE.exec(text)) !== null) {
    names.push(match[1]);
  }
  return names;
}

function usageCountFor(name, textsByFile) {
  const re = new RegExp(`\\b${escapeRegExp(name)}\\b`, 'g');
  let count = 0;
  for (const text of textsByFile.values()) {
    count += [...text.matchAll(re)].length;
  }
  return count;
}

function declarationCountFor(name, text) {
  const classRe = new RegExp(`class\\s+${escapeRegExp(name)}\\b`, 'g');
  const constructorRe = new RegExp(
    `^\\s*(?:const\\s+)?${escapeRegExp(name)}\\s*\\(`,
    'gm',
  );
  return [...text.matchAll(classRe)].length + [...text.matchAll(constructorRe)].length;
}

function componentFamily(name) {
  const publicName = name.replace(/^_+/, '');
  return FAMILY_SUFFIXES.find((suffix) => publicName.endsWith(suffix)) || '';
}

function duplicateFamilyReport(components) {
  const families = new Map();
  for (const component of components) {
    if (!component.family) continue;
    if (!families.has(component.family)) families.set(component.family, []);
    families.get(component.family).push(component);
  }
  return [...families.entries()]
    .filter(([, items]) => items.length >= 2)
    .map(([family, items]) => ({
      family,
      components: items.sort((a, b) => b.usageCount - a.usageCount),
    }))
    .sort((a, b) => b.components.length - a.components.length);
}

function styleViolationReport({ root, componentFiles, screenFiles }) {
  const files = [...new Set([...componentFiles, ...screenFiles])].sort();
  const out = [];
  for (const file of files) {
    const relative = rel(root, file);
    const text = fs.readFileSync(file, 'utf8');
    const lines = text.split(/\r?\n/);
    const counts = Object.fromEntries(STYLE_RULES.map((rule) => [rule.key, 0]));
    const samples = [];
    for (const [index, line] of lines.entries()) {
      for (const rule of STYLE_RULES) {
        if (rule.re.test(line) && !(rule.ignore && rule.ignore(line))) {
          counts[rule.key] += 1;
          if (samples.length < 5) {
            samples.push({
              line: index + 1,
              rule: rule.label,
              text: line.trim().slice(0, 110),
            });
          }
        }
      }
    }
    const total = Object.values(counts).reduce((sum, count) => sum + count, 0);
    if (total === 0) continue;
    out.push({
      file: relative,
      scope: isComponentFile(relative) ? 'component' : 'screen',
      total,
      counts,
      samples,
    });
  }
  return out.sort((a, b) => b.total - a.total || a.file.localeCompare(b.file));
}

function listFiles(root, predicate) {
  if (!fs.existsSync(root)) return [];
  const files = [];
  for (const entry of fs.readdirSync(root, { withFileTypes: true })) {
    const full = path.join(root, entry.name);
    if (entry.isDirectory()) {
      files.push(...listFiles(full, predicate));
    } else if (entry.isFile() && predicate(full)) {
      files.push(full);
    }
  }
  return files;
}

function rel(root, file) {
  return slash(path.relative(root, file));
}

function slash(value) {
  return value.replace(/\\/g, '/');
}

function escapeRegExp(value) {
  return String(value).replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
}

function escapeTable(value) {
  return String(value).replace(/\|/g, '\\|').replace(/`/g, "'");
}

if (require.main === module) {
  const args = new Set(process.argv.slice(2));
  const generatedAt = args.has('--fixed-date') ? '2026-05-22' : new Date().toISOString();
  const report = writeAuditDoc({ generatedAt });
  console.log(
    JSON.stringify(
      {
        output: 'docs/research/ui-audit-2026-05-22.md',
        ...report.summary,
      },
      null,
      2,
    ),
  );
}

module.exports = {
  auditUiSystem,
  renderMarkdown,
  writeAuditDoc,
};
