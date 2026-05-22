const { main } = require('../migration/wire_example_sentences');

if (require.main === module) {
  process.exitCode = main();
}
