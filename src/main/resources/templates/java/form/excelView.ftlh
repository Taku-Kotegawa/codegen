package ${package};

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.MessageSource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.view.document.AbstractXlsxView;

import jp.or.biken.base.common.util.AppExcelUtils;

/**
 * ${screenName}管理のExcelファイルダウンロード
 */
 @Component
public class ${screenId?cap_first}ExcelFileDownloadView extends AbstractXlsxView {

    @Inject
    MessageSource messageSource;

    // TODO テンプレートファイルの設定
    @Value(value = "classpath:reporttemplate/*.xlsx")
    private Resource templateFile;

    @Override
    protected Workbook createWorkbook(Map<String, Object> model, HttpServletRequest request) {
        Workbook result = AppExcelUtils.createWorkbook(templateFile);

        return result;
    }

    @Override
    protected void buildExcelDocument(Map<String, Object> model, Workbook workbook, HttpServletRequest request,
            HttpServletResponse response) throws Exception {

        // TODO model からのデータ取得
        // List<${screenId?cap_first}ExcelBean> ${screenId}ExcelBeans = (List<${screenId?cap_first}ExcelBean>) model.get("downloadExcelData");

        // TODO 帳票作成
        // Sheet sheet = null;
        // sheet = workbook.getSheet("");

        // ファイル名の設定
        // TODO ファイル名の修正
        String fileName = String.format("${screenId?lower_case}_%s.xlsx",
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));
        response.setHeader("Content-Disposition", String.format("attachment; filename=%s", fileName));
    }
}