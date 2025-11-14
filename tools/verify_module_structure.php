#!/usr/bin/env php
<?php
/**
 * PrestaShop Module Structure Verification Script
 *
 * This script inspects the module directory and validates that required files,
 * directories and metadata needed for PrestaShop 8.2 are present. It is meant
 * to be executed from the command line:
 *
 *     php tools/verify_module_structure.php [module_path]
 *
 * When no path is provided the parent directory of this script is used.
 */

declare(strict_types=1);

$moduleRoot = $argv[1] ?? dirname(__DIR__);
$moduleRoot = rtrim($moduleRoot);
if ($moduleRoot === '') {
    $moduleRoot = '.';
}
$moduleRoot = realpath($moduleRoot) ?: $moduleRoot;

if (!is_dir($moduleRoot)) {
    fwrite(STDERR, sprintf("Provided module path '%s' is not a directory." . PHP_EOL, $moduleRoot));
    exit(1);
}

$checks = [];

function add_check(array &$checks, string $label, bool $status, ?string $details = null): void
{
    $checks[] = [
        'label' => $label,
        'status' => $status,
        'details' => $details,
    ];
}

function format_status(bool $status): string
{
    return $status ? '[OK]' : '[FAIL]';
}

$requiredFiles = [
    'membership.php' => 'Main module entry file (membership.php) is present',
    'config.xml' => 'Module configuration file (config.xml) is present',
    'composer.json' => 'Composer manifest (composer.json) is present',
    'logo.png' => 'Module logo (logo.png) is present',
    'index.php' => 'Root index.php guard file is present',
];

foreach ($requiredFiles as $file => $label) {
    add_check($checks, $label, file_exists($moduleRoot . DIRECTORY_SEPARATOR . $file));
}

$requiredDirectories = [
    'sql' => 'SQL directory exists',
    'translations' => 'Translations directory exists',
    'upgrade' => 'Upgrade directory exists',
    'views' => 'Views directory exists',
];

foreach ($requiredDirectories as $dir => $label) {
    add_check($checks, $label, is_dir($moduleRoot . DIRECTORY_SEPARATOR . $dir));
}

// Ensure composer autoload directories exist when configured.
$composerPath = $moduleRoot . DIRECTORY_SEPARATOR . 'composer.json';
$composerData = null;
if (file_exists($composerPath)) {
    $composerData = json_decode((string) file_get_contents($composerPath), true);
    if (json_last_error() !== JSON_ERROR_NONE) {
        add_check($checks, 'composer.json could be decoded', false, json_last_error_msg());
    } else {
        add_check(
            $checks,
            'composer.json "type" is set to prestashop-module',
            ($composerData['type'] ?? '') === 'prestashop-module'
        );

        $phpConstraint = (string) ($composerData['require']['php'] ?? '');
        $constraintMessage = sprintf('composer.json PHP constraint (%s) allows PrestaShop 8.2 runtime', $phpConstraint ?: 'not set');
        if ($phpConstraint === '') {
            add_check($checks, $constraintMessage, false, 'No PHP version constraint defined.');
        } else {
            // This simple check ensures the minimum supported PHP version is not higher than 8.2.0
            $matches = [];
            if (preg_match('/>=\s*([0-9.]+)/', $phpConstraint, $matches)) {
                $minPhp = $matches[1];
                $allows = version_compare('8.2.0', $minPhp, '>=');
                add_check($checks, $constraintMessage, $allows, sprintf('Minimum PHP supported: %s', $minPhp));
            } else {
                add_check($checks, $constraintMessage, false, 'Unrecognised PHP version constraint.');
            }
        }

        $autoloadPsr4 = (array) ($composerData['autoload']['psr-4'] ?? []);
        foreach ($autoloadPsr4 as $directory) {
            $dir = rtrim($directory, '/');
            $path = $moduleRoot . DIRECTORY_SEPARATOR . $dir;
            add_check(
                $checks,
                sprintf('Autoload PSR-4 directory "%s" exists', $dir),
                is_dir($path),
                is_dir($path) ? null : 'Create the directory or update composer.json autoload section.'
            );
        }

        $classmap = (array) ($composerData['autoload']['classmap'] ?? []);
        foreach ($classmap as $file) {
            $path = $moduleRoot . DIRECTORY_SEPARATOR . $file;
            add_check(
                $checks,
                sprintf('Composer classmap file "%s" exists', $file),
                file_exists($path)
            );
        }
    }
}

$configPath = $moduleRoot . DIRECTORY_SEPARATOR . 'config.xml';
if (file_exists($configPath)) {
    $config = @simplexml_load_file($configPath);
    if ($config === false) {
        add_check($checks, 'config.xml can be parsed', false, 'Invalid XML structure.');
    } else {
        add_check(
            $checks,
            'config.xml declares module name "membership"',
            (string) ($config->name ?? '') === 'membership'
        );
        add_check(
            $checks,
            'config.xml declares version',
            trim((string) ($config->version ?? '')) !== ''
        );
    }
}

$moduleMainPath = $moduleRoot . DIRECTORY_SEPARATOR . 'membership.php';
if (file_exists($moduleMainPath)) {
    $moduleSource = (string) file_get_contents($moduleMainPath);
    add_check(
        $checks,
        'membership.php defines class Membership extending Module',
        (bool) preg_match('/class\s+Membership\s+extends\s+Module/i', $moduleSource)
    );

    if (preg_match('/ps_versions_compliancy\s*=\s*\[(.*?)\];/s', $moduleSource, $matches)) {
        $compliancyBlock = $matches[1];
        $minMatch = [];
        $maxMatch = [];
        $minPass = preg_match("/'min'\s*=>\s*'([^']+)'/", $compliancyBlock, $minMatch) === 1;
        $maxPass = preg_match("/'max'\s*=>\s*([^,\]]+)/", $compliancyBlock, $maxMatch) === 1;

        if ($minPass) {
            $minVersion = $minMatch[1];
            $supports = version_compare('8.2.0', $minVersion, '>=');
            add_check(
                $checks,
                sprintf("ps_versions_compliancy minimum version (%s) supports PrestaShop 8.2", $minVersion),
                $supports
            );
        } else {
            add_check($checks, 'ps_versions_compliancy minimum version is declared', false);
        }

        if ($maxPass) {
            $maxVersion = trim($maxMatch[1]);
            $maxStatus = $maxVersion === '_PS_VERSION_' || version_compare($maxVersion, '8.2.0', '>=');
            add_check(
                $checks,
                sprintf("ps_versions_compliancy maximum version (%s) covers PrestaShop 8.2", $maxVersion),
                $maxStatus
            );
        } else {
            add_check($checks, 'ps_versions_compliancy maximum version is declared', false);
        }
    } else {
        add_check($checks, 'ps_versions_compliancy block is present in membership.php', false);
    }
}

$translationFiles = ['en.php'];
foreach ($translationFiles as $translationFile) {
    $path = $moduleRoot . DIRECTORY_SEPARATOR . 'translations' . DIRECTORY_SEPARATOR . $translationFile;
    add_check(
        $checks,
        sprintf('Translation file "%s" exists', $translationFile),
        file_exists($path)
    );
}

// Output results
$moduleName = basename($moduleRoot);
$divider = str_repeat('-', 60);

echo PHP_EOL;
echo 'PrestaShop 8.2 Module Structure Verification' . PHP_EOL;
echo sprintf('Module path: %s', $moduleRoot) . PHP_EOL;
echo $divider . PHP_EOL;

$passed = 0;
foreach ($checks as $check) {
    $statusText = format_status($check['status']);
    $details = $check['details'] !== null ? sprintf(' (%s)', $check['details']) : '';
    echo sprintf('%-8s %s%s%s', $statusText, $check['label'], $details, PHP_EOL);
    if ($check['status']) {
        $passed++;
    }
}

echo $divider . PHP_EOL;
echo sprintf('Passed %d of %d checks.', $passed, count($checks)) . PHP_EOL;
echo PHP_EOL;

exit($passed === count($checks) ? 0 : 2);
