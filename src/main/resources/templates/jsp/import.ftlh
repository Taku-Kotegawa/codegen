<div class="content-wrapper">
  <div class="container">
    <section class="content-header">
      <h1>
        <spring:message code="label.${screenId?lower_case}.importform" />
      </h1>
    </section>
    <section class="content">
      <stn:messagepanel type="error" messages="${r"${errorMessages"}${r"}"}"/>
      <stn:messagepanel type="warning" messages="${r"${warningMessages"}${r"}"}" />
      <stn:messagepanel type="success" messages="${r"${successMessages"}${r"}"}"/>
      <form:form
        action="${r"${f:h(pageContext.request.contextPath)}"}/production/${screenId?lower_case}/import"
        method="POST" modelAttribute="${screenId}ImportForm" enctype="multipart/form-data">
        <div class="box box-solid box-primary">
          <div class="box-header with-border">
            <h3 class="box-title">
              <spring:message code="label.${screenId?lower_case}.importform.boxtitle" />
            </h3>
            <!-- /.box-title -->
          </div>
          <!-- /.box-header -->
          <div class="box-body">
            <div class="row">
<#list records as record>
  <#if record.itemName??>
    <#if record.inputItemForImport??>
      <#switch record.itemType>
        <#case "label">
              <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                readonly="true" />
          <#break>
        <#case "text">
              <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                placeholderLabel="placeholder.${screenId?lower_case}.importform.${record.itemName?lower_case}"
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
          <#if record.require??>
                required="true"
          </#if>
                />
          <#break>
        <#case "text(combobox)">
              <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                placeholderLabel="placeholder.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                items="${r"${items"}${record.groupName?cap_first}${r"}"}"
          <#if record.require??>
                required="true"
          </#if>
                />
          <#break>
        <#case "textarea">
              <stn:textarea path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21" rows="5"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                placeholderLabel="placeholder.${screenId?lower_case}.importform.${record.itemName?lower_case}"
          <#if record.require??>
                required="true"
          </#if>
                />
          <#break>
        <#case "password">
              <stn:password path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                placeholderLabel="placeholder.${screenId?lower_case}.importform.${record.itemName?lower_case}"
          <#if record.require??>
                required="true"
          </#if>
                />
          <#break>
        <#case "select">
              <stn:select path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                items="${r"${items"}${record.groupName?cap_first}${r"}"}" multiple="false"
          <#if record.require??>
                required="true"
          </#if>
                >
              </stn:select>
          <#break>
        <#case "checkbox">
              <stn:checkboxes path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                items="${r"${items"}${record.groupName?cap_first}${r"}"}"
          <#if record.require??>
                required="true"
          </#if>
                />
          <#break>
        <#case "radiobutton">
              <stn:radiobuttons path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                items="${r"${items"}${record.groupName?cap_first}${r"}"}"
          <#if record.require??>
                required="true"
          </#if>
                />
          <#break>
        <#case "hidden">
              <form:hidden path="${record.itemName}" />
          <#break>
        <#case "file">
              <stn:file path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
          <#if record.require??>
                required="true"
          </#if>
              />
          <#break>
        <#default>
          <#break>
      </#switch>
    <#elseif record.useItemForImport??>
      <#switch record.itemType>
        <#case "label">
              <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                readonly="true" />
          <#break>
        <#case "text">
              <stn:input path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                placeholderLabel="placeholder.${screenId?lower_case}.importform.${record.itemName?lower_case}"
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
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                placeholderLabel="placeholder.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                items="${r"${items"}${record.groupName?cap_first}${r"}"}" readonly="true" />
          <#break>
        <#case "textarea">
              <stn:textarea path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21" rows="5"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                placeholderLabel="placeholder.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                readonly="true" />
          <#break>
        <#case "password">
              <stn:password path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                placeholderLabel="placeholder.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                readonly="true" />
          <#break>
        <#case "select">
              <stn:select path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                items="${r"${items"}${record.groupName?cap_first}${r"}"}" multiple="false" disabled="true" >
              </stn:select>
          <#break>
        <#case "checkbox">
              <stn:checkboxes path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                items="${r"${items"}${record.groupName?cap_first}${r"}"}" disabled="true" />
          <#break>
        <#case "radiobutton">
              <stn:radiobuttons path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
                items="${r"${items"}${record.groupName?cap_first}${r"}"}" disabled="true" />
          <#break>
        <#case "hidden">
              <form:hidden path="${record.itemName}" />
          <#break>
        <#case "file">
              <stn:file path="${record.itemName}" addDivClass="col-md-12" addLabelClass="col-md-15 text-right" addFormClass="col-md-21"
                titleLabel="label.${screenId?lower_case}.importform.${record.itemName?lower_case}"
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
            <div class="modal fade" id="modal-confirm">
              <div class="modal-dialog">
                <div class="modal-content">
                  <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                    <h4 class="modal-title">
                      <spring:message code="label.${screenId?lower_case}.importform.confirmdialog.title" />
                    </h4>
                  </div>
                  <div class="modal-body">
                    <p><spring:message code="label.${screenId?lower_case}.importform.confirmdialog.label" /></p>
                  </div>
                  <div class="modal-footer">
                    <button type="submit" class="btn btn-warning btn-inverse">
                      <i class="fa fa-upload fa-fw"></i>
                      <spring:message code="label.${screenId?lower_case}.importform.confirmdialog.button.importcsv" />
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
                  <spring:message code="label.${screenId?lower_case}.importform.button.close" />
                </button>
              </div>
              <div class="col-md-18 text-right">
                <a class="btn btn-warning btn-inverse" data-toggle="modal" data-target="#modal-confirm" id="confirm">
                  <i class="fa fa-upload fa-fw"></i>
                  <spring:message code="label.${screenId?lower_case}.importform.button.importcsv" />
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
        // TODO 必要なければ削除
        // date picker
<#list records as record>
  <#if record.itemName??>
    <#if record.inputItemForImport??>
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
    <#if record.inputItemForImport?? || record.useItemForImport??>
      <#switch record.itemType>
        <#case "select">
        select2Placeholder('#${record.itemName}', '<spring:message code="placeholder.${screenId?lower_case}.importform.${record.itemName?lower_case}"/>');
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
    <#if record.inputItemForImport??>
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
      });
</script>