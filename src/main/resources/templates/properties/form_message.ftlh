# do add the config to production-labels.properties
# diplay name
label.${screenId?lower_case}.list=${screenId} list
label.${screenId?lower_case}.createform=${screenId} create
label.${screenId?lower_case}.createform.boxtitle=${screenId}
label.${screenId?lower_case}.updateform=${screenId} edit
label.${screenId?lower_case}.updateform.boxtitle=${screenId}
label.${screenId?lower_case}.importform=${screenId} import
label.${screenId?lower_case}.importform.boxtitle=${screenId}

# list field label
<#list records as record>
  <#if record.itemName??>
label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}=${record.itemName}
placeholder.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}=input ${record.itemName}
label.${screenId?lower_case}.list.table.${record.itemName?lower_case}=${record.itemName}
  </#if>
</#list>
label.${screenId?lower_case}.list.searchcondition.button.search=search
label.${screenId?lower_case}.list.table.select=select
label.${screenId?lower_case}.list.table.operation=operation
label.${screenId?lower_case}.list.table.tooltip.update=update
label.${screenId?lower_case}.list.table.tooltip.copy=copy
label.${screenId?lower_case}.list.table.tooltip.download=download
label.${screenId?lower_case}.list.button.clearsearchcondition=<i class="fa fa-close"></i>
label.${screenId?lower_case}.list.button.tooltip.colvis=Column visiblity
label.${screenId?lower_case}.list.button.tooltip.copyhtml5=copy
label.${screenId?lower_case}.list.button.tooltip.excelhtml5=Excel download
label.${screenId?lower_case}.list.button.create=create
label.${screenId?lower_case}.list.button.deletebatch=delete batch
label.${screenId?lower_case}.list.button.savebatch=save batch
label.${screenId?lower_case}.list.button.importcsv=import
label.${screenId?lower_case}.list.button.exportcsv=export
label.${screenId?lower_case}.list.savebatch.confirmdialog.title=save batch confirm
label.${screenId?lower_case}.list.savebatch.confirmdialog.label=You save batch. Is it OK？
label.${screenId?lower_case}.list.savebatch.confirmdialog.button.savebatch=save batch
label.${screenId?lower_case}.list.deletebatch.confirmdialog.title=delete batch confirm
label.${screenId?lower_case}.list.deletebatch.confirmdialog.label=You delete batch. Is it OK？
label.${screenId?lower_case}.list.deletebatch.confirmdialog.button.deletebatch=delete batch
placeholder.${screenId?lower_case}.list.search=search
label.${screenId?lower_case}.list.exportcsv=${screenName}
label.${screenId?lower_case}.list.exportexcel=${screenName}

# export field label
<#list records as record>
  <#if record.itemName??>
label.${screenId?lower_case}.export.column.${record.itemName?lower_case}=${record.itemName}
  </#if>
</#list>

# createform field label
<#list records as record>
  <#if record.itemName??>
label.${screenId?lower_case}.createform.${record.itemName?lower_case}=${record.itemName}
placeholder.${screenId?lower_case}.createform.${record.itemName?lower_case}=input ${record.itemName}
  </#if>
</#list>
label.${screenId?lower_case}.createform.button.close=close
label.${screenId?lower_case}.createform.button.create=save
label.${screenId?lower_case}.createform.confirmdialog.title=create confirm
label.${screenId?lower_case}.createform.confirmdialog.label=You save. Is it OK？
label.${screenId?lower_case}.createform.confirmdialog.button.create=save

# updateform field label
<#list records as record>
  <#if record.itemName??>
label.${screenId?lower_case}.updateform.${record.itemName?lower_case}=${record.itemName}
placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}=input ${record.itemName}
  </#if>
</#list>
label.${screenId?lower_case}.updateform.button.close=close
label.${screenId?lower_case}.updateform.button.delete=delete
label.${screenId?lower_case}.updateform.button.update=save
label.${screenId?lower_case}.updateform.update.confirmdialog.title=update confirm
label.${screenId?lower_case}.updateform.update.confirmdialog.label=You save. Is it OK？
label.${screenId?lower_case}.updateform.update.confirmdialog.button.update=save
label.${screenId?lower_case}.updateform.delete.confirmdialog.title=delete confirm
label.${screenId?lower_case}.updateform.delete.confirmdialog.label=You delete. Is it OK？
label.${screenId?lower_case}.updateform.delete.confirmdialog.button.delete=delete

# importform field label
label.${screenId?lower_case}.importform.importfile=import file
label.${screenId?lower_case}.importform.button.close=close
label.${screenId?lower_case}.importform.button.importcsv=import
label.${screenId?lower_case}.importform.confirmdialog.title=import confirm
label.${screenId?lower_case}.importform.confirmdialog.label=You import. Is it OK？
label.${screenId?lower_case}.importform.confirmdialog.button.importcsv=import
