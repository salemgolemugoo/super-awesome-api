const core = require('@actions/core');
const fs = require('fs');
const yaml = require('yaml');

try {
  const filename = core.getInput('filename', { required: false });
  const file = fs.readFileSync(filename, 'utf8');
  const metadata = yaml.parse(file);

  console.log("Metadata: ");
  console.log(metadata);
  core.setOutput('platform', metadata.Platform);
  core.setOutput('system', metadata.System);
  core.setOutput('subsystem', metadata.Subsystem);
  core.setOutput('owner', metadata.Owner);
  core.setOutput('target', metadata.Target);

} catch (error) {
  core.setFailed(error.message);
}
