/* global postData */

const testFontFingerprinting = () => {
  // (The Algerian font installed through the iFont app on Android.)
  const div1 = document.createElement('div1');
  div1.innerText = 'font fingerprinting';
  div1.setAttribute('style', 'font-family: Monoton, Rosemary, monospace');
  const div2 = document.createElement('div2');
  div2.innerText = 'font fingerprinting';
  div2.setAttribute('style', 'font-family: Monoton, Rosemary, sans-serif');
  document.body.appendChild(div1);
  document.body.appendChild(div2);
  const width1 = div1.getBoundingClientRect().width;
  const width2 = div2.getBoundingClientRect().width;
  const diff = width2 - width1;
  const passed = Math.abs(diff) > 0.01;
  return {
    'System font detection': {
      description: "Web pages can detect the presence of a font installed on the user's system. The presence or absence of various fonts is commonly used to fingerprint users.",
      passed
    }
  };
};

const runTests = async () => {
  const resultsJSON = Object.assign({}, testFontFingerprinting());
  document.body.setAttribute('data-test-results', JSON.stringify(resultsJSON));
  await postData(resultsJSON, 'supplementary');
};

runTests();
