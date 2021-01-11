package jp.co.stnet.cms.app.${screenId?lower_case};

import com.github.dozermapper.core.Mapper;
import jp.co.stnet.cms.app.admin.upload.UploadForm;
import jp.co.stnet.cms.app.${screenId?lower_case}.${screenId?cap_first}Form.Create;
import jp.co.stnet.cms.app.${screenId?lower_case}.${screenId?cap_first}Form.Update;
import jp.co.stnet.cms.domain.common.Constants;
import jp.co.stnet.cms.domain.common.StateMap;
import jp.co.stnet.cms.domain.common.datatables.DataTablesInputDraft;
import jp.co.stnet.cms.domain.common.datatables.DataTablesOutput;
import jp.co.stnet.cms.domain.common.datatables.OperationsUtil;
import jp.co.stnet.cms.domain.common.message.MessageKeys;
import jp.co.stnet.cms.domain.common.scheduled.CsvUtils;
import jp.co.stnet.cms.domain.model.authentication.LoggedInUser;
import jp.co.stnet.cms.domain.model.common.FileManaged;
import jp.co.stnet.cms.domain.model.common.Status;
import jp.co.stnet.cms.domain.model.example.${screenId?cap_first};
import jp.co.stnet.cms.domain.model.example.${screenId?cap_first}Revision;
import jp.co.stnet.cms.domain.service.common.FileManagedSharedService;
import jp.co.stnet.cms.domain.service.example.MyBatchService;
import jp.co.stnet.cms.domain.service.example.${screenId?cap_first}Service;
import lombok.extern.slf4j.Slf4j;
import org.springframework.batch.core.JobParametersInvalidException;
import org.springframework.batch.core.launch.JobInstanceAlreadyExistsException;
import org.springframework.batch.core.launch.JobOperator;
import org.springframework.batch.core.launch.NoSuchJobException;
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
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Controller
@RequestMapping("${screenId?lower_case}")
@TransactionTokenCheck("${screenId?lower_case}")
public class ${screenId?cap_first}Controller {

    // JSPのパス設定
    private final String BASE_PATH = "${screenId?lower_case}";
    private final String JSP_LIST = BASE_PATH + "/list";
    private final String JSP_FORM = BASE_PATH + "/form";
    private final String JSP_VIEW = BASE_PATH + "/view";
    private final String JSP_UPLOAD_FORM = "upload/form";
    private final String JSP_UPLOAD_COMPLETE = "upload/complete";

    // CSV/Excelのファイル名(拡張子除く)
    private final String DOWNLOAD_FILENAME = "${screenId?lower_case}";

    // アップロード用のインポートジョブID
    private final String UPLOAD_JOB_ID = "job03";

    @Autowired
    ${screenId?cap_first}Service ${screenId}Service;

    @Autowired
    FileManagedSharedService fileManagedSharedService;

    @Autowired
    JobOperator jobOperator;

    @Autowired
    @Named("CL_STATUS")
    CodeList statusCodeList;

    @Autowired
    private MyBatchService service; // 非同期処理のサンプル

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
     * @param input DataTablesからの要求(Server-side処理)
     * @return JSON
     */
    @ResponseBody
    @GetMapping(value = "/list/json")
    public DataTablesOutput<${screenId?cap_first}ListRow> listJson(@Validated DataTablesInputDraft input) {

        List<${screenId?cap_first}ListRow> listRows = new ArrayList<>();
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

        for (${screenId?cap_first}Bean bean : getBeanList(${screenId}List)) {
            ${screenId?cap_first}ListRow ${screenId}ListRow = beanMapper.map(bean, ${screenId?cap_first}ListRow.class);
            ${screenId}ListRow.setOperations(getToggleButton(bean.getId().toString(), op(null)));
            ${screenId}ListRow.setDT_RowId(bean.getId().toString());
            // ステータスラベル
            ${screenId}ListRow.setStatusLabel(Status.getByValue(bean.getStatus()).getCodeLabel());
            listRows.add(${screenId}ListRow);
        }

        DataTablesOutput<${screenId?cap_first}ListRow> output = new DataTablesOutput<>();
        output.setData(listRows);
        output.setDraw(input.getDraw());
        output.setRecordsTotal(0);
        output.setRecordsFiltered(recordsFiltered);

        return output;
    }

    /**
     * CSVファイルのダウンロード
     * @param input DataTablesからの要求(Server-side処理)
     * @param model モデル
     * @return ファイルダウンロード用View
     */
    @GetMapping(value = "/list/csv")
    public String listCsv(@Validated DataTablesInputDraft input, Model model) {
        input.setStart(0);
        input.setLength(Constants.CSV.MAX_LENGTH);
        setModelForCsv(input, model);
        model.addAttribute("csvConfig", CsvUtils.getCsvDefault());
        model.addAttribute("csvFileName", DOWNLOAD_FILENAME + ".csv");
        return "csvDownloadView";
    }

    /**
     * TSVファイルのダウンロード
     * @param input DataTablesからの要求(Server-side処理)
     * @param model モデル
     * @return ファイルダウンロード用View
     */
    @GetMapping(value = "/list/tsv")
    public String listTsv(@Validated DataTablesInputDraft input, Model model) {
        input.setStart(0);
        input.setLength(Constants.CSV.MAX_LENGTH);
        setModelForCsv(input, model);
        model.addAttribute("csvConfig", CsvUtils.getTsvDefault());
        model.addAttribute("csvFileName", DOWNLOAD_FILENAME + ".tsv");
        return "csvDownloadView";
    }

    /**
     * Excelファイルのダウンロード
     * @param input DataTablesからの要求(Server-side処理)
     * @param model モデル
     * @return ファイルダウンロード用View
     */
    @GetMapping(value = "/list/excel")
    public String listExcel(@Validated DataTablesInputDraft input, Model model) {
        input.setStart(0);
        input.setLength(Constants.EXCEL.MAX_LENGTH);
        // TODO: 汎用的な仕組みに改造が必要
        model.addAttribute("list", ${screenId}Service.findPageByInput(input).getContent());
        model.addAttribute("excelFileName", DOWNLOAD_FILENAME + ".xlsx");
        return "excelDownloadView";
    }

    /**
     * csvDownloadViewに渡すデータ準備
     * @param input DataTablesからの要求(Server-side処理)
     * @param model データをセットするモデル
     */
    private void setModelForCsv(DataTablesInputDraft input, Model model) {

        List<${screenId?cap_first}CsvBean> csvBeans = new ArrayList<>();
        List<${screenId?cap_first}> ${screenId}List = new ArrayList<>();

        if (input.getDraft() == null || input.getDraft()) { // 下書き含む最新
            Page<${screenId?cap_first}> ${screenId}Page = ${screenId}Service.findPageByInput(input);
            ${screenId}List.addAll(${screenId}Page.getContent());

        } else {
            Page<${screenId?cap_first}Revision> ${screenId}Page2 = ${screenId}Service.findMaxRevPageByInput(input);
            for (${screenId?cap_first}Revision ${screenId}Revision : ${screenId}Page2.getContent()) {
                ${screenId}List.add(beanMapper.map(${screenId}Revision, ${screenId?cap_first}.class));
            }
        }

        for (${screenId?cap_first} ${screenId} : getBeanList(${screenId}List)) {
            ${screenId?cap_first}CsvBean row = beanMapper.map(${screenId}, ${screenId?cap_first}CsvBean.class);
            customMap(row, ${screenId});
            row.setStatusLabel(Status.getByValue(${screenId}.getStatus()).getCodeLabel());
            csvBeans.add(row);
        }

        model.addAttribute("exportCsvData", csvBeans);
        model.addAttribute("class", ${screenId?cap_first}CsvBean.class);
    }

    /**
     * 一覧画面、CSVファイルのためのデータ変換
     *
     * @param entities
     * @return
     */
    private List<${screenId?cap_first}Bean> getBeanList(List<${screenId?cap_first}> entities) {
        List<${screenId?cap_first}Bean> beans = new ArrayList<>();
        for(${screenId?cap_first} entity : entities) {
            ${screenId?cap_first}Bean bean = beanMapper.map(entity, ${screenId?cap_first}Bean.class);

            // ラジオボタン(真偽値)ラベル
            if (entity.getRadio01() != null) {
                bean.setRadio01Label(entity.getRadio01() ? "はい" : "いいえ");
            }

            // チェックボックス(文字列)ラベル
            if (entity.getCheckbox01() != null) {
                bean.setCheckbox01Label("はい".equals(entity.getCheckbox01()) ? "☑" : "□"  + "利用規約に合意する");
            }

            // チェックボックス(複数の値)ラベル
            if (entity.getCheckbox02() != null) {
                String s = entity.getCheckbox02().stream()
                        .map(str -> statusCodeList.asMap().get(str))
                        .collect(Collectors.joining(", "));
                bean.setCheckbox02Label(s);
            }

            // セレクト(単一の値)ラベル
            if (entity.getSelect01() != null) {
                bean.setSelect01Label(statusCodeList.asMap().get(entity.getSelect01()));
            }

            // セレクト(複数の値)
            if (entity.getSelect02() != null) {
                String t = entity.getSelect02().stream()
                        .map(str -> statusCodeList.asMap().get(str))
                        .collect(Collectors.joining(", "));
                bean.setSelect02Label(t);
            }

            // セレクト(単一の値, select2)
            if (entity.getSelect03() != null) {
                bean.setSelect03Label(statusCodeList.asMap().get(entity.getSelect03()));
            }

            // セレクト(複数の値, select2)
            String u = entity.getSelect04().stream()
                    .map(str -> statusCodeList.asMap().get(str))
                    .collect(Collectors.joining(", "));
            bean.setSelect04Label(u);

            // コンボボックス(単一の値, Select2)
            if (entity.getCombobox02() != null) {
                bean.setCombobox02Label(statusCodeList.asMap().get(entity.getCombobox02()));
            }

            // コンボボックス(複数の値, Select2)
            if (entity.getCombobox03() != null) {
                String v = entity.getCombobox03().stream()
                        .map(str -> statusCodeList.asMap().get(str))
                        .collect(Collectors.joining(", "));
                bean.setCombobox03Label(v);
            }

            // 添付ファイル名
//            if (entity.getAttachedFile01Uuid() != null) {
//                bean.setAttachedFile01Managed(fileManagedSharedService.findByUuid(entity.getAttachedFile01Uuid()));
//                if (bean.getAttachedFile01Managed() != null) {
//                    bean.setAttachedFile01FileName(bean.getAttachedFile01Managed().getOriginalFilename());
//                }
//            }

            if (entity.getAttachedFile01Managed() != null) {
                bean.setAttachedFile01FileName(bean.getAttachedFile01Managed().getOriginalFilename());
            }


            beans.add(bean);
        }
        return beans;
    }

    /**
     * CSVファイル固有要件のデータ変換
     * @param row 変換後のCSVビーン
     * @param ${screenId} エンティティ
     */
    private void customMap(${screenId?cap_first}CsvBean row, ${screenId?cap_first} ${screenId}) {

    }

    /**
     * リビジョンテーブルのデータを通常のエンティティに変換
     * @param entities リビジョンエンティティのリスト
     * @return エンティティのリスト
     */
    private List<${screenId?cap_first}Bean> getBeanListByRev(List<${screenId?cap_first}Revision> entities) {
        List<${screenId?cap_first}> beans = new ArrayList<>();
        for(${screenId?cap_first}Revision entity : entities) {
            ${screenId?cap_first} bean = beanMapper.map(entities, ${screenId?cap_first}.class);
            beans.add(bean);
        }
        return getBeanList(beans);
    }

    /**
     * 一覧画面のトグルボタンHTMLの生成
     * @param id エンティティの内部ID
     * @param op OperationsUtil リンクURLを生成するクラス
     * @return HTML
     */
    private String getToggleButton(String id, OperationsUtil op) {

        // fixedColumnを使うとトグルボタンは使えない。
//        StringBuffer link = new StringBuffer();
//        link.append("<div class=\"whitespace-nowrap\">");
//        link.append("<a class=\"whitespace-nowrap\" href=\"" + op.getEditUrl(id) + "\">" + op.getLABEL_EDIT() + "</a>");
//        link.append(" | ");
//        link.append("<a class=\"whitespace-nowrap\" href=\"" + op.getViewUrl(id) + "\">" + op.getLABEL_VIEW() + "</a></li>");
//        link.append("</div>");

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

    private OperationsUtil op() {
        return new OperationsUtil(BASE_PATH);
    }

    private OperationsUtil op(String param) {
        return new OperationsUtil(param);
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
     * 一括削除
     */
    @PostMapping("bulk_delete")
    public String bulkDelete(Model model, String selectedKey, RedirectAttributes redirect, @AuthenticationPrincipal LoggedInUser loggedInUser) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.BULK_DELETE, loggedInUser);

        String[] strKeys = selectedKey.split(",");
        List<${screenId?cap_first}> deleteEntities = new ArrayList<>();
        for(String key : strKeys) {
            ${screenId?cap_first} entity = ${screenId}Service.findById(Long.valueOf(key));
            if (entity.getStatus().equals(Status.INVALID.getCodeValue())) {
                deleteEntities.add(entity);
            }
        }

        ${screenId}Service.delete(deleteEntities);

        redirect.addFlashAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0003));
        return "redirect:" + op().getListUrl();
    }

    /**
     * 一括無効化(有効データのみ対象)
     */
    @PostMapping("bulk_invalid")
    public String bulkInvalid(Model model, String selectedKey, RedirectAttributes redirect, @AuthenticationPrincipal LoggedInUser loggedInUser) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.BULK_INVALID, loggedInUser);

        String[] strKeys = selectedKey.split(",");
        List<Long> ids = new ArrayList<>();
        for(String key : strKeys) {
            Long id = Long.valueOf(key);
            ${screenId?cap_first} entity = ${screenId}Service.findById(id);
            if (entity.getStatus().equals(Status.VALID.getCodeValue())) {
                ids.add(id);
            }
        }

        ${screenId}Service.invalid(ids);

        redirect.addFlashAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0002));
        return "redirect:" + op().getListUrl();
    }

    /**
     * 一括有効化(無効データのみ対象)
     */
    @PostMapping("bulk_valid")
    public String bulkValid(Model model, String selectedKey, RedirectAttributes redirect, @AuthenticationPrincipal LoggedInUser loggedInUser) {

        ${screenId}Service.hasAuthority(Constants.OPERATION.BULK_VALID, loggedInUser);

        String[] strKeys = selectedKey.split(",");
        List<Long> ids = new ArrayList<>();
        for(String key : strKeys) {
            Long id = Long.valueOf(key);
            ${screenId?cap_first} entity = ${screenId}Service.findById(id);
            if (entity.getStatus().equals(Status.INVALID.getCodeValue())) {
                ids.add(id);
            }
        }

        ${screenId}Service.valid(ids);

        redirect.addFlashAttribute(ResultMessages.info().add(MessageKeys.I_CM_FW_0002));
        return "redirect:" + op().getListUrl();
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

        setFileManagedToForm(form);

        model.addAttribute("buttonState", getButtonStateMap(Constants.OPERATION.CREATE, null).asMap());
        model.addAttribute("fieldState", getFiledStateMap(Constants.OPERATION.CREATE, null).asMap());
        model.addAttribute("op", op());

        return JSP_FORM;
    }

    /**
     * UUIDからFileManagedオブジェクトを取得し、formにセットする。
     * @param form フォーム
     */
    private void setFileManagedToForm(${screenId?cap_first}Form form) {
        // TODO ファイルフィールドごとに調整
        if (form.getAttachedFile01Uuid() != null) {
            form.setAttachedFile01Managed(fileManagedSharedService.findByUuid(form.getAttachedFile01Uuid()));
        }
    }

//    /**
//     * UUIDからFileManagedオブジェクトを取得し、Entityにセットする。
//     * @param entity エンティティ
//     */
//    private void setFileManagedToEntity(${screenId?cap_first} entity) {
//        // TODO ファイルフィールドごとに調整
//        if (entity.getAttachedFile01Uuid() != null) {
//            entity.setAttachedFile01Managed(fileManagedSharedService.findByUuid(entity.getAttachedFile01Uuid()));
//        }
//    }

    /**
     * 新規登録
     */
    @PostMapping(value = "create")
    @TransactionTokenCheck
    public String create(@Validated({Create.class, Default.class}) ${screenId?cap_first}Form form,
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

        setFileManagedToForm(form);

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
    public String update(@Validated({Update.class, Default.class}) ${screenId?cap_first}Form form,
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

        // 存在チェックを兼ねる
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

        // 存在チェックを兼ねる
        ${screenId?cap_first} entity = ${screenId}Service.findById(id);

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

        // ${screenId?cap_first} ${screenId} = ${screenId}Service.findById(id);　// TODO: リビジョン管理がない場合はシンプルにできる

        ${screenId?cap_first} ${screenId};

        if (rev == null) {
            // 下書きを含む最新
            ${screenId} = ${screenId}Service.findById(id);

        } else if (rev == 0) {
            // 有効な最新リビジョン
            ${screenId} = beanMapper.map(${screenId}Service.findByIdLatestRev(id), ${screenId?cap_first}.class);

        } else {
            // リビジョン番号指定
            ${screenId} = beanMapper.map(${screenId}Service.findByRid(rev), ${screenId?cap_first}.class);
        }

//        setFileManagedToEntity(${screenId});

        model.addAttribute("${screenId}", ${screenId});

        model.addAttribute("buttonState", getButtonStateMap(Constants.OPERATION.VIEW, ${screenId}).asMap());
        model.addAttribute("fieldState", getFiledStateMap(Constants.OPERATION.VIEW, ${screenId}).asMap());
        model.addAttribute("op", op());

        return JSP_FORM;
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
        includeKeys.add(Constants.BUTTON.COPY);

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
                buttonState.setViewTrue(Constants.BUTTON.COPY);
            }

            if (Status.VALID.getCodeValue().equals(record.getStatus())) {
                buttonState.setViewTrue(Constants.BUTTON.SAVE_DRAFT);
                buttonState.setViewTrue(Constants.BUTTON.SAVE);
                buttonState.setViewTrue(Constants.BUTTON.VIEW);
                buttonState.setViewTrue(Constants.BUTTON.INVALID);
                buttonState.setViewTrue(Constants.BUTTON.COPY);
            }

            if (Status.INVALID.getCodeValue().equals(record.getStatus())) {
                buttonState.setViewTrue(Constants.BUTTON.VIEW);
                buttonState.setViewTrue(Constants.BUTTON.VALID);
                buttonState.setViewTrue(Constants.BUTTON.DELETE);
                buttonState.setViewTrue(Constants.BUTTON.COPY);
            }

        }

        // 参照
        if (Constants.OPERATION.VIEW.equals(operation)) {

            // スタータスが公開時
            if (Status.VALID.getCodeValue().equals(record.getStatus())) {
                buttonState.setViewTrue(Constants.BUTTON.GOTOUPDATE);
                buttonState.setViewTrue(Constants.BUTTON.INVALID);
                buttonState.setViewTrue(Constants.BUTTON.UNLOCK);
                buttonState.setViewTrue(Constants.BUTTON.COPY);
            }

            // スタータスが無効
            if (Status.INVALID.getCodeValue().equals(record.getStatus())) {
                buttonState.setViewTrue(Constants.BUTTON.VALID);
                buttonState.setViewTrue(Constants.BUTTON.DELETE);
                buttonState.setViewTrue(Constants.BUTTON.COPY);
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

    /**
     * アップロードファイル指定画面の表示
     */
    @GetMapping(value = "upload", params = "form")
    public String uploadForm(@ModelAttribute UploadForm form, Model model,
                             @AuthenticationPrincipal LoggedInUser loggedInUser) {

        form.setJobName("job03");

        FileManaged uploadFileManaged = fileManagedSharedService.findByUuid(form.getUploadFileUuid());
        form.setUploadFileManaged(uploadFileManaged);

        model.addAttribute("pageTitle", "Import Simple Entity");
        model.addAttribute("referer", "list");

        return JSP_UPLOAD_FORM;
    }

    /**
     * アップロード処理(バッチ実行)
     */
    @PostMapping(value = "upload")
    public String upload(@Validated UploadForm form, BindingResult result, Model model,
                         RedirectAttributes redirectAttributes,
                         @AuthenticationPrincipal LoggedInUser loggedInUser) {

        final String jobName = UPLOAD_JOB_ID;
        Long jobExecutionId = null;

        if (result.hasErrors()) {
            return uploadForm(form, model, loggedInUser);
        }

        FileManaged uploadFile = fileManagedSharedService.findByUuid(form.getUploadFileUuid());
        String uploadFileAbsolutePath = fileManagedSharedService.getFileStoreBaseDir() + uploadFile.getUri();
        String jobParams = "inputFile=" + uploadFileAbsolutePath;


        if (!jobName.equals(form.getJobName())) {
            return uploadForm(form, model, loggedInUser);
        }


        try {
            jobExecutionId = jobOperator.start(jobName, jobParams);

        } catch (NoSuchJobException | JobInstanceAlreadyExistsException | JobParametersInvalidException e) {
            e.printStackTrace();

            // メッセージをセットして、フォーム画面に戻る。

        }

        redirectAttributes.addAttribute("jobName", jobName);
        redirectAttributes.addAttribute("jobExecutionId", jobExecutionId);

        return "redirect:upload?complete";
    }

    /**
     * アップロード完了画面
     */
    @GetMapping(value = "upload", params = "complete")
    public String uploadComplete(Model model, @RequestParam Map<String, String> params, @AuthenticationPrincipal LoggedInUser loggedInUser) {

        model.addAttribute("returnBackBtn", "一覧画面に戻る");
        model.addAttribute("returnBackUrl", op().getListUrl());
        model.addAttribute("jobName", params.get("jobName"));
        model.addAttribute("jobExecutionId", params.get("jobExecutionId"));
        return JSP_UPLOAD_COMPLETE;
    }

}
