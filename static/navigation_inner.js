import { runAllTests } from './test_utils.js';
import { tests } from './test_definitions.js';

// Wrap the code for any browsers that don't support top-level await.
(async () => {
  await runAllTests(await tests(), { category: 'navigation' });

  console.log('hello from navigation_inner.js');
})();
