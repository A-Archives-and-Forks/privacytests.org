/* global postDataAndCarryOn */

// # Miscellaneous tests

const runTests = async () => {
  const urlParams = new URLSearchParams(window.location.search);
  const results = {};
  for (const param of urlParams.keys()) {
    results[param] = urlParams.get(param);
  }
  console.log(results);
  await postDataAndCarryOn(results, 'query');
};

runTests();
