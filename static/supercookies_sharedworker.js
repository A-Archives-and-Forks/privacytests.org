/* eslint-env sharedworker */
/* global self */

let secret = 'none';
// throw new Error("fake");
console.log('hello from sharedworker');

self.onconnect = function (e) {
  const port = e.ports[0];

  port.onmessage = function (e) {
    if (e.data === 'request') {
      port.postMessage(secret);
    } else {
      secret = e.data;
      port.postMessage('received');
    }
  };
};
