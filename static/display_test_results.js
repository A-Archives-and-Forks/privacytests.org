/* eslint-disable camelcase */
/* global run_all_tests, postDataAndCarryOn */

const run_and_display_all_tests = async function (testResultsDiv) {
  let results = {};
  try {
    results = await run_all_tests();
    const keys = Object.keys(results).sort();
    console.log(results);
    document.body.setAttribute('data-test-results', JSON.stringify(results));
    for (const key of keys) {
      const { actual_value, desired_value, passed } = results[key];
      const div = document.createElement('div');
      div.innerText = `${passed ? 'PASS' : 'FAIL'}: ${key} [${actual_value}, ${desired_value}]`;
      div.setAttribute('class', passed ? 'test_pass' : 'test_fail');
      if (passed) {
        testResultsDiv.appendChild(div);
      } else {
        testResultsDiv.insertBefore(div, testResultsDiv.childNodes[0]);
      }
    }
  } catch (e) {
    results.error = e.toString();
  }

  await postDataAndCarryOn(results, 'fingerprinting');
};

run_and_display_all_tests(document.getElementById('test_results'));
