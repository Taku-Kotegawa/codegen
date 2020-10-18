# do add the config to production-labels.properties
# diplay name
label.${screenId?lower_case}.list=${screenName}一覧
label.${screenId?lower_case}.createform=${screenName}新規登録
label.${screenId?lower_case}.createform.boxtitle=${screenName}
label.${screenId?lower_case}.updateform=${screenName}編集
label.${screenId?lower_case}.updateform.boxtitle=${screenName}
label.${screenId?lower_case}.importform=${screenName}インポート
label.${screenId?lower_case}.importform.boxtitle=${screenName}

# list field label
<#list records as record>
  <#if record.itemName??>
label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}=${record.itemNameJa}
placeholder.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}=${record.itemNameJa}を入力して下さい。
label.${screenId?lower_case}.list.table.${record.itemName?lower_case}=${record.itemNameJa}
  </#if>
</#list>
label.${screenId?lower_case}.list.searchcondition.button.search=検索
label.${screenId?lower_case}.list.table.select=選択
label.${screenId?lower_case}.list.table.operation=操作
label.${screenId?lower_case}.list.table.tooltip.update=編集
label.${screenId?lower_case}.list.table.tooltip.copy=複製
label.${screenId?lower_case}.list.table.tooltip.download=ダウンロード
label.${screenId?lower_case}.list.button.clearsearchcondition=<i class="fa fa-close"></i>
label.${screenId?lower_case}.list.button.tooltip.colvis=項目選択
label.${screenId?lower_case}.list.button.tooltip.copyhtml5=コピー
label.${screenId?lower_case}.list.button.tooltip.excelhtml5=Excel ダウンロード
label.${screenId?lower_case}.list.button.create=新規登録
label.${screenId?lower_case}.list.button.deletebatch=一括削除
label.${screenId?lower_case}.list.button.savebatch=一括保存
label.${screenId?lower_case}.list.button.importcsv=インポート
label.${screenId?lower_case}.list.button.exportcsv=エクスポート
label.${screenId?lower_case}.list.savebatch.confirmdialog.title=一括保存確認
label.${screenId?lower_case}.list.savebatch.confirmdialog.label=一括保存します。よろしいですか？
label.${screenId?lower_case}.list.savebatch.confirmdialog.button.savebatch=一括保存
label.${screenId?lower_case}.list.deletebatch.confirmdialog.title=一括削除確認
label.${screenId?lower_case}.list.deletebatch.confirmdialog.label=一括削除します。よろしいですか？
label.${screenId?lower_case}.list.deletebatch.confirmdialog.button.deletebatch=一括削除
placeholder.${screenId?lower_case}.list.search=検索
label.${screenId?lower_case}.list.exportcsv=${screenName}
label.${screenId?lower_case}.list.exportexcel=${screenName}

# export field label
<#list records as record>
  <#if record.itemName??>
label.${screenId?lower_case}.export.column.${record.itemName?lower_case}=${record.itemNameJa}
  </#if>
</#list>

# createform field label
<#list records as record>
  <#if record.itemName??>
label.${screenId?lower_case}.createform.${record.itemName?lower_case}=${record.itemNameJa}
placeholder.${screenId?lower_case}.createform.${record.itemName?lower_case}=${record.itemNameJa}を入力して下さい。
  </#if>
</#list>
label.${screenId?lower_case}.createform.button.close=閉じる
label.${screenId?lower_case}.createform.button.create=保存
label.${screenId?lower_case}.createform.confirmdialog.title=新規登録確認
label.${screenId?lower_case}.createform.confirmdialog.label=保存します。よろしいですか？
label.${screenId?lower_case}.createform.confirmdialog.button.create=保存

# updateform field label
<#list records as record>
  <#if record.itemName??>
label.${screenId?lower_case}.updateform.${record.itemName?lower_case}=${record.itemNameJa}
placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}=${record.itemNameJa}を入力して下さい。
  </#if>
</#list>
label.${screenId?lower_case}.updateform.button.close=閉じる
label.${screenId?lower_case}.updateform.button.delete=削除
label.${screenId?lower_case}.updateform.button.update=保存
label.${screenId?lower_case}.updateform.update.confirmdialog.title=更新確認
label.${screenId?lower_case}.updateform.update.confirmdialog.label=保存します。よろしいですか？
label.${screenId?lower_case}.updateform.update.confirmdialog.button.update=保存
label.${screenId?lower_case}.updateform.delete.confirmdialog.title=削除確認
label.${screenId?lower_case}.updateform.delete.confirmdialog.label=削除します。よろしいですか？
label.${screenId?lower_case}.updateform.delete.confirmdialog.button.delete=削除

# importform field label
label.${screenId?lower_case}.importform.importfile=インポートファイル
label.${screenId?lower_case}.importform.button.close=閉じる
label.${screenId?lower_case}.importform.button.importcsv=インポート
label.${screenId?lower_case}.importform.confirmdialog.title=インポート確認
label.${screenId?lower_case}.importform.confirmdialog.label=インポートします。よろしいですか？
label.${screenId?lower_case}.importform.confirmdialog.button.importcsv=インポート
