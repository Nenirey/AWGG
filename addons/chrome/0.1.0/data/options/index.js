/* globals config */
'use strict';

function save() {
  const executable = document.getElementById('executable').value;
  const args = document.getElementById('args').value;
  const cookies = document.getElementById('cookies').checked;
  chrome.storage.local.set({
    executable,
    args,
    cookies
  }, () => {
    const status = document.getElementById('status');
    status.textContent = 'Options saved.';
    setTimeout(() => status.textContent = '', 750);
  });
}

function restore() {
  // Use default value color = 'red' and likesColor = true.
  chrome.storage.local.get(Object.assign(config.command.guess, {
    cookies: false
  }), prefs => {
    document.getElementById('executable').value = prefs.executable;
    document.getElementById('args').value = prefs.args;
    document.getElementById('cookies').checked = prefs.cookies;
  });
}
document.addEventListener('DOMContentLoaded', restore);
document.getElementById('save').addEventListener('click', save);

if (!config.cookies) {
  [...document.querySelectorAll('[cookies]')].forEach(e => e.style = 'opacity: 0.5; pointer-events: none;');
}
