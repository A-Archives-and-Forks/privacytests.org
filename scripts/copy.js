const fs = require('fs');
const path = require('path');
const marked = require('marked');
const template = require('./template.js');
const { getWebsiteDir } = require('./website-dir.js');

// Wraps content in a div element.
const wrapCopy = (content) => `
  <div class="copy">${content}</div>
`;

// Takes a Markdown filename in the "copy" directory
// and generates an HTML file in the "out" directory.
const generateHtmlFile = async (filename) => {
  const { createPreviewImage } = await import('./preview.mjs');
  const copy = fs.readFileSync(`../assets/copy/${filename}`, 'utf8');
  const newFilename = filename.replace('.md', '.html');
  const previewFilename = filename.replace('.md', '-preview.png');
  const canonicalUrl = filename.replace('.md', '');
  const htmlOutput = template.htmlPage({
    title: 'Open-source tests of web browser privacy',
    content: wrapCopy(marked.parse(copy)),
    cssFiles: ['../assets/css/template.css'],
    canonicalUrl,
    previewImageUrl: previewFilename
  });
  //  console.log(htmlOutput);
  const htmlPath = path.join(getWebsiteDir(), newFilename);
  fs.writeFileSync(htmlPath, htmlOutput, 'utf8');
  const previewImage = htmlPath.replace('.html', '-preview.png');
  console.log({ htmlPath, previewImage });
  await createPreviewImage(htmlPath, previewImage);
  return [newFilename, previewFilename];
};

// Read all the Markdown files in the "copy" directory and
// generate an html file for each of them in the website directory.
const generateCopyPages = async () => {
  const filenames = fs.readdirSync('../assets/copy').filter(x => x.endsWith('.md') && !x.startsWith('.'));
  const generated = [];
  for (const filename of filenames) {
    generated.push(...await generateHtmlFile(filename));
  }
  return generated;
};

if (require.main === module) {
  generateCopyPages();
}

module.exports = { generateCopyPages };
