<script>
  $('#loading').show();
</script>
<div class="content-wrapper">
  <section class="content-header">
    <h1>
      <spring:message code="label.${screenId?lower_case}.list" />
    </h1>
  </section>
  <section class="content">
    <stn:messagepanel type="error" messages="${r"${errorMessages"}${r"}"}" />
    <stn:messagepanel type="warning" messages="${r"${warningMessages"}${r"}"}" />
    <stn:messagepanel type="success" messages="${r"${successMessages"}${r"}"}" />
    <form:form modelAttribute="${screenId}SearchCriteriaForm"
      action="" method="POST">
      <div class="box">
        <div class="box-header">
          <div class="row">
<#list records as record>
  <#if record.itemName?? && record.inputItemForList??>
    <#switch record.itemType>
        <#case "label">
            <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
              readonly="true" />
          <#break>
        <#case "text">
            <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
          <#switch record.type>
            <#case "java.time.LocalDateTime">
              leftIconClass="fa fa-calendar"
              <#break>
            <#case "java.time.LocalDate">
              leftIconClass="fa fa-calendar"
              <#break>
            <#default>
              <#break>
          </#switch>
              />
          <#break>
        <#case "text(combobox)">
            <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" />
          <#break>
        <#case "textarea">
            <stn:textarea path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21" rows="5"
              titleLabel="label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
              />
          <#break>
        <#case "password">
            <stn:password path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
              />
          <#break>
        <#case "select">
            <stn:select path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" multiple="false">
            </stn:select>
          <#break>
        <#case "checkbox">
            <stn:checkboxes path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}" 
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" />
          <#break>
        <#case "radiobutton">
            <stn:radiobuttons path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}" 
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" />
          <#break>
        <#case "hidden">
            <form:hidden path="${record.itemName}" />
          <#break>
        <#case "file">
            <stn:file path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"
            />
          <#break>
        <#default>
          <#break>
      </#switch>
  </#if>
</#list>
            <div class="col-md-12 text-right">
              <button type="button" id="search" class="btn btn-primary btn-inverse">
                <i class="fa fa-search fa-fw"></i>
                <spring:message code="label.${screenId?lower_case}.list.searchcondition.button.search" />
              </button>
            </div>
          </div>
        </div>
        <div class="box-body">
          <table id="${screenId}ListTable"
            class="table table-bordered table-striped nowrap">
            <thead>
              <tr role="row">
                <th align="center" data-column="0"></th>
                <th align="center" data-column="1"></th>
<#assign i = 2>
<#list records as record>
  <#if record.itemName?? && record.useItemForList??>
                <th align="center" data-column="${i}">
                  <input class="column_filter" id="col${i}_filter" type="text">
                </th>
    <#assign i = i + 1>
  </#if>
</#list>
              </tr>
              <tr role="row">
                <th class="text-center"></th>
                <th class="text-center"><spring:message code="label.${screenId?lower_case}.list.table.operation" /></th>

<#list records as record>
  <#if record.itemName?? && record.useItemForList??>
                <th class="text-center"><spring:message code="label.${screenId?lower_case}.list.table.${record.itemName?lower_case}" /></th>
  </#if>
</#list>
              </tr>
            </thead>
            <tbody>
            </tbody>
          </table>

          <form:hidden path="selectAlternateKey" />

          <!-- modal dialog -->
          <div class="modal fade" id="modal-confirm-deleteBatch">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                  <h4 class="modal-title">
                    <spring:message code="label.${screenId?lower_case}.list.deletebatch.confirmdialog.title" />
                  </h4>
                </div>
                <div class="modal-body">
                  <p>
                    <spring:message code="label.${screenId?lower_case}.list.deletebatch.confirmdialog.label" />
                  </p>
                </div>
                <div class="modal-footer">
                  <button type="button" id="deleteBatch" class="btn btn-danger btn-inverse">
                    <i class="fa fa-close fa-fw"></i>
                    <spring:message code="label.${screenId?lower_case}.list.deletebatch.confirmdialog.button.deletebatch" />
                  </button>
                </div>
              </div>
            </div>
          </div>
          <!-- /.modal dialog -->
          <!-- modal dialog -->
          <div class="modal fade" id="modal-confirm-saveBatch">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                  <h4 class="modal-title">
                    <spring:message code="label.${screenId?lower_case}.list.savebatch.confirmdialog.title" />
                  </h4>
                </div>
                <div class="modal-body">
                  <p>
                    <spring:message code="label.${screenId?lower_case}.list.savebatch.confirmdialog.label" />
                  </p>
                </div>
                <div class="modal-footer">
                  <button type="button" id="saveBatch" class="btn btn-warning btn-inverse">
                    <i class="fa fa-save fa-fw"></i>
                    <spring:message code="label.${screenId?lower_case}.list.savebatch.confirmdialog.button.savebatch" />
                  </button>
                </div>
              </div>
            </div>
          </div>
          <!-- /.modal dialog -->
        </div>
        <!-- /.box-body -->
        <div class="box-footer">
          <div class="row no-print">
            <div class="col-md-36 text-right">
              <button type="button" id="create" class="btn btn-primary btn-inverse bkn_view_hidden">
                <i class="fa fa-file-text-o fa-fw"></i>
                <spring:message code="label.${screenId?lower_case}.list.button.create"/>
              </button>
              <a id="confirm-deleteBatch" class="btn btn-danger btn-inverse bkn_view_hidden" data-toggle="modal"
                data-target="#modal-confirm-deleteBatch">
                <i class="fa fa-close fa-fw"></i>
                <spring:message code="label.${screenId?lower_case}.list.button.deletebatch" />
              </a>
              <a id="confirm-saveBatch" class="btn btn-warning btn-inverse bkn_view_hidden" data-toggle="modal"
                data-target="#modal-confirm-saveBatch">
                <i class="fa fa-save fa-fw"></i>
                <spring:message code="label.${screenId?lower_case}.list.button.savebatch" />
              </a>
              <button type="button" id="importCsv" class="btn btn-warning btn-inverse bkn_view_hidden">
                <i class="fa fa-upload fa-fw"></i>
                <spring:message code="label.${screenId?lower_case}.list.button.importcsv"/>
              </button>
              <button type="button" id="exportCsv" class="btn btn-primary btn-inverse bkn_view_hidden">
                <i class="fa fa-download fa-fw"></i>
                <spring:message code="label.${screenId?lower_case}.list.button.exportcsv" />
              </button>
            </div>
          </div>
        </div>
        <!-- /.box-footer -->
      </div>
    </form:form>
  </section>
</div>

<!-- DataTables -->
<script src="${r"${pageContext.request.contextPath"}${r"}"}/resources/plugins/DataTablesPack/datatables.min.js"></script>
<script src="${r"${pageContext.request.contextPath"}${r"}"}/resources/plugins/DataTables/extensions/checkboxes/js/dataTables.checkboxes.min.js"></script>
<script src="${r"${pageContext.request.contextPath"}${r"}"}/resources/app2/js/dataTables.js"></script>

<!-- page script -->
<script>
  var table;

  $(document)
    .ready(
      function() {
        const BASE_URL = '${r"${pageContext.request.contextPath"}${r"}"}/production/${screenId?lower_case}';

        var viewMode = getViewMode('${r"${viewMode"}${r"}"}');

        // ajax による検索 URL を取得する
        function getSearchURL() {
          var url = BASE_URL + '/list/json';
          var queryParameters = '';
          // TODO クエリパラメータを作成する

          if (isEmpty(queryParameters) == false) {
            url = url + '?' + queryParameters;
          }
           
          return encodeURI(url);
        }

        table = ${r"$("}'#${screenId}ListTable'${r")"}
          .DataTable(
            {
              'ajax' : {
                'url' : getSearchURL(),
                'dataSrc' : 'data',
                'type' : 'GET'
              },
              'columns' : [
                  { 'data' : 'alternateKey', className : 'no-bgcolor' }
                , { 'data' : null, className : 'no-bgcolor' }
<#list records as record>
  <#if record.itemName?? && record.useItemForList??>
                , { 'data' : '${record.itemName}', render : $.fn.dataTable.render.text() }
  </#if>
</#list>
              ],
              'columnDefs' : [
                {
                  // 「選択」
                  'targets' : 0,
                  'checkboxes' : {
                    'selectRow' : false
                  },
                  'orderable' : false,
                  'searchable' : false
                },
                {
                  // 「操作」
                  'targets' : 1,
                  'orderable' : false,
                  'render' : function(data, type, row) {
                    // TODO アイコンリンクの作成
                    // URLの作成
                    var alternateKey = row['alternateKey'];
                    var editUrl = encodeURI(BASE_URL + '/edit/' + alternateKey + '/update?form');
                    var copyUrl = encodeURI(BASE_URL + '/create?form&alternateKey=' + alternateKey);
                    // リンクの作成
                    var result = '';
                    result += '<a href="javascript:openNewWindowByName(\'' + editUrl + '\', \'' + editUrl + '\');" class="fa fa-edit fa-fw warning" title="' + ATTR_TITLE_EDIT + '"></a>';
                    if (viewMode == VIEW_MODE_EDIT) {
                      result += '<a href="javascript:openNewWindowByName(\'' + copyUrl + '\', \'' + copyUrl + '\');" class="fa fa-copy fa-fw primary" title="' + ATTR_TITLE_COPY + '"></a>';
                    }

                    return result;
                  },
                  'searchable' : false
                }
              ],
              'createdRow' : function(row, data, index) {
                // TODO 背景色の設定
              },
              'fixedColumns' : {
                'leftColumns' : 2
              },
              // TODO 初期ソートの設定
              'order' : [ [ 0, 'asc' ] ],
              'select' : false,
              'stateSave' : false,
              'buttons' : 
                [ 
                  {
                    extend : 'colvis',
                    titleAttr : '<spring:message code="label.${screenId?lower_case}.list.button.tooltip.colvis" />'
                  },
                  { 
                    extend : 'copyHtml5',
                    titleAttr : '<spring:message code="label.${screenId?lower_case}.list.button.tooltip.copyhtml5" />',
                    exportOptions: {
                      columns : ':visible'
                    }
                  },
                  {
                    extend : 'excelHtml5',
                    titleAttr : '<spring:message code="label.${screenId?lower_case}.list.button.tooltip.excelhtml5" />',
                    title : '<spring:message code="label.${screenId?lower_case}.list.exportexcel" />',
                    exportOptions: {
                      columns : ':visible'
                    }
                  },
                  'stateClear'
                ]
            });

        $('.dataTables_filter_wrapper input.form-control').attr('placeholder', '<spring:message code="placeholder.${screenId?lower_case}.list.search" />');
        $('.dataTables_filter_wrapper input.form-control').after('<button type="button" id="clearSearchCondition" class="clear-button"><spring:message code="label.${screenId?lower_case}.list.button.clearsearchcondition" /></button>');

        $(table.table().container()).on('keyup', 'input.column_filter',
          function() {
            // TODO 固定した全ての列に対して、同様に検索テキストボックスの値を退避する（colXX_FilterのXXを修正して下さい）
            // if (this.id == 'col2_filter') {
            //   $('input#col2_filter').val($(this).val());
            // }
            // if (this.id == 'col3_filter') {
            //   $('input#col3_filter').val($(this).val());
            // }

            filterColumn(table, this);
          });

        $('#search').on('click',
          function() {
            this.blur();
            table.ajax.url(getSearchURL()).load(null, false);
          });

        $('#clearSearchCondition').on('click',
          function() {
            this.blur();
            clearSearchConditon(table);
          });

        $('#create').on('click',
          function() {
            this.blur();
            openNewWindowByName('${r"${f:h(pageContext.request.contextPath)}"}/production/${screenId?lower_case}/create?form', '${r"${f:h(pageContext.request.contextPath)}"}/production/${screenId?lower_case}/create?form');
          });

        $('#deleteBatch').on('click',
          function() {
            setSelectKey(table, 0, '#selectAlternateKey');
            submitEditAction('#${screenId}SearchCriteriaForm',
                             '${r"${pageContext.request.contextPath"}${r"}"}/production/${screenId?lower_case}/list?deletebatch');
          });

        $('#saveBatch').on('click',
          function() {
            setSelectKeyProvisional(table, 0, '#selectAlternateKey');
            submitEditAction('#${screenId}SearchCriteriaForm',
                             '${r"${pageContext.request.contextPath"}${r"}"}/production/${screenId?lower_case}/list?savebatch');
          });

        $('#importCsv').on('click',
          function() {
            this.blur();
            openNewWindowByName('${r"${f:h(pageContext.request.contextPath)}"}/production/${screenId?lower_case}/import?form',
                                '${r"${f:h(pageContext.request.contextPath)}"}/production/${screenId?lower_case}/import?form');
          });

        $('#exportCsv').on('click',
          function() {
            setSelectKey(table, 0, '#selectAlternateKey');
            submitEditAction('#${screenId}SearchCriteriaForm',
                             '${r"${pageContext.request.contextPath"}${r"}"}/production/${screenId?lower_case}/list?export');
          });

        // TODO 必要なければ削除
        // date picker
<#list records as record>
  <#if record.itemName??>
    <#if record.inputItemForList??>
      <#switch record.type>
        <#case "java.time.LocalDateTime">
        datepicker('#${record.itemName}');
          <#break>
        <#case "java.time.LocalDate">
        datepicker('#${record.itemName}');
          <#break>
        <#default>
          <#break>
      </#switch>
    </#if>
  </#if>
</#list>

        // TODO 必要なければ削除
        // select2
<#list records as record>
  <#if record.itemName??>
    <#if record.inputItemForList??>
      <#switch record.itemType>
        <#case "select">
        select2Placeholder('#${record.itemName}', '<spring:message code="placeholder.${screenId?lower_case}.list.searchcondition.${record.itemName?lower_case}"/>');
          <#break>
        <#default>
          <#break>
      </#switch>
    </#if>
  </#if>
</#list>

        // TODO 必要なければ削除
        // input-mask
<#list records as record>
  <#if record.itemName??>
    <#if record.inputItemForList??>
      <#switch record.type>
        <#case "java.lang.Short">
        <#case "java.lang.Integer">
        <#case "java.lang.Long">
        <#case "java.math.BigDecimal">
        numericCommaEditing('#${record.itemName}');
          <#break>
        <#default>
          <#break>
      </#switch>
    </#if>
  </#if>
</#list>

        // 他部門モード、参照モード、編集モード、管理者モードの設定
        function settingViewMode() {
          // TODO 機能毎に必要な case のみにする
          // TODO 権限が強い順に記述し、default で最も弱い権限を実装する
          switch (viewMode) {
            case VIEW_MODE_ADMIN :
              // 管理者モード
              // TODO 機能毎に実装

              break;
            case VIEW_MODE_EDIT :
              // 編集モード
              // TODO 機能毎に実装
              // setHiddenAdminOnlyItems();

              break;
            case VIEW_MODE_REFERENCE :
              // 参照モード
              // TODO 機能毎に実装
              // setReadOnlyInputItems();
              // setDisabledInputItems();
              // setHiddenItems();
              // setHiddenAdminOnlyItems();

              break;
            default : 
              // 他部門モード
              // TODO 機能毎に実装
              // setReadOnlyInputItems();
              // setDisabledInputItems();
              // setHiddenItems();
              // setHiddenAdminOnlyItems();

              break;
          }
        }

        settingViewMode();
      });
</script>
