<div class="content-wrapper">
  <div class="container">
  <section class="content-header">
    <h1>
      <spring:message code="label.${screenId?lower_case}.updateform" />
    </h1>
  </section>
  <section class="content">
    <stn:messagepanel type="error" messages="${r"${errorMessages"}${r"}"}" />
    <stn:messagepanel type="warning" messages="${r"${warningMessages"}${r"}"}" />
    <stn:messagepanel type="success" messages="${r"${successMessages"}${r"}"}" />
    <form:form modelAttribute="${screenId}UpdateForm"
      action="" method="POST">
      <div class="box box-solid box-primary">
        <div class="box-header with-border">
          <h3 class="box-title">
            <spring:message code="label.${screenId?lower_case}.updateform.boxtitle" />
          </h3>
          <!-- /.box-title -->
        </div>
        <!-- /.box-header -->
        <div class="box-body">
          <div class="row">
<#list records as record>
  <#if record.itemName??>
    <#if record.inputItemForUpdate??>
      <#switch record.itemType>
        <#case "label">
            <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              readonly="true" />
          <#break>
        <#case "text">
            <stn:input path="${record.itemName}" addDivClass="col-md-12 bkn_view_readonly" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
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
            <stn:input path="${record.itemName}" addDivClass="col-md-12 bkn_view_readonly" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" />
          <#break>
        <#case "textarea">
            <stn:textarea path="${record.itemName}" addDivClass="col-md-12 bkn_view_readonly" addLabelClass="col-md-15 text-right" addFormClass="col-md-21" rows="5"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              />
          <#break>
        <#case "password">
            <stn:password path="${record.itemName}" addDivClass="col-md-12 bkn_view_readonly" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              />
          <#break>
        <#case "select">
            <stn:select path="${record.itemName}" addDivClass="col-md-12 bkn_view_disabled" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" multiple="false">
            </stn:select>
          <#break>
        <#case "checkbox">
            <stn:checkboxes path="${record.itemName}" addDivClass="col-md-12 bkn_view_disabled" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}" 
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" />
          <#break>
        <#case "radiobutton">
            <stn:radiobuttons path="${record.itemName}" addDivClass="col-md-12 bkn_view_disabled" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}" 
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" />
          <#break>
        <#case "hidden">
            <form:hidden path="${record.itemName}" />
          <#break>
        <#case "file">
            <stn:file path="${record.itemName}" addDivClass="col-md-12 bkn_view_readonly" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
            />
          <#break>
        <#default>
          <#break>
      </#switch>
    <#elseif record.useItemForUpdate??>
      <#switch record.itemType>
        <#case "label">
            <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              readonly="true" />
          <#break>
        <#case "text">
            <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
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
              readonly="true" />
          <#break>
        <#case "text(combobox)">
            <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" readonly="true" />
          <#break>
        <#case "textarea">
            <stn:textarea path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21" rows="5"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              readonly="true" />
          <#break>
        <#case "password">
            <stn:password path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              placeholderLabel="placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              readonly="true" />
          <#break>
        <#case "select">
            <stn:select path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" multiple="false" disabled="true" >
            </stn:select>
          <#break>
        <#case "checkbox">
            <stn:checkboxes path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}" 
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" disabled="true" />
          <#break>
        <#case "radiobutton">
            <stn:radiobuttons path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}" 
              items="${r"${items"}${record.groupName?cap_first}${r"}"}" disabled="true" />
          <#break>
        <#case "hidden">
            <form:hidden path="${record.itemName}" />
          <#break>
        <#case "file">
            <stn:file path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
              titleLabel="label.${screenId?lower_case}.updateform.${record.itemName?lower_case}"
              readonly="true" />
          <#break>
        <#default>
          <#break>
      </#switch>
    <#elseif record.key??>
            <form:hidden path="${record.itemName}" />
    </#if>
  </#if>
</#list>
          </div>

          <!-- modal dialog -->
          <div class="modal fade" id="modal-confirm-delete">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                  <h4 class="modal-title">
                    <spring:message code="label.${screenId?lower_case}.updateform.delete.confirmdialog.title" />
                  </h4>
                </div>
                <div class="modal-body">
                  <p><spring:message code="label.${screenId?lower_case}.updateform.delete.confirmdialog.label" /></p>
                </div>
                <div class="modal-footer">
                  <button type="button" id="delete" class="btn btn-danger btn-inverse">
                    <i class="fa fa-close fa-fw"></i>
                    <spring:message code="label.${screenId?lower_case}.updateform.delete.confirmdialog.button.delete" />
                  </button>
                </div>
              </div>
            </div>
          </div>
          <!-- /.modal dialog -->
          <!-- modal dialog -->
          <div class="modal fade" id="modal-confirm-update">
            <div class="modal-dialog">
              <div class="modal-content">
                <div class="modal-header">
                  <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                  </button>
                  <h4 class="modal-title">
                    <spring:message code="label.${screenId?lower_case}.updateform.update.confirmdialog.title" />
                  </h4>
                </div>
                <div class="modal-body">
                  <p><spring:message code="label.${screenId?lower_case}.updateform.update.confirmdialog.label" /></p>
                </div>
                <div class="modal-footer">
                  <button type="button" id="update" class="btn btn-warning btn-inverse">
                    <i class="fa fa-save fa-fw"></i>
                    <spring:message code="label.${screenId?lower_case}.updateform.update.confirmdialog.button.update" />
                  </button>
                </div>
              </div>
            </div>
          </div>
          <!-- /.modal dialog -->
        </div>
        <!-- /.box-body -->
        <div class="box-footer">
          <div class="row">
            <div class="col-md-18 text-left">
                <button type="button" id="close" class="btn btn-default btn-inverse">
                  <i class="fa fa-reply fa-fw"></i>
                  <spring:message code="label.${screenId?lower_case}.updateform.button.close" />
                </button>
            </div>
            <div class="col-md-18 text-right">
              <a id="confirm-delete" class="btn btn-danger btn-inverse bkn_view_hidden"
                data-toggle="modal" data-target="#modal-confirm-delete">
                <i class="fa fa-close fa-fw"></i>
                <spring:message code="label.${screenId?lower_case}.updateform.button.delete" />
              </a>
              <a id="confirm-update" class="btn btn-warning btn-inverse bkn_view_hidden"
                data-toggle="modal" data-target="#modal-confirm-update">
                <i class="fa fa-save fa-fw"></i>
                <spring:message code="label.${screenId?lower_case}.updateform.button.update" />
              </a>
            </div>
          </div>
        </div>
        <!-- /.box-footer -->
      </div>
      <!-- /.box -->
    </form:form>
  </section>
</div>
</div>

<!-- page script -->
<script>
  $(document)
    .ready(
      function() {
        var viewMode = getViewMode('${r"${viewMode"}${r"}"}');

        // TODO 必要なければ削除
        // date picker
<#list records as record>
  <#if record.itemName??>
    <#if record.inputItemForUpdate?? >
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
    <#if record.inputItemForUpdate?? || record.useItemForUpdate??>
      <#switch record.itemType>
        <#case "select">
        select2Placeholder('#${record.itemName}', '<spring:message code="placeholder.${screenId?lower_case}.updateform.${record.itemName?lower_case}"/>');
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
    <#if record.inputItemForUpdate??>
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

        $('#close').on('click',
          function() {
            closeOwnWindow();
          });

        $('#delete').on('click',
          function() {
            submitEditAction('#${screenId}UpdateForm',
            '${r"${pageContext.request.contextPath"}${r"}"}/production/${screenId?lower_case}/edit/${updateUrlId}/delete');
          });

        $('#update').on('click',
          function() {
            submitEditAction('#${screenId}UpdateForm',
            '${r"${pageContext.request.contextPath"}${r"}"}/production/${screenId?lower_case}/edit/${updateUrlId}/update');
          });

        // submit 前処理
        $('#${screenId}UpdateForm').submit(function() {
          // 全ての入力項目の disabled を解除してから submit する
          removeDisabledAllInputItems();
        });

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
            default : 
              // 参照モード（他部門モードは編集画面を表示できない）
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