# items
<#list records as record>
  <#if record.groupName??>
items.${record.groupName?lower_case}.${record.label?lower_case}=${record.labelJa}
  </#if>
</#list>
