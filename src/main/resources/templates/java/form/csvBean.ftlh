package ${package};

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import javax.validation.constraints.*;
import lombok.Data;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import org.hibernate.validator.constraints.NotEmpty;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;
import org.terasoluna.gfw.common.validator.constraints.*;
import com.orangesignal.csv.annotation.CsvColumn;
import com.orangesignal.csv.annotation.CsvEntity;
import java.util.Date;
<#list imports as import>
import ${import};
</#list>

/**
 * ${screenName}管理のCSVファイルのBean
 */
@Data
@CsvEntity
public class ${screenId?cap_first}CsvBean implements Serializable {

    /** Serial Version UID */
    private static final long serialVersionUID = ${serialVersionUID}L;

    // TODO 項目のカスタマイズ

<#list records as record>
    <#if record.itemName?? && record.type?? && record.useItemForExport?? >
        <#if record.description??>
    /** ${record.description} */
        <#switch record.type>
            <#case "LocalDateTime">
    @CsvColumn(name = "${record.description}, format="yyyy/mm/dd hh:mm:ss")
                <#break>
            <#case "LocalDate">
    @CsvColumn(name = "${record.description}", format="yyyy/MM/dd")
                <#break>
            <#default>
    @CsvColumn(name = "${record.description}")
                <#break>
        </#switch>
        </#if>
        <#if record.inputItemForCreate??>
            <#if record.require??>
                <#switch record.type>
                    <#case "String">
    @NotNull
                        <#break>
                    <#default>
    @NotNull
                        <#break>
                </#switch>
            </#if>
            <#if record.min??>
    @DecimalMin("${record.min}")
            </#if>
            <#if record.max??>
    @DecimalMax("${record.max}")
            </#if>
            <#if record.digitPattern?? && record.digitPattern == "文字数">
                <#if record.minLength?? && record.maxLength??>
    @Size(min = ${record.minLength}, max = ${record.maxLength})
                <#elseif record.minLength??>
    @Size(min = ${record.minLength})
                <#elseif record.maxLength??>
    @Size(max = ${record.maxLength})
                </#if>
            <#elseif record.digitPattern?? && record.digitPattern == "byte数">
                <#if record.minLength??>
    @ByteMin(${record.minLength})
                </#if>
                <#if record.maxLength??>
    @ByteMax(${record.maxLength})
                </#if>
            </#if>
        </#if>
        <#switch record.type>
            <#case "LocalDateTime">
    private Date ${record.itemName};
                <#break>
            <#case "LocalDate">
    private Date ${record.itemName};
                <#break>
            <#default>
    private ${record.type} ${record.itemName};
                <#break>
        </#switch>
    </#if>
</#list>
}