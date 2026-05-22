const migration = require('../migration/wire_example_sentences');

if (require.main === module) {
  process.exitCode = migration.main();
}

module.exports = migration;
