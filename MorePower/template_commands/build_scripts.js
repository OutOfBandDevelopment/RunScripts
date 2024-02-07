const fs = require('fs');
const yaml = require('js-yaml');
const Handlebars = require('handlebars');
const os = require('os');

console.log('Hostname:',  os.hostname());
console.log('Operating System Platform:', os.platform());

function scriptBuilder(
  input
) {

  const yamlData = fs.readFileSync(input.templateData, 'utf8');
  const data = yaml.load(yamlData);

  const source = fs.readFileSync(input.templateSource, 'utf8');
  const template = Handlebars.compile(source);

  function deepClone(obj) {
    return JSON.parse(JSON.stringify(obj));
  }

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

    platform.commands.forEach(command => {
      let sourceData = deepClone(platform);
      sourceData.commands = undefined;

      for (const [key, value] of Object.entries(command)) {
        sourceData.command_file = key;
        sourceData.command = value;
      }

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

      if ('ports' in platform) {
        var ports = {};
        for (const [idx, obj] of Object.entries(platform.ports)) {
          for (const [key, value] of Object.entries(obj)) {
            ports[key] = value;
          }
        }
        sourceData.ports = ports;
      }

      console.log(`---: ${sourceData.command_file}${input.scriptExtension} :---------------------------------------`);
      
      const script_path = os.platform() === 'win32' ? process.cwd() + "\\..\\..\\" : "/usr/src/templates/";
      const filename = `${script_path}${sourceData.command_file}${input.scriptExtension}`;

      console.log(`sourceData: ${sourceData.command_file}: ${filename}`, sourceData);

      const result = template(sourceData);
      //console.log(filename, result);
      fs.writeFileSync(filename, result);

    });
  });
}

// build batch files
scriptBuilder({
  'templateData': 'command_def.yaml',
  'templateSource': 'command_script.hbs',
  'scriptRootVariable':  '%SCRIPT_ROOT%',
  'isDosPaths': true,
  'currentPathVariable':   '%cd%',
  'scriptExtension': '.bat'
});

// build bash files
scriptBuilder({
  'templateData': 'command_def.yaml',
  'templateSource': 'shell_script.hbs',
  'scriptRootVariable':  '$SCRIPT_ROOT/',
  'isDosPaths': false,
  'currentPathVariable':   '$PWD',
  'scriptExtension': ''
});

