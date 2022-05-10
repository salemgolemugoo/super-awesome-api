const core = require('@actions/core');
const fs = require('fs');
const yaml = require('yaml');

try {
  const filename = core.getInput('filename', { required: false });
  const file = fs.readFileSync(filename, 'utf8');
  const metadata = yaml.parse(file);

  console.log("Printing meta");
  console.log(metadata);
  core.setOutput('platform', metadata.platform);
  core.setOutput('system', metadata.system);
  core.setOutput('subsystem', metadata.subsystem);
  core.setOutput('owner', metadata.owner);

} catch (error) {
  core.setFailed(error.message);
}
