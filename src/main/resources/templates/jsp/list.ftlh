<%@ include file="/WEB-INF/views/common/includes/include-datatables.jsp" %>

<section class="content-header">
  <div class="container">
    <div class="row mb-2">
      <div class="col-18">
        <h4>${screenName}一覧</h4>
      </div>
      <div class="col-18 text-right">
      </div>
    </div>
  </div>
</section>

<section class="content">
  <div class="container">

    <t:messagesPanel panelClassName="callout" panelTypeClassPrefix="callout-" disableHtmlEscape="true" />
    <!-- ここより下にメインコンテンツを記入 -->

    <div class="form-check-inline" style="width:100%">
      <input id="draft" type="checkbox" checked="checked">
      <label for="checkbox011">下書きを含む</label>
    </div>

    <table id="list" class="table-sm table-striped">
      <thead>
        <tr class="filter">
          <th class="text-center px-1" data-filter="disable"></th>
          <th data-filter="disable"></th>
<#list records as record>
  <#if record.itemName?? && record.useItemForList??>
                <th></th>
  </#if>
</#list>
        </tr>
        <tr class="title">
          <th class="text-center px-0"></th>
          <th class="text-center">操作</th>
<#list records as record>
  <#if record.itemName?? && record.useItemForList??>
                <th class="text-center">${record.itemNameJa}</th>
  </#if>
</#list>
        </tr>
      </thead>
      <tbody></tbody>
    </table>

    <!-- ここより上にメインコンテンツを記入 -->
  </div>
</section>

<!-- Page script -->
<script>
  $(document)
    .ready(
      function () {

        // 項目単位フィルタ用のInputフィールドを追加する。
        // TODO 開始列番号を指定
        var startcolnum = 0;
        $('tr.filter th').each(function () {
          var idx = $(this).index();
          if (startcolnum <= idx && $(this).data("filter") != 'disable') {
            $(this).html('<input type="text" id="col_filter_' + idx + '" data-column="' + idx +
              '" class="dataTables_column_filter form-control" />');
          }
        });

        var table = $('#list').DataTable({

          'ajax': {
            'url': 'list/json',
            'data': myflatten
          },

          // 一覧に表示する項目とJSONの項目にマッピング
          'columns': [{
              data: 'id',
              className: 'text-center',
              orderable: false,
              searchable: false,
              checkboxes: {
                selectRow: true
              },
            },
            {
              data: 'operations',
              orderable: false,
              searchable: false,
            },
<#list records as record>
  <#if record.itemName?? && record.useItemForList??>
            {
              data: '${record.itemName}',
              render: $.fn.dataTable.render.text(),
            },
  </#if>
</#list>
          ],

          // 初期ソート
          'order': [
            [2, 'asc']
          ],

          // ボタンの表示
          'buttons': ['colvis', 'stateClear', 'csvdownload', 'tsvdownload', 'createnew'],

          // データロード後処理
          'initComplete': function (settings, json) {
            // グローバルフィルターのEnterキーでサーバに送信
            fnGlobalFilterOnReturn(table);
          },
        });

        // ページネーション後に画面トップに戻る
        table.on('page.dt', function () {
          $('html, body').animate({
            scrollTop: 0
          }, 300);
        });

        // 項目単位フィルタの追加
        // addFieldFilter(table)

        // 項目単位フィルタを追加(列の並び順対応版)
        addFieldFilter2(table)


        $('#draft').change().on('change', function (e, s) {
          localStorage.dataTables_Draft = e.target.checked;
          table.draw();
          fnColumns(table);
        });

        if (localStorage.dataTables_Draft == 'false') {
          $('#draft')[0].checked = false;
          table.draw();
        }

      });

  function myflatten(params, settings) {
    params = flatten(params, settings);
    params.draft = $('#draft')[0].checked;
    return params;
  }
</script>
