{%- macro info_schema(info_schema_type, dataset='', region='region-us') -%}
{%- if dataset != '' -%}
`{{ target.database }}.{{ target.schema }}`.INFORMATION_SCHEMA.{{ info_schema_type }}
{%- else -%}
`{{ target.database }}.{{ region }}`.INFORMATION_SCHEMA.{{ info_schema_type }}
{%- endif -%}
{%- endmacro -%}