/* globals config, Parser */
'use strict';

var tools = {};
tools.cookies = url => {
  if (!url || !chrome.cookies) {
    return Promise.resolve('');
  }
  return new Promise(resolve => {
    chrome.storage.local.get({
      cookies: false
    }, prefs => prefs.cookies ? chrome.cookies.getAll({
      url
    }, arr => resolve(arr.map(o => o.name + '=' + o.value).join('; '))) : resolve(''));
  });
};
tools.fetch = ({url, method = 'GET', headers = {}, data = {}}) => {
  return new Promise((resolve, reject) => {
    const req = new XMLHttpRequest();
    req.open(method, url);
    Object.entries(headers).forEach(([key, value]) => {
      req.setRequestHeader(key, value);
    });
    req.onload = () => resolve(req);
    req.onerror = req.ontimeout = () => reject(new Error('network error'));
    req.send(Object.entries(data).map(([key, value]) => key + '=' + encodeURIComponent(value)).join('&'));
  });
};

function notify(message) {
  chrome.notifications.create({
    type: 'basic',
    iconUrl: '/data/icons/48.png',
    title: config.name,
    message: message.message || message
  });
}

function execute(d) {
  return new Promise((resolve, reject) => {
    chrome.storage.local.get(config.command.guess, prefs => {
      if (!prefs.executable) {
        return notify('Use options page to define a command');
      }
      const p = new Parser();
      tools.cookies(d.referrer).then(cookies => {
        // remove args that are not provided
        if (!d.referrer) {
          prefs.args = prefs.args.replace(/\s[^\s]*\[REFERRER\][^\s]*\s/, ' ');
        }
        if (!d.filename) {
          prefs.args = prefs.args.replace(/\s[^\s]*\[FILENAME\][^\s]*\s/, ' ');
        }

        const termref = {
          lineBuffer: prefs.args
            .replace(/\[URL\]/g, d.finalUrl || d.url)
            .replace(/\[REFERRER\]/g, d.referrer)
            .replace(/\[USERAGENT\]/g, navigator.userAgent)
            .replace(/\[FILENAME\]/g, d.filename)
            .replace(/\\/g, '\\\\')
        };
        p.parseLine(termref);

        chrome.runtime.sendNativeMessage('com.add0n.native_client', {
          permissions: ['child_process', 'path', 'os', 'crypto', 'fs'],
          args: [cookies, prefs.executable, ...termref.argv],
          script: String.raw`
            const cookies = args[0];
            const command = args[1].replace(/%([^%]+)%/g, (_, n) => env[n]);
            function execute () {
              const exe = require('child_process').spawn(command, args.slice(2), {
                detached: true,
                windowsVerbatimArguments: ${Boolean(config.windowsVerbatimArguments)}
              });
              let stdout = '', stderr = '';
              exe.stdout.on('data', data => stdout += data);
              exe.stderr.on('data', data => stderr += data);

              exe.on('close', code => {
                push({code, stdout, stderr});
                done();
              });
              if (${config.detached}) {
                setTimeout(() => {
                  push({code: 0});
                  done();
                  process.exit();
                }, 5000);
              }
            }

            if (cookies) {
              const filename = require('path').join(
                require('os').tmpdir(),
                'download-with-' + require('crypto').randomBytes(4).readUInt32LE(0) + ''
              );
              require('fs').writeFile(filename, cookies, e => {
                if (e) {
                  push({code: 1, stderr: 'cannot create tmp file'});
                  done();
                }
                else {
                  args = args.map(s => s.replace(/\[COOKIES\]/g, filename));
                  execute();
                }
              });
            }
            else {
              args = args.map(s => s.replace(/\[COOKIES\]/g, '.'));
              execute();
            }
          `
        }, res => {
          if (!res) {
            chrome.tabs.create({
              url: '/data/guide/index.html'
            });
            return reject();
          }
          if (res && res.code !== 0) {
            return reject(res.stderr || res.error || res.err);
          }
          window.setTimeout(resolve, config.delay || 0);
        });
      });
    });
  });
}

function sendTo(d, tab = {}) {
  (config.pre ? config.pre.action() : Promise.resolve(false))
    .then(running => !running && execute(d)).then(() => config.post && config.post.action(d, tab))
    .then(() => {
      if (d.id) {
        chrome.downloads.cancel(d.id, () => {
          chrome.downloads.erase({
            id: d.id
          });
        });
      }
    })
    .catch(e => e && notify(e));
}

var id;
function observe(d, response = () => {}) {
  response();
  const url = d.finalUrl || d.url;
  if (url.startsWith('http') || url.startsWith('ftp')) {
    if (d.url.indexOf('github.com/belaviyo/native-client') !== -1) {
      return false;
    }
    if (id === d.id || d.error) {
      return false;
    }
    chrome.downloads.pause(d.id, () => sendTo(d));
  }
  return false;
}

function changeState(enabled) {
  const diSupport = Boolean(chrome.downloads.onDeterminingFilename);
  const download = diSupport ? chrome.downloads.onDeterminingFilename : chrome.downloads.onCreated;
  if (enabled) {
    download.addListener(observe);
  }
  else {
    download.removeListener(observe);
  }
  chrome.browserAction.setIcon({
    path: {
      '16': 'data/icons/' + (enabled ? '' : 'disabled/') + '16.png',
      '32': 'data/icons/' + (enabled ? '' : 'disabled/') + '32.png',
      '64': 'data/icons/' + (enabled ? '' : 'disabled/') + '64.png'
    }
  });
  chrome.browserAction.setTitle({
    title: `${config.name}

Integration is "${enabled ? 'enabled' : 'disabled'}"`
  });
}

function onCommand(toggle = true) {
  chrome.storage.local.get({
    enabled: false
  }, prefs => {
    const enabled = toggle ? !prefs.enabled : prefs.enabled;
    chrome.storage.local.set({
      enabled
    });
    changeState(enabled);
  });
}

chrome.browserAction.onClicked.addListener(onCommand);
onCommand(false);

(function(callback) {
  chrome.runtime.onInstalled.addListener(callback);
  chrome.runtime.onStartup.addListener(callback);
})(function() {
  chrome.contextMenus.create({
    id: 'open-link',
    title: config.name,
    contexts: ['link'],
    documentUrlPatterns: ['*://*/*']
  });
  chrome.contextMenus.create({
    id: 'open-video',
    title: config.name,
    contexts: ['video', 'audio'],
    documentUrlPatterns: ['*://*/*']
  });
});
chrome.contextMenus.onClicked.addListener((info, tab) => {
  sendTo({
    finalUrl: info.menuItemId === 'open-video' ? info.srcUrl : info.linkUrl,
    referrer: info.pageUrl
  }, tab);
});

// FAQs & Feedback
chrome.storage.local.get({
  'version': null,
  'faqs': false
}, prefs => {
  const version = chrome.runtime.getManifest().version;

  if (prefs.version ? (prefs.faqs && prefs.version !== version) : true) {
    chrome.storage.local.set({version}, () => {
      chrome.tabs.create({
        url: 'http://add0n.com/download-with.html?from=' + config.tag + '&version=' + version +
          '&type=' + (prefs.version ? ('upgrade&p=' + prefs.version) : 'install')
      });
    });
  }
});
{
  const {name, version} = chrome.runtime.getManifest();
  chrome.runtime.setUninstallURL('http://add0n.com/feedback.html?name=' + name + '&version=' + version);
}
