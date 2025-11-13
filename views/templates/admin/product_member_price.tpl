{**
 * Admin template for member pricing on product page
 *
 * @author    Your Name
 * @copyright Copyright (c) 2025
 * @license   Academic Free License (AFL 3.0)
 *}

<div class="panel product-tab">
    <div class="panel-heading">
        <i class="icon-tags"></i>
        {l s='Member Pricing' mod='membership'}
    </div>
    <div class="form-wrapper">
        <div class="form-group">
            <label class="control-label col-lg-3">
                <span class="label-tooltip" data-toggle="tooltip"
                      title="{l s='Enable special pricing for members' mod='membership'}">
                    {l s='Enable Member Price' mod='membership'}
                </span>
            </label>
            <div class="col-lg-9">
                <span class="switch prestashop-switch fixed-width-lg">
                    <input type="radio" name="enable_member_price" id="enable_member_price_on" value="1"
                           {if $member_price_enabled}checked="checked"{/if}>
                    <label for="enable_member_price_on">{l s='Yes' mod='membership'}</label>
                    <input type="radio" name="enable_member_price" id="enable_member_price_off" value="0"
                           {if !$member_price_enabled}checked="checked"{/if}>
                    <label for="enable_member_price_off">{l s='No' mod='membership'}</label>
                    <a class="slide-button btn"></a>
                </span>
                <p class="help-block">
                    {l s='Enable this to set a special price for members' mod='membership'}
                </p>
            </div>
        </div>

        <div id="member_price_options" style="display: {if $member_price_enabled}block{else}none{/if};">
            <div class="form-group">
                <label class="control-label col-lg-3">
                    {l s='Reduction Type' mod='membership'}
                </label>
                <div class="col-lg-9">
                    <select name="member_price_reduction_type" id="member_price_reduction_type" class="fixed-width-xl">
                        <option value="percentage" {if $member_price_reduction_type == 'percentage'}selected="selected"{/if}>
                            {l s='Percentage' mod='membership'}
                        </option>
                        <option value="amount" {if $member_price_reduction_type == 'amount'}selected="selected"{/if}>
                            {l s='Amount' mod='membership'}
                        </option>
                    </select>
                    <p class="help-block">
                        {l s='Choose whether to apply a percentage discount or a fixed amount discount' mod='membership'}
                    </p>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-lg-3">
                    {l s='Reduction Value' mod='membership'}
                </label>
                <div class="col-lg-9">
                    <div class="input-group fixed-width-xl">
                        <input type="text" name="member_price_reduction_value"
                               value="{$member_price_reduction_value|escape:'htmlall':'UTF-8'}"
                               class="form-control">
                        <span class="input-group-addon" id="member_price_unit">
                            {if $member_price_reduction_type == 'percentage'}%{else}{$currency->sign|escape:'htmlall':'UTF-8'}{/if}
                        </span>
                    </div>
                    <p class="help-block">
                        {l s='Enter the discount value (percentage or amount)' mod='membership'}
                    </p>
                </div>
            </div>

            <div class="form-group">
                <label class="control-label col-lg-3">
                    {l s='Fixed Member Price (Optional)' mod='membership'}
                </label>
                <div class="col-lg-9">
                    <div class="input-group fixed-width-xl">
                        <input type="text" name="member_price_fixed"
                               value="{$member_price_fixed|escape:'htmlall':'UTF-8'}"
                               class="form-control">
                        <span class="input-group-addon">{$currency->sign|escape:'htmlall':'UTF-8'}</span>
                    </div>
                    <p class="help-block">
                        {l s='Set a fixed member price (overrides reduction if set). Leave at 0 to use reduction instead.' mod='membership'}
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
(function() {
    // Check if jQuery is available
    if (typeof jQuery === 'undefined') {
        console.error('Membership module: jQuery is not loaded');
        return;
    }

    jQuery(document).ready(function($) {
        // Show/hide member price options based on toggle
        $('input[name="enable_member_price"]').on('change', function() {
            if ($(this).val() == '1') {
                $('#member_price_options').show();
            } else {
                $('#member_price_options').hide();
            }
        });

        // Update currency symbol based on reduction type
        $('#member_price_reduction_type').on('change', function() {
            var symbol = $(this).val() == 'percentage' ? '%' : '{$currency->sign|escape:'javascript':'UTF-8'}';
            $('#member_price_unit').text(symbol);
        });
    });
})();
</script>
