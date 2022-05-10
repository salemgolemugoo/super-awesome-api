const core = require('@actions/core');
const fs = require('fs');
const yaml = require('yaml');

try {
  const file = fs.readFileSync('metadata.yml', 'utf8');
  const metadata = yaml.parse(file);

  core.setOutput('platform', metadata.platform);
  core.setOutput('system', metadata.system);
  core.setOutput('subsystem', metadata.subsystem);
  core.setOutput('owner', metadata.owner);

} catch (error) {
  core.setFailed(error.message);
}
