'use strict';

var config = {};

config.tag = 'AWGG';
config.name = 'Download with AWGG';

config.windowsVerbatimArguments = true;

config.cookies = true;

config.command = {
  executable: {
    Mac: '/usr/bin/awgg',
    Win: 'C:/Program Files/AWGG/awgg.exe',
    Lin: '/usr/bin/awgg',
  },
  args: {
    Mac: `[URL]`,
    Win: `[URL]`,
    Lin: `[URL]`,
  },
  get guess() {
    const key = navigator.platform.substr(0, 3);
    return {
      executable: config.command.executable[key],
      args: config.command.args[key]
    };
  }
};
