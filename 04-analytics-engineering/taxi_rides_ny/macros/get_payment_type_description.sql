{##
    This macro returns the description of the payment_type
#}

{% macro get_payment_type_description(payment_type) %}

        case cast( {{payment_type}} as integer )
            when 1 then 'Credit card'
            when 2 then 'Cash'
            when 1 then 'No Charge'
            when 1 then 'Dispute'
            when 1 then 'Unkown'
            when 1 then 'Voided trip'
            else 'EMPTY'
        end

{%- endmacro %}