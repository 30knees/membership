{**
 * Display member price information on product pages
 * Shows potential savings to non-members
 *
 * @author    Your Name
 * @copyright Copyright (c) 2025
 * @license   Academic Free License (AFL 3.0)
 *}

<div class="membership-price-info">
    <div class="member-savings-badge">
        <i class="material-icons">loyalty</i>
        <span class="savings-text">
            {l s='Members save' mod='membership'}
            <strong class="savings-amount">{$savings|number_format:2:'.':''} {$currency->sign|escape:'htmlall':'UTF-8'}</strong>
        </span>
    </div>
    <div class="member-price-details">
        <span class="member-price-label">{l s='Member price:' mod='membership'}</span>
        <span class="member-price-value">{$member_price|number_format:2:'.':''} {$currency->sign|escape:'htmlall':'UTF-8'}</span>
    </div>
    {if !$is_logged}
    <div class="membership-cta">
        <a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}" class="btn btn-primary btn-sm">
            {l s='Become a Member' mod='membership'}
        </a>
    </div>
    {/if}
</div>
