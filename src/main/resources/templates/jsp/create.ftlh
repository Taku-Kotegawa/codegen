<section class="content-header">
  <div class="container">
    <div class="row mb-2">
      <div class="col-18">
        <!-- ページタイトルを記入 -->
        <h4>${screenName}編集</h4>
      </div>
      <div class="col-18">
        <!-- ページタイトル右の余白 -->
      </div>
    </div>
  </div>
</section>
<section class="content">
  <div class="container">
    <t:messagesPanel panelClassName="callout" panelTypeClassPrefix="callout-" disableHtmlEscape="true" />
    <!-- ここより下にメインコンテンツを記入 -->

    <!-- １．フォームタグで囲む -->
    <form:form modelAttribute="${screenId?lower_case}Form" enctype="multipart/form-data" autocomplete="off">
      <!-- EnterキーによるPOSTを無効化 -->
      <input type="submit" disabled style="display:none" />

      <!-- 必要に応じて隠しフィールドを追加する -->

      <!-- 操作ボタンを追加(メインコンテンツの中に追加する様に) -->
      <div class="row operation-button-block">

        <!-- 右寄せに配置 -->
        <div class="col-12">

          <c:set var="id" value="${r"${"}${screenId?lower_case}.id}" />

          <!-- 一覧に戻る -->
          <c:if test="${r"${"}buttonState.gotoList__view}">
            <a id="gotoList" href="${r"${"}pageContext.request.contextPath}${r"${"}op.getListUrl()}" class="btn btn-button mr-2"
              <c:if test="${r"${"}buttonState.gotoList__disabled}">disabled</c:if>>${r"${"}op.getLABEL_LIST()}</a>
          </c:if>

          <!-- 参照 -->
          <c:if test="${r"${"}buttonState.view__view}">
            <a id="view" href="${r"${"}pageContext.request.contextPath}${r"${"}op.getViewUrl(id)}" class="btn btn-button mr-2" <c:if
              test="${r"${"}buttonState.view__disabled}">disabled</c:if> >${r"${"}op.getLABEL_VIEW()}</a>
          </c:if>

          <!-- 編集 -->
          <c:if test="${r"${"}buttonState.gotoUpdate__view}">
            <a id="gotoUpdate" href="${r"${"}pageContext.request.contextPath}${r"${"}op.getEditUrl(id)}" class="btn btn-button mr-2"
              <c:if test="${r"${"}buttonState.gotoUpdate__disabled}">disabled</c:if>>${r"${"}op.getLABEL_EDIT()}</a>
          </c:if>

          <!-- 下書き保存 -->
          <c:if test="${r"${"}buttonState.saveDraft__view}">
            <button id="saveDraft" name="saveDraft" value="true" type="submit" class="btn btn-button mr-2" <c:if
              test="${r"${"}buttonState.saveDraft__disabled}">disabled</c:if>>${r"${"}op.getLABEL_SAVE_DRAFT()}</button>
          </c:if>

          <!-- 下書き取消 -->
          <c:if test="${r"${"}buttonState.cancelDraft__view}">
            <a id="cancelDraft" href="${r"${"}pageContext.request.contextPath}${r"${"}op.getCancelDraftUrl(id)}"
              class="btn btn-button mr-2" <c:if test="${r"${"}buttonState.cancelDraft__disabled}">disabled</c:if>
          >${r"${"}op.getLABEL_CANCEL_DRAFT()}</a>
          </c:if>

          <!-- 保存 -->
          <c:if test="${r"${"}buttonState.save__view}">
            <button id="save" name="save" type="submit" class="btn btn-button mr-2" <c:if
              test="${r"${"}buttonState.save__disabled}">disabled</c:if>>保存</button>
          </c:if>

          <!-- 無効 -->
          <c:if test="${r"${"}buttonState.invalid__view}">
            <a id="delete" href="${r"${"}pageContext.request.contextPath}${r"${"}op.getInvalidUrl(id)}" class="btn btn-button mr-2"
              <c:if test="${r"${"}buttonState.invalid__disabled}">disabled</c:if> >${r"${"}op.getLABEL_INVALID()}</a>
          </c:if>

          <!-- 無効解除 -->
          <c:if test="${r"${"}buttonState.valid__view}">
            <a id="delete" href="${r"${"}pageContext.request.contextPath}${r"${"}op.getValidUrl(id)}" class="btn btn-button mr-2"
              <c:if test="${r"${"}buttonState.valid__disabled}">disabled</c:if> >${r"${"}op.getLABEL_VALID()}</a>
          </c:if>

          <!-- 削除 -->
          <c:if test="${r"${"}buttonState.delete__view}">
            <a id="delete" href="${r"${"}pageContext.request.contextPath}${r"${"}op.getDeleteUrl(id)}" class="btn btn-button mr-2"
              <c:if test="${r"${"}buttonState.delete__disabled}">disabled</c:if> >${r"${"}op.getLABEL_DELETE()}</a>
          </c:if>

        </div>
      </div>

      <hr />

<#list records as record>
  <#if record.itemName?? && record.type?? && record.inputItemForCreate??>
    <#-- ${record.type} ${record.itemType} ${record.itemName} ${record.itemNameJa} -->
    <#switch record.itemType>
    <#case "label">
          <c:if test="${r"${"}fieldState.${record.itemName}__view}">
            <div class="row mb-3">
              <div class="col-11 ">
                <!-- ラベル -->
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
                <div class="form-control__view">
                  ${r"${"}f:h(CL_STATUS[${screenId?lower_case}.${record.itemName}])}
                </div>
              </div>
            </div>
          </c:if>
      <#break>
    <#case "text">
      <#switch record.type>
        <#case "java.time.LocalDateTime">
          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <div class="input-group datetime" id="${record.itemName}-input-group" data-target-input="nearest">
                  <form:input path="${record.itemName}" cssClass="form-control datetimepicker-input"
                    cssErrorClass="form-control datetimepicker-input is-invalid"
                    data-target="#${record.itemName}-input-group" />
                  <div class="input-group-append" data-target="#${record.itemName}-input-group" data-toggle="datetimepicker">
                    <div class="input-group-text"><i class="fa fa-calendar fa-fw"></i></div>
                  </div>
                </div>
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="form-control form-control__view">
                  ${r"${"}f:h(${screenId?lower_case}.${record.itemName}.format(DateTimeFormatter.ofPattern("yyyy/MM/dd hh:mm")))}
                </div>
              </c:if>
            </div>
          </div>
          <#break>

        <#case "java.time.LocalDate">
          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <div class="input-group" id="${record.itemName}-input-group" data-target-input="nearest">
                  <form:input path="${record.itemName}" cssClass="form-control datetimepicker-input"
                    cssErrorClass="form-control datetimepicker-input is-invalid" data-target="#${record.itemName}-input-group" />
                  <div class="input-group-append" data-target="#${record.itemName}-input-group" data-toggle="datetimepicker">
                    <div class="input-group-text"><i class="fa fa-calendar fa-fw"></i></div>
                  </div>
                </div>
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="form-control form-control__view">
                  ${r"${"}f:h(${screenId?lower_case}.${record.itemName}.format(DateTimeFormatter.ofPattern("yyyy/MM/dd")))}
                </div>
              </c:if>
            </div>
          </div>

        <#default>
          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <form:input path="${record.itemName}" cssClass="form-control" cssErrorClass="form-control is-invalid"
                  disabled="${r"${"}fieldState.${record.itemName}__disabled}" readonly="${r"${"}fieldState.${record.itemName}__readonly}" />
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="form-control form-control__view">
                  ${r"${"}f:h(${screenId?lower_case}.${record.itemName})}
                </div>
              </c:if>
            </div>
          </div>
         <#break>
      </#switch>

      <#break>
    <#case "text(combobox)">

          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <div class="dropdown input-group">
                  <form:input path="${record.itemName}" cssClass="form-control" cssErrorClass="form-control is-invalid" />
                  <div class="input-group-append" data-toggle="dropdown">
                    <div class="input-group-text"><i class="fas fa-angle-down"></i></div>
                  </div>
                  <ul class="dropdown-menu dropdown-menu-right combobox" aria-labelledby="dropdownMenuButton">
                    <input class="form-control" id="myInput" type="text" placeholder="Filter..">
                    <c:forEach var="item" items="${r"${"}CL_STATUS}" varStatus="status">
                      <li class="autocomplete" data-autocomplete="${r"${"}item.value}" data-target="${record.itemName}">${r"${"}item.value}
                      </li>
                    </c:forEach>
                  </ul>
                </div>
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="form-control form-control__view">
                  ${r"${"}f:h(${screenId?lower_case}.${record.itemName})}
                </div>
              </c:if>
            </div>
          </div>


      <#break>
    <#case "textarea">

          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <form:textarea path="${record.itemName}" cssClass="form-control" cssErrorClass="form-control is-invalid"
                  rows="5" />
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="">
                  ${r"${"}f:br(f:h(${screenId?lower_case}.${record.itemName}))}
                </div>
              </c:if>
            </div>
          </div>


      <#break>
    <#case "password">





      <#break>
    <#case "select">

          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <form:select path="${record.itemName}" cssClass="form-control" cssErrorClass="form-control is-invalid">
                  <form:option value="" label="--Select--" />
                  <form:options items="${r"${"}CL_STATUS}" />
                </form:select>
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="form-control form-control__view">
                  ${r"${"}f:h(CL_STATUS[${screenId?lower_case}.${record.itemName}])}
                </div>
              </c:if>
            </div>
          </div>

      <#break>
    <#case "select(multiple)">

          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <form:select path="${record.itemName}" multiple="true" cssClass="form-control"
                  cssErrorClass="form-control is-invalid">
                  <form:option value="" label="--Select--" />
                  <form:options items="${r"${"}CL_STATUS}" />
                </form:select>
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="form-control form-control__view">
                  <c:forEach var="item" items="${r"${"}${screenId?lower_case}.${record.itemName}}" varStatus="status">
                    <span>${r"${"}f:h(CL_STATUS[item])}<c:if test="${r"${"}!status.last}">,</c:if></span>
                  </c:forEach>
                </div>
              </c:if>
            </div>
          </div>

      <#break>
    <#case "checkbox">

          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <div class="form-check-inline" style="width:100%">
                  <form:checkbox path="${record.itemName}" cssClass="" cssErrorClass="is-invalid" value="yes" />
                  <form:label path="${record.itemName}" for="${record.itemName}1">利用規約に合意する</form:label>
                </div>
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="form-control form-control__view">
                  <c:if test="${r"${"}${screenId?lower_case}.${record.itemName} == 'yes'}">[レ]</c:if>
                  <c:if test="${r"${"}${screenId?lower_case}.${record.itemName} != 'yes'}">[　]</c:if>
                  利用規約に合意する
                </div>
              </c:if>
            </div>
          </div>


      <#break>
    <#case "checkbox(multiple)">

          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <div class="form-check-inline" style="width:100%">
                  <form:checkboxes path="${record.itemName}" cssClass="" cssErrorClass="is-invalid" items="${r"${"}CL_STATUS}" />
                </div>
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="form-control form-control__view">
                  <!-- <c:forEach var="item" items="${r"${"}${screenId?lower_case}.${record.itemName}}" varStatus="status">
                <span>${r"${"}f:h(CL_STATUS[item])}<c:if test="${r"${"}!status.last}">,</c:if></span>
              </c:forEach> -->
                  <c:forEach var="item" items="${r"${"}CL_STATUS}" varStatus="status">
                    <span>
                      <c:if test="${r"${"}${screenId?lower_case}.${record.itemName}.contains(item.key)}">[レ]</c:if>
                      <c:if test="${r"${"}!${screenId?lower_case}.${record.itemName}.contains(item.key)}">[　]</c:if>
                      ${r"${"}item.value}
                    </span>
                  </c:forEach>
                </div>
              </c:if>
            </div>
          </div>

      <#break>
    <#case "radiobutton">

          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <div class="form-check-inline" style="width:100%">
                  <form:radiobutton path="${record.itemName}" cssClass="" cssErrorClass="is-invalid" value="true" />
                  <form:label path="${record.itemName}" for="${record.itemName}1">はい</form:label>
                  <form:radiobutton path="${record.itemName}" cssClass="" cssErrorClass="is-invalid" value="false" />
                  <form:label path="${record.itemName}" for="${record.itemName}2">いいえ</form:label>
                </div>
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
              </c:if>
              <!-- 隠しフィールド-->
              <c:if test="${r"${"}fieldState.${record.itemName}__hidden}">
                <form:hidden path="${record.itemName}" />
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}__view}">
                <div class="form-control form-control__view">
                  <c:if test="${r"${"}${screenId?lower_case}.${record.itemName}}">[◯]はい [　]いいえ</c:if>
                  <c:if test="${r"${"}!${screenId?lower_case}.${record.itemName}}">[　]はい [◯]いいえ</c:if>
                </div>
              </c:if>
            </div>
          </div>
      <#break>
    <#case "hidden">
        <form:hidden path="${record.itemName}" />
      <#break>
    <#case "file">
          <div class="row mb-3">
            <div class="col-12">
              <!-- ラベル -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input || fieldState.${record.itemName}__view}">
                <form:label path="${record.itemName}">${record.itemNameJa}</form:label>
              </c:if>
              <!-- 入力 -->
              <c:if test="${r"${"}fieldState.${record.itemName}__input}">
                <input id="${record.itemName?replace('Uuid', '')}" type="file" class="form-control form-control-file file-managed"
                  data-file-type="${screenId?lower_case}" data-extention-pattern="png jpg gif" <c:if
                  test="${r"${"}${screenId?lower_case}Form.${record.itemName} != null}">style="display: none;"</c:if> />
                <form:errors path="${record.itemName}" cssClass="invalid-feedback" />
                <c:if test="${r"${"}${screenId?lower_case}Form.${record.itemName?replace('Uuid', 'Managed')} != null}">
                  <div id="${record.itemName?replace('Uuid', '')}__attached-block" class="input-group">
                    <span>
                      <i class="far fa-file ml-2"></i>
                      <a href="${r"${"}pageContext.request.contextPath}${r"${"}op.getDownloadUrl(${screenId?lower_case}Form.${record.itemName})}"
                        target="_blank"
                        class="link-attached">${r"${"}${screenId?lower_case}Form.${record.itemName?replace('Uuid', 'Managed')}.originalFilename}</a>
                      <c:if test="${r"${"}fieldState.${record.itemName}__input && !fieldState.${record.itemName}__readonly}">
                        <i class="far fa-trash-alt" style="color: brown;" onclick="file_detach('${record.itemName?replace('Uuid', '')}')"></i>
                      </c:if>
                      <form:input type="hidden" path="${record.itemName}" />
                    </span>
                  </div>
                </c:if>
              </c:if>
              <!-- 参照用-->
              <c:if test="${r"${"}fieldState.${record.itemName}Uuid__view}">
                <div>
                  <c:if test="${r"${"}${screenId?lower_case}.${record.itemName?replace('Uuid', 'Managed')} != null}">
                    <span>
                      <i class="far fa-file ml-2"></i>
                      <a href="${r"${"}pageContext.request.contextPath}${r"${"}op.getDownloadUrl(${screenId?lower_case}.${record.itemName?replace('Uuid', 'Managed')}.uuid)}"
                        target="_blank" class="link-attached">${r"${"}${screenId?lower_case}.${record.itemName?replace('Uuid', 'Managed')}.originalFilename}</a>
                    </span>
                  </c:if>
                </div>
              </c:if>
            </div>
          </div>

      <#break>
    <#default>
      <#break>
    </#switch>

  </#if>
</#list>

    </form:form>

    <br>
    <br>

    <!-- ここより上にメインコンテンツを記入 -->
  </div>
</section>
<script src="${pageContext.request.contextPath}/resources/app/js/form-onload-default.js"></script>
