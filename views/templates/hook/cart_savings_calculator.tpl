{**
 * Display savings calculator in shopping cart
 * Shows non-members how much they can save with membership
 *
 * @author    Your Name
 * @copyright Copyright (c) 2025
 * @license   Academic Free License (AFL 3.0)
 *}

<div class="membership-savings-calculator">
    <div class="savings-header">
        <i class="material-icons">star</i>
        <h3>{l s='Membership Savings' mod='membership'}</h3>
    </div>

    <div class="savings-content">
        {if $already_saved}
            <div class="alert alert-success">
                <p class="savings-highlight">
                    {l s='You could save' mod='membership'}
                    <strong class="savings-amount">{$total_savings|number_format:2:'.':''} {$currency->sign|escape:'htmlall':'UTF-8'}</strong>
                    {l s='on this order with a membership!' mod='membership'}
                </p>
                <p class="membership-info">
                    {l s='A membership costs only' mod='membership'}
                    <strong>{$membership_price|number_format:2:'.':''} {$currency->sign|escape:'htmlall':'UTF-8'}</strong>
                    {l s='and lasts 12 months.' mod='membership'}
                </p>
                <p class="break-even-info">
                    <i class="material-icons">check_circle</i>
                    {l s='You would already save more than the membership cost with just this order!' mod='membership'}
                </p>
            </div>
        {else}
            <div class="alert alert-info">
                <p class="savings-highlight">
                    {l s='You could save' mod='membership'}
                    <strong class="savings-amount">{$total_savings|number_format:2:'.':''} {$currency->sign|escape:'htmlall':'UTF-8'}</strong>
                    {l s='on this order with a membership!' mod='membership'}
                </p>
                <p class="membership-info">
                    {l s='A membership costs' mod='membership'}
                    <strong>{$membership_price|number_format:2:'.':''} {$currency->sign|escape:'htmlall':'UTF-8'}</strong>
                    {l s='and lasts 12 months.' mod='membership'}
                </p>
                {if $orders_to_break_even > 0}
                <p class="break-even-info">
                    <i class="material-icons">calculate</i>
                    {if $orders_to_break_even == 1}
                        {l s='With just one more order like this, your membership would pay for itself!' mod='membership'}
                    {else}
                        {l s='After approximately' mod='membership'}
                        <strong>{$orders_to_break_even}</strong>
                        {l s='orders like this, your membership would pay for itself!' mod='membership'}
                    {/if}
                </p>
                {/if}
            </div>
        {/if}

        {if $membership_product_id > 0}
        <div class="membership-actions">
            {if $is_logged}
                <a href="{$link->getProductLink($membership_product_id)|escape:'html':'UTF-8'}"
                   class="btn btn-primary btn-lg">
                    <i class="material-icons">shopping_cart</i>
                    {l s='Add Membership to Cart' mod='membership'}
                </a>
            {else}
                <a href="{$link->getPageLink('authentication', true)|escape:'html':'UTF-8'}"
                   class="btn btn-primary btn-lg">
                    <i class="material-icons">person_add</i>
                    {l s='Sign Up & Become a Member' mod='membership'}
                </a>
            {/if}
            <p class="small-text">
                {l s='Members enjoy special prices on hundreds of products for 12 full months!' mod='membership'}
            </p>
        </div>
        {/if}
    </div>
</div>
