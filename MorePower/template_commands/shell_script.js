const fs = require('fs');
const yaml = require('js-yaml');
const Handlebars = require('handlebars');

// Load YAML data
const yamlData = fs.readFileSync('command_def.yaml', 'utf8');
const data = yaml.load(yamlData);

// Define Handlebars template
const source = fs.readFileSync('shell_script.hbs', 'utf8');

// Compile the template
const template = Handlebars.compile(source);

function deepClone(obj) {
  return JSON.parse(JSON.stringify(obj));
}

data.platforms.forEach(platform => {
  console.log("==========================================");
  if ('docker_file' in platform) {
    platform.docker_file = platform.docker_file.replace('{SCRIPT_ROOT}', '$SCRIPT_ROOT/').replace('\\', '/')
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
          volumes[key === 'CURRENT_DIRECTORY' ? '$PWD' : key] = value;
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

    console.log(`------------------------------------------: ${sourceData.command_file}`);

    const filename = `/usr/src/templates/${sourceData.command_file}`;

    console.log(`sourceData: ${sourceData.command_file}: `, sourceData);

    const result = template(sourceData);
    //console.log(filename, result);
    fs.writeFileSync(filename, result);

  });

  /*
google-chrome {
name: 'google-chrome',
container: 'oobdev/google-chrome',
docker_file: '{SCRIPT_ROOT}MorePower/DockerFile.google-chrome',
working_directory: '/root/src',
volumes: [
  { CURRENT_DIRECTORY: '/root/src' },
  { '/run/desktop/mnt/host/wslg/.X11-unix': '/tmp/.X11-unix' },
  { '/run/desktop/mnt/host/wslg': '/mnt/wslg' },
  { 'google-chrome-cache': '/root/.cache/google-chrome' },
  {
    'google-chrome-config': '/root/.config/google-chrome %EXTRA_DOCKER_COMMANDS%'
  }
],
commands: [
  { 'google-chrome': 'google-chrome' },
  { 'google-chrome-bash': 'bash' }
],
ports: [ { '8080': 80 } ]
  */


});

// console.log(data)


// // Render the template with data
// const result = template(data);

// // Output the result
// console.log(result);
