package jp.co.stnet.cms.app.${screenId?lower_case};

import com.github.dozermapper.core.Mapper;
import com.orangesignal.csv.CsvConfig;
import jp.co.stnet.cms.domain.common.Constants;
import jp.co.stnet.cms.domain.common.StateMap;
import jp.co.stnet.cms.domain.common.datatables.DataTablesInputDraft;
import jp.co.stnet.cms.domain.common.datatables.DataTablesOutput;
import jp.co.stnet.cms.domain.common.datatables.OperationsUtil;
import jp.co.stnet.cms.domain.common.message.MessageKeys;
import jp.co.stnet.cms.domain.common.scheduled.CsvUtils;
import jp.co.stnet.cms.domain.model.authentication.LoggedInUser;
import jp.co.stnet.cms.domain.model.common.Status;
import jp.co.stnet.cms.domain.model.example.${screenId?cap_first};
import jp.co.stnet.cms.domain.model.example.${screenId?cap_first}Revision;
import jp.co.stnet.cms.domain.service.common.FileManagedSharedService;
import jp.co.stnet.cms.domain.service.example.${screenId?cap_first}Service;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.terasoluna.gfw.common.codelist.CodeList;
import org.terasoluna.gfw.common.exception.BusinessException;
import org.terasoluna.gfw.common.message.ResultMessages;
import org.terasoluna.gfw.web.token.transaction.TransactionTokenCheck;
import org.terasoluna.gfw.web.token.transaction.TransactionTokenType;

import javax.inject.Named;
import javax.validation.groups.Default;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Controller
@RequestMapping("${screenId?lower_case}")
@TransactionTokenCheck("${screenId?lower_case}")
public class ${screenId?cap_first}Controller {

    private final String BASE_PATH = "${screenId?lower_case}";
    private final String JSP_LIST = BASE_PATH + "/list";
    private final String JSP_FORM = BASE_PATH + "/form";
    private final String JSP_VIEW = BASE_PATH + "/view";

    @Autowired
    ${screenId?cap_first}Service ${screenId}Service;

    @Autowired
    FileManagedSharedService fileManagedSharedService;

    @Autowired
    @Named("CL_STATUS")
    CodeList statusCodeList;

    @Autowired
    Mapper beanMapper;

    @ModelAttribute
    private ${screenId?cap_first}Form setUp() {
        return new ${screenId?cap_first}Form();
    }

    /**
     * 一覧画面の表示
     */
    @GetMapping(value = "list")
    public String list(Model model) {
        return JSP_LIST;
    }

    /**
     * DataTables用のJSONの作成
     *
     * @param input DataTablesから要求
     * @return JSON
     */
    @ResponseBody
    @GetMapping(value = "/list/json")
    public DataTablesOutput<${screenId?cap_first}ListRow> listJson(@Validated DataTablesInputDraft input) {

        OperationsUtil op = new OperationsUtil(null);

        List<${screenId?cap_first}ListRow> list = new ArrayList<>();
        List<${screenId?cap_first}> ${screenId}List = new ArrayList<>();
        Long recordsFiltered = 0L;


        if (input.getDraft()) { // 下書き含む最新
            Page<${screenId?cap_first}> ${screenId}Page = ${screenId}Service.findPageByInput(input);
            ${screenId}List.addAll(${screenId}Page.getContent());
            recordsFiltered = ${screenId}Page.getTotalElements();

        } else {
            Page<${screenId?cap_first}Revision> ${screenId}Page2 = ${screenId}Service.findMaxRevPageByInput(input);
            for (${screenId?cap_first}Revision ${screenId}Revision : ${screenId}Page2.getContent()) {
                ${screenId}List.add(beanMapper.map(${screenId}Revision, ${screenId?cap_first}.class));
            }
            recordsFiltered = ${screenId}Page2.getTotalElements();
        }

        for (${screenId?cap_first} ${screenId} : ${screenId}List) {
            ${screenId?cap_first}ListRow ${screenId}ListRow = beanMapper.map(${screenId}, ${screenId?cap_first}ListRow.class);
            ${screenId}ListRow.setOperations(getToggleButton(${screenId}.getId().toString(), op));
            ${screenId}ListRow.setDT_RowId(${screenId}.getId().toString());

            // ステータスラベル
            ${screenId}ListRow.setStatusLabel(Status.getByValue(${screenId}.getStatus()).getCodeLabel());

            list.add(${screenId}ListRow);
        }

        DataTablesOutput<${screenId?cap_first}ListRow> output = new DataTablesOutput<>();
        output.setData(list);
        output.setDraw(input.getDraw());
        output.setRecordsTotal(0);
        output.setRecordsFiltered(recordsFiltered);

        return output;
    }

    @GetMapping(value = "/list/csv")
    public String listCsv(@Validated DataTablesInputDraft input, Model model) {
        setModelForCsv(input, model);
        model.addAttribute("csvConfig", CsvUtils.getCsvDefault());
        model.addAttribute("csvFileName", "${screenId?cap_first}.csv");
        return "csvDownloadView";
    }

    @GetMapping(value = "/list/tsv")
    public String listTsv(@Validated DataTablesInputDraft input, Model model) {
        setModelForCsv(input, model);
        model.addAttribute("csvConfig", CsvUtils.getTsvDefault());
        model.addAttribute("csvFileName", "${screenId?cap_first}.tsv");
        return "csvDownloadView";
    }

    private void setModelForCsv(DataTablesInputDraft input, Model model) {
        input.setStart(0);
        input.setLength(Constants.CSV.MAX_LENGTH);

        List<${screenId?cap_first}CsvBean> list = new ArrayList<>();
        List<${screenId?cap_first}> ${screenId}List = new ArrayList<>();

        if (input.getDraft()) { // 下書き含む最新
            Page<${screenId?cap_first}> ${screenId}Page = ${screenId}Service.findPageByInput(input);
            ${screenId}List.addAll(${screenId}Page.getContent());

        } else {
            Page<${screenId?cap_first}Revision> ${screenId}Page2 = ${screenId}Service.findMaxRevPageByInput(input);
            for (${screenId?cap_first}Revision ${screenId}Revision : ${screenId}Page2.getContent()) {
                ${screenId}List.add(beanMapper.map(${screenId}Revision, ${screenId?cap_first}.class));
            }
        }

        for (${screenId?cap_first} ${screenId} : ${screenId}List) {
            SimpleCsvBean row = beanMapper.map(${screenId}, SimpleCsvBean.class);
            row.setStatusLabel(Status.getByValue(${screenId}.getStatus()).getCodeLabel());
            list.add(row);
        }

        model.addAttribute("exportCsvData", list);
        model.addAttribute("class", SimpleCsvBean.class);
    }


    private String getToggleButton(String id, OperationsUtil op) {

        StringBuffer link = new StringBuffer();
        link.append("<div class=\"btn-group\">");
        link.append("<a href=\"" + op.getEditUrl(id) + "\" class=\"btn btn-button btn-sm\" style=\"white-space: nowrap\">" + op.getLABEL_EDIT() + "</a>");
        link.append("<button type=\"button\" class=\"btn btn-button btn-sm dropdown-toggle dropdown-toggle-split\"data-toggle=\"dropdown\" aria-haspopup=\"true\" aria-expanded=\"false\">");
        link.append("</button>");
        link.append("<div class=\"dropdown-menu\">");
        link.append("<a class=\"dropdown-item\" href=\"" + op.getViewUrl(id) + "\">" + op.getLABEL_VIEW() + "</a>");
        link.append("<a class=\"dropdown-item\" href=\"" + op.getCopyUrl(id) + "\">" + op.getLABEL_COPY() + "</a>");
        link.append("<a class=\"dropdown-item\" href=\"" + op.getInvalidUrl(id) + "\">" + op.getLABEL_INVALID() + "</a>");
        link.append("</div>");
        link.append("</div>");

        return link.toString();
    }

    protected OperationsUtil op() {
        return new OperationsUtil(BASE_PATH);
    }

    /**
     * 新規作成画面を開く
     */
    @GetMapping(value = "create", params = "form")
    @TransactionTokenCheck(type = TransactionTokenType.BEGIN)
    public String createForm(${screenId?cap_first}Form form,
                             Model model,
                             @AuthenticationPrincipal LoggedInUser loggedInUser,
                             @RequestParam(value = "copy", required = false) Long copy) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.CREATE, loggedInUser);

        if (copy != null) {
            ${screenId?cap_first} source = ${screenId}Service.findById(copy);
            beanMapper.map(source, form);
            form.setId(null);
        }

        if (form.getAttachedFile01Uuid() != null) {
            form.setAttachedFile01Managed(fileManagedSharedService.findByUuid(form.getAttachedFile01Uuid()));
        }

        model.addAttribute("buttonState", getButtonStateMap(Constants.OPERATION.CREATE, null).asMap());
        model.addAttribute("fieldState", getFiledStateMap(Constants.OPERATION.CREATE, null).asMap());
        model.addAttribute("op", op());

        return JSP_FORM;
    }

    /**
     * 新規登録
     */
    @PostMapping(value = "create")
    @TransactionTokenCheck
    public String create(@Validated({${screenId?cap_first}Form.Create.class, Default.class}) ${screenId?cap_first}Form form,
                         BindingResult bindingResult,
                         Model model,
                         RedirectAttributes redirect,
                         @AuthenticationPrincipal LoggedInUser loggedInUser,
                         @RequestParam(value = "saveDraft", required = false) String saveDraft) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.CREATE, loggedInUser);

        if (bindingResult.hasErrors()) {
            return createForm(form, model, loggedInUser, null);
        }

        ${screenId?cap_first} ${screenId} = beanMapper.map(form, ${screenId?cap_first}.class);

        try {
            if ("true".equals(saveDraft)) {
                ${screenId}.setStatus(Status.VALID.getCodeValue());
                ${screenId}Service.saveDraft(${screenId});
            } else {
                ${screenId}.setStatus(Status.VALID.getCodeValue());
                ${screenId}Service.save(${screenId});
            }
        } catch (BusinessException e) {
            model.addAttribute(e.getResultMessages());
            return createForm(form, model, loggedInUser, null);
        }

        redirect.addFlashAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0001));

        return "redirect:" + op().getEditUrl(${screenId}.getId().toString());
    }

    /**
     * 編集画面を開く
     */
    @GetMapping(value = "{id}/update", params = "form")
    @TransactionTokenCheck(type = TransactionTokenType.BEGIN)
    public String updateForm(${screenId?cap_first}Form form, Model model,
                             @AuthenticationPrincipal LoggedInUser loggedInUser,
                             @PathVariable("id") Long id) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.SAVE, loggedInUser);

        ${screenId?cap_first} ${screenId} = ${screenId}Service.findById(id);
        model.addAttribute("${screenId}", ${screenId});

        // 状態=無効の場合、参照画面に強制遷移
        if (${screenId}.getStatus().equals(Status.INVALID.getCodeValue())) {
            model.addAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0008));
            return view(model, loggedInUser, id, null);
        }

        // 入力チェック再表示の場合、formの情報をDBの値で上書きしない
        if (form.getVersion() == null) {
            beanMapper.map(${screenId}, form);
        }

        if (form.getAttachedFile01Uuid() != null) {
            form.setAttachedFile01Managed(fileManagedSharedService.findByUuid(form.getAttachedFile01Uuid()));
        }

        model.addAttribute("buttonState", getButtonStateMap(Constants.OPERATION.SAVE, ${screenId}).asMap());
        model.addAttribute("fieldState", getFiledStateMap(Constants.OPERATION.SAVE, ${screenId}).asMap());
        model.addAttribute("op", op());

        return JSP_FORM;
    }

    /**
     * 更新
     */
    @PostMapping(value = "{id}/update")
    @TransactionTokenCheck
    public String update(@Validated({${screenId?cap_first}Form.Update.class, Default.class}) ${screenId?cap_first}Form form,
                         BindingResult bindingResult,
                         Model model,
                         RedirectAttributes redirect,
                         @AuthenticationPrincipal LoggedInUser loggedInUser,
                         @PathVariable("id") Long id,
                         @RequestParam(value = "saveDraft", required = false) String saveDraft) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.SAVE, loggedInUser);

        if (bindingResult.hasErrors()) {
            return updateForm(form, model, loggedInUser, id);
        }

        ${screenId?cap_first} ${screenId} = beanMapper.map(form, ${screenId?cap_first}.class);

        try {
            if ("true".equals(saveDraft)) {
                ${screenId}Service.saveDraft(${screenId});
            } else {
                ${screenId}.setStatus(Status.VALID.getCodeValue());
                ${screenId}Service.save(${screenId});
            }
        } catch (BusinessException e) {
            model.addAttribute(e.getResultMessages());
            return updateForm(form, model, loggedInUser, id);
        }

        redirect.addFlashAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0004));

        return "redirect:" + op().getEditUrl(${screenId}.getId().toString());
    }

    /**
     * 削除
     */
    @GetMapping(value = "{id}/delete")
    public String delete(Model model, RedirectAttributes redirect, @AuthenticationPrincipal LoggedInUser loggedInUser,
                         @PathVariable("id") Long id) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.DELETE, loggedInUser);

        try {
            ${screenId}Service.delete(id);
        } catch (BusinessException e) {
            model.addAttribute(e.getResultMessages());
        }

        redirect.addFlashAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0007));

        return "redirect:" + op().getListUrl();
    }

    /**
     * 無効化
     */
    @GetMapping(value = "{id}/invalid")
    public String invalid(Model model, RedirectAttributes redirect, @AuthenticationPrincipal LoggedInUser loggedInUser,
                          @PathVariable("id") Long id) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.INVALID, loggedInUser);

        ${screenId?cap_first} entity = ${screenId}Service.findById(id);

        try {
            entity = ${screenId}Service.invalid(id);
        } catch (BusinessException e) {
            redirect.addFlashAttribute(e.getResultMessages());
            return "redirect:" + op().getEditUrl(id.toString());
        }

        redirect.addFlashAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0002));

        return "redirect:" + op().getViewUrl(id.toString());
    }

    /**
     * 無効解除
     */
    @GetMapping(value = "{id}/valid")
    public String valid(Model model, RedirectAttributes redirect, @AuthenticationPrincipal LoggedInUser loggedInUser,
                        @PathVariable("id") Long id) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.VALID, loggedInUser);

        ${screenId?cap_first} entity = ${screenId}Service.findById(id);

        try {
            entity = ${screenId}Service.valid(id);
        } catch (BusinessException e) {
            redirect.addFlashAttribute(e.getResultMessages());
            return "redirect:" + op().getViewUrl(id.toString());
        }

        redirect.addFlashAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0002));

        return "redirect:" + op().getEditUrl(id.toString());
    }

    /**
     * 下書き取消
     */
    @GetMapping(value = "{id}/cancel_draft")
    public String cancelDraft(Model model, RedirectAttributes redirect, @AuthenticationPrincipal LoggedInUser loggedInUser,
                              @PathVariable("id") Long id) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.CANCEL_DRAFT, loggedInUser);

        ${screenId?cap_first} entity = null;
        try {
            entity = ${screenId}Service.cancelDraft(id);
        } catch (BusinessException e) {
            redirect.addFlashAttribute(e.getResultMessages());
            return "redirect:" + op().getEditUrl(id.toString());
        }

        redirect.addFlashAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0002));

        if (entity != null) {
            return "redirect:" + op().getEditUrl(id.toString());
        } else {
            return "redirect:" + op().getListUrl();
        }
    }

    /**
     * 参照画面の表示
     */
    @GetMapping(value = "{id}")
    public String view(Model model, @AuthenticationPrincipal LoggedInUser loggedInUser,
                       @PathVariable("id") Long id,
                       @RequestParam(value = "rev", required = false) Long rev) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.VIEW, loggedInUser);

        ${screenId?cap_first} ${screenId};
        if ( rev == null) {
            // 下書きを含む最新
            ${screenId} = ${screenId}Service.findById(id);

        } else if (rev == 0) {
            // 有効な最新リビジョン
            ${screenId} = beanMapper.map(${screenId}Service.findByIdLatestRev(id), ${screenId?cap_first}.class);

        } else {
            // リビジョン番号指定
            ${screenId} = beanMapper.map(${screenId}Service.findByRid(rev), ${screenId?cap_first}.class);
        }

        model.addAttribute("${screenId}", ${screenId});

        if (${screenId}.getAttachedFile01Uuid() != null) {
            ${screenId}.setAttachedFile01Managed(fileManagedSharedService.findByUuid(${screenId}.getAttachedFile01Uuid()));
        }

        model.addAttribute("buttonState", getButtonStateMap(Constants.OPERATION.VIEW, ${screenId}).asMap());
        model.addAttribute("fieldState", getFiledStateMap(Constants.OPERATION.VIEW, ${screenId}).asMap());
        model.addAttribute("op", op());

        return JSP_FORM;
    }

    /**
     * ダウンロード
     */
    @GetMapping("{uuid}/download")
    public String download(
            Model model,
            @PathVariable("uuid") String uuid,
            @AuthenticationPrincipal LoggedInUser loggedInUser) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.DOWNLOAD, loggedInUser);

        model.addAttribute(fileManagedSharedService.findByUuid(uuid));
        return "fileManagedDownloadView";
    }

    /**
     * ボタンの状態設定
     */
    private StateMap getButtonStateMap(String operation, ${screenId?cap_first} record) {

        if (record == null) {
            record = new ${screenId?cap_first}();
        }

        List<String> includeKeys = new ArrayList<>();
        includeKeys.add(Constants.BUTTON.GOTOLIST);
        includeKeys.add(Constants.BUTTON.GOTOUPDATE);
        includeKeys.add(Constants.BUTTON.VIEW);
        includeKeys.add(Constants.BUTTON.SAVE);
        includeKeys.add(Constants.BUTTON.INVALID);
        includeKeys.add(Constants.BUTTON.VALID);
        includeKeys.add(Constants.BUTTON.DELETE);
        includeKeys.add(Constants.BUTTON.UNLOCK);
        includeKeys.add(Constants.BUTTON.SAVE_DRAFT);
        includeKeys.add(Constants.BUTTON.CANCEL_DRAFT);

        StateMap buttonState = new StateMap(Default.class, includeKeys, new ArrayList<>());

        // 常に表示
        buttonState.setViewTrue(Constants.BUTTON.GOTOLIST);

        // 新規作成
        if (Constants.OPERATION.CREATE.equals(operation)) {
            buttonState.setViewTrue(Constants.BUTTON.SAVE);
            buttonState.setViewTrue(Constants.BUTTON.SAVE_DRAFT);
        }

        // 編集
        if (Constants.OPERATION.SAVE.equals(operation)) {

            if (Status.DRAFT.getCodeValue().equals(record.getStatus())) {
                buttonState.setViewTrue(Constants.BUTTON.CANCEL_DRAFT);
                buttonState.setViewTrue(Constants.BUTTON.SAVE_DRAFT);
                buttonState.setViewTrue(Constants.BUTTON.SAVE);
                buttonState.setViewTrue(Constants.BUTTON.VIEW);
            }

            if (Status.VALID.getCodeValue().equals(record.getStatus())) {
                buttonState.setViewTrue(Constants.BUTTON.SAVE_DRAFT);
                buttonState.setViewTrue(Constants.BUTTON.SAVE);
                buttonState.setViewTrue(Constants.BUTTON.VIEW);
                buttonState.setViewTrue(Constants.BUTTON.INVALID);
            }

            if (Status.INVALID.getCodeValue().equals(record.getStatus())) {
                buttonState.setViewTrue(Constants.BUTTON.VIEW);
                buttonState.setViewTrue(Constants.BUTTON.VALID);
                buttonState.setViewTrue(Constants.BUTTON.DELETE);
            }

        }

        // 参照
        if (Constants.OPERATION.VIEW.equals(operation)) {

            // スタータスが公開時
            if (Status.VALID.getCodeValue().equals(record.getStatus())) {
                buttonState.setViewTrue(Constants.BUTTON.GOTOUPDATE);
                buttonState.setViewTrue(Constants.BUTTON.INVALID);
                buttonState.setViewTrue(Constants.BUTTON.UNLOCK);
            }

            // スタータスが無効
            if (Status.INVALID.getCodeValue().equals(record.getStatus())) {
                buttonState.setViewTrue(Constants.BUTTON.VALID);
                buttonState.setViewTrue(Constants.BUTTON.DELETE);
            }
        }

        return buttonState;
    }

    /**
     * フィールドの状態設定
     */
    private StateMap getFiledStateMap(String operation, ${screenId?cap_first} record) {

        // 常設の隠しフィールドは状態管理しない
        List<String> excludeKeys = new ArrayList<>();
        excludeKeys.add("id");
        excludeKeys.add("version");

        StateMap fieldState = new StateMap(${screenId?cap_first}Form.class, new ArrayList<>(), excludeKeys);

        // 新規作成
        if (Constants.OPERATION.CREATE.equals(operation)) {
            fieldState.setInputTrueAll();
        }

        // 編集
        if (Constants.OPERATION.SAVE.equals(operation)) {
            fieldState.setInputTrueAll();
            fieldState.setViewTrue("status");

            // スタータスが無効
            if (Status.INVALID.toString().equals(record.getStatus())) {
                fieldState.setReadOnlyTrueAll();
            }
        }

        // 参照
        if (Constants.OPERATION.VIEW.equals(operation)) {
            fieldState.setViewTrueAll();
        }

        return fieldState;
    }

}
