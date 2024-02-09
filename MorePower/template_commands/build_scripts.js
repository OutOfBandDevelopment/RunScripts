const fs = require('fs');
const yaml = require('js-yaml');
const Handlebars = require('handlebars');
const os = require('os');

console.log(`Hostname: ${os.hostname()} OS: ${os.platform()}`);

const script_path = os.platform() === 'win32' ? process.cwd() + "\\..\\..\\" : "/usr/src/templates/";

function deepClone(obj) {
  return JSON.parse(JSON.stringify(obj));
}

function fixLineEndings(input, content) {
  //return content;
  //return content.split(/\r?\n/).map(f=>f + input.lineEnding).join('').trim();
  return content.split(/\r?\n/).join(input.lineEnding);
}

function buildPurgeAll(input, purge_commands) {
  const result = purge_commands.map(m => (input.isDosPaths ? 'CALL ' : '') + m).join(os.platform() === 'win32' ? '\r\n' : '\n');

  const script_out_file = `purge-all${input.scriptExtension}`;
  console.log(`---: ${script_out_file} :---------------------------------------`);
  const filename = `${script_path}${script_out_file}`;
  console.log(`sourceData: purge-all: ${filename}`); //, purge_commands);

  fs.writeFileSync(filename, fixLineEndings(input, result));
}

function buildPurgeScript(input, platform, sourceData, template, script_path) {
  sourceData.command_file = 'purge-' + platform.name;

  const script_out_file = `${sourceData.command_file}${input.scriptExtension}`;
  console.log(`---: ${script_out_file} :---------------------------------------`);
  const filename = `${script_path}${script_out_file}`;
  console.log(`sourceData: ${sourceData.command_file}: ${filename}`); //, sourceData);

  const result = template(sourceData);
  //console.log(filename, result);
  fs.writeFileSync(filename, fixLineEndings(input, result));

  return script_out_file;
};

function buildCommandScripts(input, platform, template, script_path) {
  let sourceData = {};
  platform.commands.forEach(command => {
    sourceData = deepClone(platform);
    delete sourceData.commands;

    sourceData.command_file = command.name || Object.keys(command)[0];
    sourceData.command = command.cmd || command[sourceData.command_file];

    sourceData.create_volumes = {};
    sourceData.volumes = {};
    sourceData.ports = {};
    sourceData.extra_parameters = {};

    for (const [idx, volume] of Object.entries(platform.volumes)) {

      const volume_key = volume.name || Object.keys(volume)[0];
      const volume_path = volume.path || volume[volume_key];
      const real_volume_key = volume_key === 'CURRENT_DIRECTORY' ? input.currentPathVariable : volume_key;

      //console.log(`>>>>> vol "${real_volume_key}:${volume_path}"`, volume);

      sourceData.volumes[real_volume_key] = volume_path;
      if (!volume.no_create) {
        sourceData.create_volumes[real_volume_key] = volume_path;
      }
      // else {
      //   console.log(`>>>>>>> vol "${real_volume_key}:${volume_path}" no create`, volume);
      // }
    }

    if ('ports' in platform) {
      for (const [idx, obj] of Object.entries(platform.ports)) {
        for (const [key, value] of Object.entries(obj)) {
          sourceData.ports[key] = value;
        }
      }
    }
    if ('ports' in command) {
      for (const [idx, obj] of Object.entries(command.ports)) {
        for (const [key, value] of Object.entries(obj)) {
          sourceData.ports[key] = value;
        }
      }
    }

    // console.log(`>>>>> platform ${platform.name}:${sourceData.command_file}`,platform);
    // console.log(`>>>>> command ${platform.name}:${sourceData.command_file}`,command);
    if ('extra_parameters' in platform) {
      for (const [idx, obj] of Object.entries(platform.extra_parameters)) {
        sourceData.extra_parameters[idx] = obj;
      }
    }
    if ('extra_parameters' in command) {
      for (const [idx, obj] of Object.entries(command.extra_parameters)) {
        sourceData.extra_parameters[idx] = obj;
      }
    }
    console.log(`>>>>> sourceData ${platform.name}:${sourceData.command_file}`, sourceData);

    const script_out_file = `${sourceData.command_file}${input.scriptExtension}`;
    console.log(`---: ${script_out_file} :---------------------------------------`);
    const filename = `${script_path}${script_out_file}`;
    //console.log(`sourceData: ${sourceData.command_file}: ${filename}`, sourceData);

    const result = template(sourceData);
    //console.log(filename, result);
    fs.writeFileSync(filename, fixLineEndings(input, result));
  });
  return sourceData;
}

function scriptBuilder(
  input
) {
  const yamlData = fs.readFileSync(input.templateData, 'utf8');
  const data = yaml.load(yamlData);

  const source = fs.readFileSync(input.templateSource, 'utf8');
  const template = Handlebars.compile(source);

  const purgeSource = fs.readFileSync(input.purgeTemplateSource, 'utf8');
  const purgeTemplate = Handlebars.compile(purgeSource);

  let purge_commands = [];

  if (data.platforms) {
    data.platforms.forEach(platform => {
      console.log(`===: ${platform.name} :=======================================`);
      if ('docker_file' in platform) {
        platform.docker_file = platform.docker_file.replace('{SCRIPT_ROOT}', input.scriptRootVariable);
        if (input.isDosPaths) {
          platform.docker_file = platform.docker_file.replace('/', '\\');
        } else {
          platform.docker_file = platform.docker_file.replace('\\', '/');
        }
      }
      console.log(`platform: ${platform.name}: `, platform);

      const sourceData = buildCommandScripts(input, platform, template, script_path);
      const purge_command = buildPurgeScript(input, platform, sourceData, purgeTemplate, script_path);
      purge_commands.push(purge_command);
    });

    buildPurgeAll(input, purge_commands);
  } else {
    console.error(`no platforms defined`, data);
  }
}

// build batch files
scriptBuilder({
  templateData: 'command_def.yaml',
  templateSource: 'command_script.hbs',
  scriptRootVariable: '%SCRIPT_ROOT%',
  isDosPaths: true,
  currentPathVariable: '%cd%',
  scriptExtension: '.bat',
  purgeTemplateSource: 'purge_script.hbs',
  lineEnding: '\r\n'
});

// build bash files
scriptBuilder({
  templateData: 'command_def.yaml',
  templateSource: 'shell_script.hbs',
  scriptRootVariable: '$SCRIPT_ROOT/',
  isDosPaths: false,
  currentPathVariable: '$PWD',
  scriptExtension: '',
  purgeTemplateSource: 'purge_script.hbs',
  lineEnding: '\n'
});

