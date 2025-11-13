{**
 * Display member badge on product page
 * Shows to members that they're getting member pricing
 *
 * @author    Your Name
 * @copyright Copyright (c) 2025
 * @license   Academic Free License (AFL 3.0)
 *}

<div class="member-price-badge">
    <i class="material-icons">verified</i>
    <span class="badge-text">{l s='Member Price Active' mod='membership'}</span>
</div>

<style>
.member-price-badge {
    display: inline-flex;
    align-items: center;
    padding: 8px 16px;
    background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
    color: white;
    border-radius: 20px;
    font-weight: bold;
    margin: 10px 0;
    box-shadow: 0 2px 8px rgba(40, 167, 69, 0.3);
}

.member-price-badge .material-icons {
    margin-right: 6px;
    font-size: 20px;
}

.member-price-badge .badge-text {
    font-size: 14px;
}
</style>
