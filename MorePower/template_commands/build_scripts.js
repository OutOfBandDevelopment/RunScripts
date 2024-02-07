const fs = require('fs');
const yaml = require('js-yaml');
const Handlebars = require('handlebars');
const os = require('os');

console.log('Hostname:',  os.hostname());
console.log('Operating System Platform:', os.platform());

const script_path = os.platform() === 'win32' ? process.cwd() + "\\..\\..\\" : "/usr/src/templates/";

function deepClone(obj) {
  return JSON.parse(JSON.stringify(obj));
}

function buildPurgeAll(input, purge_commands) {
  const result = purge_commands.map(m=>(input.isDosPaths ? 'CALL ' : '') + m).join(os.platform() === 'win32' ? '\r\n' : '\n');
  
  const script_out_file = `purge-all${input.scriptExtension}`;
  console.log(`---: ${script_out_file} :---------------------------------------`);      
  const filename = `${script_path}${script_out_file}`;
  console.log(`sourceData: purge-all: ${filename}`, purge_commands);
  
  fs.writeFileSync(filename, result);
}

function buildPurgeScript(input, platform, sourceData, template, script_path) {    
  sourceData.command_file = 'purge-' + platform.name;
  
  const script_out_file = `${sourceData.command_file}${input.scriptExtension}`;
  console.log(`---: ${script_out_file} :---------------------------------------`);      
  const filename = `${script_path}${script_out_file}`;
  console.log(`sourceData: ${sourceData.command_file}: ${filename}`, sourceData);

  const result = template(sourceData);
  //console.log(filename, result);
  fs.writeFileSync(filename, result);

  return script_out_file;
};

function buildCommandScripts(input, platform, template, script_path) {
  let sourceData = {};
  platform.commands.forEach(command => {
    sourceData = deepClone(platform);
    delete sourceData.commands;
    
    sourceData.command_file = command.name || Object.keys(command)[0];
    sourceData.command = command.cmd || command[sourceData.command_file];
    
    //console.log(`>>>>> cmd`, platform, command, Object.keys(command)[0], sourceData)

    var create_volumes = {};
    var volumes = {};
    for (const [idx, obj] of Object.entries(platform.volumes)) {
      for (const [key, value] of Object.entries(obj)) {
        if (key !== 'no_create')
          volumes[key === 'CURRENT_DIRECTORY' ? input.currentPathVariable : key] = value;
        if (!obj.no_create)
          create_volumes[key] = value;
      }
    }
    sourceData.create_volumes = create_volumes;
    sourceData.volumes = volumes;

    sourceData.ports = {};
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

    const script_out_file = `${sourceData.command_file}${input.scriptExtension}`;
    console.log(`---: ${script_out_file} :---------------------------------------`);      
    const filename = `${script_path}${script_out_file}`;
    console.log(`sourceData: ${sourceData.command_file}: ${filename}`, sourceData);

    const result = template(sourceData);
    //console.log(filename, result);
    fs.writeFileSync(filename, result);
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
}

// build batch files
scriptBuilder({
  'templateData': 'command_def.yaml',
  'templateSource': 'command_script.hbs',
  'scriptRootVariable':  '%SCRIPT_ROOT%',
  'isDosPaths': true,
  'currentPathVariable':   '%cd%',
  'scriptExtension': '.bat',
  'purgeTemplateSource': 'purge_script.hbs'
});

// build bash files
scriptBuilder({
  'templateData': 'command_def.yaml',
  'templateSource': 'shell_script.hbs',
  'scriptRootVariable':  '$SCRIPT_ROOT/',
  'isDosPaths': false,
  'currentPathVariable':   '$PWD',
  'scriptExtension': '',
  'purgeTemplateSource': 'purge_script.hbs'
});

