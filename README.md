# Customer Membership Module for PrestaShop 8.2.3

## Overview

This module enables customer membership functionality in PrestaShop, allowing customers to purchase memberships that grant them special pricing on products for a 12-month period.

## Features

- **Membership Purchase**: Customers can purchase a membership product (digital/virtual)
- **Member Pricing**: Set special prices for members on any product
- **12-Month Duration**: Memberships are valid for 12 months from purchase date (no auto-renewal)
- **Savings Calculator**: Shows non-members how much they can save by becoming a member
- **Break-Even Analysis**: Calculates how many orders it takes for membership to pay for itself
- **Automatic Application**: Member prices are automatically applied to logged-in members
- **Admin Configuration**: Easy-to-use admin interface for setting up membership products and pricing

## Installation

1. Copy the `membership` folder to your PrestaShop `/modules/` directory
2. Go to **Back Office > Modules > Module Manager**
3. Search for "Customer Membership"
4. Click **Install**

### Verify Module Structure (Optional but recommended)

Before packaging or deploying the module, you can run the automated structure
verification script to ensure all of the required files for PrestaShop 8.2 are
present:

```bash
php tools/verify_module_structure.php
```

The script checks for the main module file, configuration metadata, Composer
settings, translation scaffolding, and compatibility declarations so you can
quickly confirm that the module complies with PrestaShop 8.2 expectations.

## Configuration

### Step 1: Set Up Membership Product

1. Go to **Back Office > Modules > Module Manager**
2. Find "Customer Membership" and click **Configure**
3. Select which product is your membership product (recommended: create a virtual/digital product)
4. Set the membership duration (default: 12 months)
5. Click **Save**

### Step 2: Create Member Pricing on Products

1. Go to **Catalog > Products**
2. Edit any product
3. Scroll to the **Member Pricing** section
4. Enable **Member Price**
5. Choose reduction type:
   - **Percentage**: Discount as a percentage (e.g., 10%)
   - **Amount**: Fixed discount amount (e.g., $5.00)
6. Enter the reduction value
7. (Optional) Set a fixed member price to override the reduction calculation
8. Click **Save**

## How It Works

### For Customers (Non-Members)

1. When browsing products with member pricing, customers see:
   - Regular price
   - Potential savings with membership
   - Call-to-action to become a member

2. In the shopping cart, customers see:
   - Total savings they could get with membership on current cart
   - Cost of membership
   - Break-even analysis (e.g., "After 3 orders like this, your membership pays for itself!")

3. Customers can purchase the membership product like any other product

### For Members

1. Upon successful purchase of the membership product:
   - Membership is automatically activated
   - Valid for 12 months from purchase date

2. When logged in, members see:
   - Member prices automatically applied to all products
   - "Member Price Active" badge on products with member pricing
   - No savings calculator (they already have membership)

3. Member pricing is applied:
   - On product pages
   - In shopping cart
   - At checkout

### For Shop Owners

1. Easy configuration:
   - Select membership product
   - Set membership duration

2. Flexible pricing:
   - Set member prices per product
   - Choose percentage or fixed amount discounts
   - Override with fixed member prices

3. Automatic management:
   - Memberships expire automatically after 12 months
   - No manual intervention needed

## Database Structure

### Table: `ps_membership_customer`

Stores customer membership records.

| Column | Type | Description |
|--------|------|-------------|
| id_membership | INT | Primary key |
| id_customer | INT | Customer ID |
| id_order | INT | Order ID that granted membership |
| date_start | DATETIME | Membership start date |
| date_end | DATETIME | Membership expiration date |
| active | TINYINT | Whether membership is active |
| date_add | DATETIME | Record creation date |
| date_upd | DATETIME | Record update date |

### Table: `ps_membership_product_price`

Stores member prices for products.

| Column | Type | Description |
|--------|------|-------------|
| id_membership_price | INT | Primary key |
| id_product | INT | Product ID |
| member_price | DECIMAL | Fixed member price (if set) |
| reduction_type | ENUM | "percentage" or "amount" |
| reduction_value | DECIMAL | Reduction value |
| date_add | DATETIME | Record creation date |
| date_upd | DATETIME | Record update date |

## Hooks Used

- `actionValidateOrder`: Grant membership when membership product is purchased
- `displayAdminProductsExtra`: Add member pricing fields to product admin page
- `actionProductSave`: Save member pricing when product is saved
- `actionProductDelete`: Delete member pricing when product is deleted
- `displayProductPriceBlock`: Show savings info to non-members on product pages
- `displayShoppingCartFooter`: Display savings calculator in cart
- `displayHeader`: Add CSS to pages
- `actionGetProductPropertiesAfter`: Modify product prices for members
- `displayProductButtons`: Display member badge on product pages

## Technical Details

### Pricing Logic

1. **For non-members**: Regular prices are displayed with savings info
2. **For members**: Prices are calculated as:
   - If `member_price` > 0: Use fixed member price
   - If `reduction_type` = "percentage": `price - (price × reduction_value / 100)`
   - If `reduction_type` = "amount": `price - reduction_value`

### Membership Validation

- Memberships are checked by:
  - Customer ID must exist
  - `active` = 1
  - `date_end` >= current date

### Break-Even Calculator

- Calculates: `ceil(membership_price / total_savings)`
- Shows different messages if customer would save more than membership cost in single order

## Best Practices

1. **Membership Product Setup**:
   - Create as virtual/digital product (no shipping needed)
   - Set appropriate price for your market
   - Add clear description of membership benefits

2. **Member Pricing Strategy**:
   - Use percentage discounts for consistency across products
   - Use fixed member prices for specific promotional items
   - Balance pricing to make membership attractive but profitable

3. **Testing**:
   - Test membership purchase flow
   - Verify member prices apply correctly
   - Check savings calculator accuracy
   - Test membership expiration

## Troubleshooting

### Member prices not showing

- Check that member pricing is enabled for the product
- Verify customer is logged in
- Confirm membership hasn't expired
- Check that reduction value is greater than 0

### Membership not granted after purchase

- Verify correct membership product ID is set in module configuration
- Check that order status is validated/paid
- Look for database errors in PrestaShop logs

### Savings calculator not appearing

- Ensure cart has products with member pricing
- Verify customer is not already a member
- Check that membership product ID is configured

## Module Structure

```
membership/
├── membership.php              # Main module class
├── config.xml                  # Module metadata
├── README.md                   # This file
├── index.php                   # Security file
├── views/
│   ├── css/
│   │   └── membership.css      # Module styles
│   └── templates/
│       ├── admin/
│       │   └── product_member_price.tpl    # Admin product form
│       └── hook/
│           ├── product_member_price_info.tpl   # Product page info
│           ├── cart_savings_calculator.tpl     # Cart calculator
│           └── member_badge.tpl                # Member badge
└── sql/                        # Future SQL scripts directory
```

## Requirements

- PrestaShop 8.0.0 or higher
- PHP 7.4 or higher
- MySQL 5.7 or higher

## Support

For issues, bugs, or feature requests, please contact the module author.

## License

Academic Free License (AFL 3.0)

## Version History

### 1.0.0 (2025)
- Initial release
- Membership purchase and validation
- Member pricing system
- Savings calculator
- Admin configuration interface
