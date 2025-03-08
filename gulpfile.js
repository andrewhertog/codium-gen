const gulp = require('gulp');
const replace = require('gulp-replace');
const rename = require('gulp-rename');
const del = require('del');

const LABEL = "codex";
const TITLE = "Codex";
const DEST_REPO = "BiblioNexus-Foundation/codex";
const URL = "www.codex.bible";

// Define source files to process, excluding binaries
const SRC = [
  'vscodium/**/*',
  '!vscodium/**/*.{ico,icns}',
  '!vscodium/.git/**'
];

// Replace tasks
function replaceText() {
  return gulp.src(SRC, { base: './' })
    .pipe(replace('https://github.com/VSCodium/vscodium', `https://github.com/${DEST_REPO}`))
    .pipe(replace('VSCodium/vscodium', DEST_REPO))
    .pipe(replace('www.vscodium.com', URL))
    .pipe(replace('VSCodium', TITLE))
    .pipe(replace('Codium', TITLE))
    .pipe(replace('vscodium', LABEL))
    .pipe(replace('codium', LABEL))
    // Fix backwards replacements
    .pipe(replace(`${LABEL}/${LABEL}-linux-build-agent`, 'vscodium/vscodium-linux-build-agent'))
    .pipe(replace(`${TITLE}/vscode-linux-build-agent`, 'VSCodium/vscode-linux-build-agent'))
    .pipe(gulp.dest('./'));
}

// Rename files
function renameFiles() {
  const filesToRename = [
    'build/windows/msi/includes/vscodium-variables.wxi',
    'build/windows/msi/vscodium.wxs',
    'build/windows/msi/vscodium.xsl',
    'build/windows/msi/i18n/vscodium.*.wxl'
  ].map(f => `vscodium/${f}`);

  return gulp.src(filesToRename, { base: './' })
    .pipe(rename(path => {
      path.basename = path.basename.replace('vscodium', LABEL);
    }))
    .pipe(gulp.dest('./'));
}

// Clean up tasks
function cleanWorkflows() {
  return del([
    'vscodium/.github/workflows/insider-*',
    'vscodium/.github/workflows/lock.yml',
    'vscodium/.github/workflows/stale.yml',
    'vscodium/.github/workflows/stable-spearhead.yml'
  ]);
}

function cleanIcons() {
  return del(['vscodium/icons/stable/codium*']);
}

// Copy tasks
function copyExtraFiles() {
  return gulp.src('extra-files/*')
    .pipe(gulp.dest('vscodium/'));
}

function copyIcons() {
  return gulp.src('icons/**/*')
    .pipe(gulp.dest('vscodium/src/stable/resources/'));
}

// Define the series of tasks
exports.default = gulp.series(
  replaceText,
  renameFiles,
  cleanWorkflows,
  cleanIcons,
  copyExtraFiles,
  copyIcons
);
