package ${package};

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.context.MessageSource;
import org.springframework.stereotype.Component;
import org.terasoluna.gfw.web.download.AbstractFileDownloadView;

import com.orangesignal.csv.Csv;
import com.orangesignal.csv.CsvConfig;
import com.orangesignal.csv.handlers.ColumnNameMappingBeanListHandler;

import jp.or.biken.base.common.constant.Constant;
import jp.or.biken.base.common.util.AppCsvUtils;
import jp.or.biken.base.common.util.AppMessageUtils;

/**
 * ${screenName}管理のCSVファイルエクスポート
 */
@Component
public class ${screenId?cap_first}CsvFileDownloadView extends AbstractFileDownloadView {

    @Inject
    MessageSource messageSource;

    @Override
    protected void addResponseHeader(Map<String, Object> model, HttpServletRequest request,
            HttpServletResponse response) {
        // TODO ファイル名の修正
        String fileName = String.format("${screenId?lower_case}_%s.csv",
                LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd")));

        response.setHeader("Content-Disposition", String.format("attachment; filename=%s", fileName));
        response.setContentType("text/plain");
    }

    @Override
    protected InputStream getInputStream(Map<String, Object> model, HttpServletRequest request) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();

        @SuppressWarnings("unchecked")
        List<${screenId?cap_first}CsvBean> ${screenId}CsvBeans = (List<${screenId?cap_first}CsvBean>) model.get("exportCsvData");
        CsvConfig config = AppCsvUtils.getDefaultConfig();
        Csv.save(${screenId}CsvBeans, baos, Constant.FILE_ENCODING_CSV, config, ${screenId?cap_first}Controller.getCsvBeanMapping(messageSource));

        return new ByteArrayInputStream(baos.toByteArray());
    }
    
    // TODO controllerの末尾に移動する
    /**
     * BeanとCSVファイルのマッピングを取得する
     * 
     * @param messageSource
     * @return BeanとCSVファイルのマッピング
     */
    static public ColumnNameMappingBeanListHandler<${screenId?cap_first}CsvBean> getCsvBeanMapping(MessageSource messageSource) {
        ColumnNameMappingBeanListHandler<${screenId?cap_first}CsvBean> mapping = new ColumnNameMappingBeanListHandler<${screenId?cap_first}CsvBean>(
                ${screenId?cap_first}CsvBean.class);

        SimpleDateFormat sdf = new SimpleDateFormat(Constant.DATE_FORMAT_CSV);
        SimpleDateFormat sdtf = new SimpleDateFormat(Constant.DATETIME_FORMAT_CSV);

        // TODO 項目のカスタマイズ

<#list records as record>
    <#if record.type??>
        <#if record.description??>
        </#if>
        mapping.column(AppMessageUtils.getMessage(messageSource, "label.${screenId?lower_case}.export.column.${record.itemName?lower_case}"), "${record.itemName}");
    </#if>
</#list>

        return mapping;
    }
}