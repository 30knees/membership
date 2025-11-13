# Translation Files

This directory stores translation files for the Customer Membership module.

## How to Translate the Module

### Using PrestaShop Back Office

1. Go to **International > Translations** in your PrestaShop admin
2. Select **"Installed module translations"**
3. Choose your target language
4. Find **"Customer Membership"** in the list
5. Click **Modify** to translate all strings
6. Save your translations

Translation files will be automatically generated in this directory with the naming format:
- `{language_code}.php` (e.g., `fr.php`, `es.php`, `de.php`)

### Translation String Format

The module uses PrestaShop's standard translation system:

**In PHP files:**
```php
$this->l('Text to translate')
```

**In Smarty templates:**
```smarty
{l s='Text to translate' mod='membership'}
```

### Placeholders in Translations

Some strings use sprintf placeholders for dynamic values:
- `%d` - Integer/number
- `%s` - String

Example:
```
"Membership Duration: Value must be greater than 0 months. Entered: %d"
```

When translating, keep the placeholders in the correct position for your language.

### Available Translation Contexts

The module includes translations for:
- Admin configuration page
- Product admin page (member pricing section)
- Frontend product pages (savings info)
- Shopping cart (savings calculator)
- Error messages and confirmations

## Supported Languages

PrestaShop supports 75+ languages out of the box. Translation files will be created for any language you choose to translate.

Common language codes:
- `en` - English
- `fr` - French
- `es` - Spanish
- `de` - German
- `it` - Italian
- `pt` - Portuguese
- `nl` - Dutch
- `pl` - Polish
- `ru` - Russian
- `ja` - Japanese
- `zh` - Chinese

## Manual Translation

If you prefer to create translation files manually:

1. Create a file named `{language_code}.php` in this directory
2. Use PrestaShop's translation array format:
```php
<?php

global $_MODULE;
$_MODULE = [];
$_MODULE['<{membership}prestashop>membership_xxxxx'] = 'Your translation';
```

However, using the Back Office translation interface is strongly recommended.
