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
import jp.or.biken.base.common.constant.Constant;
<#list imports as import>
import ${import};
</#list>

/**
 * ${screenName}管理の編集画面のBean
 * @author Automatically generated
 *
 */
@Data
public class ${screenId?cap_first}UpdateForm implements Serializable {
 
    /** Serial Version UID */
    private static final long serialVersionUID = ${serialVersionUID}L;

    // TODO validation をカスタマイズ

<#list records as record>
    <#if record.itemName?? && record.key?? && record.type??>
        <#if record.description??>
    /** ${record.description} */
        </#if>
        <#if record.inputItemForUpdate??>
            <#if record.require??>
                <#switch record.type>
                    <#case "String">
    @NotEmpty
                        <#break>
                    <#default>
    @NotNull
                        <#break>
                </#switch>
            </#if>
            <#if record.regex??>
    @Pattern(regexp = "${record.regex}"<#if record.messageCode??>, message="{${record.messageCode}}"</#if>)
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
    @DateTimeFormat(pattern = Constant.DATETIME_FORMAT)
                <#break>
            <#case "LocalDate">
    @DateTimeFormat(pattern = Constant.DATE_FORMAT)
                <#break>
            <#default>
                <#break>
        </#switch>
    private ${record.type} ${record.itemName};

    </#if>
</#list>
<#list records as record>
    <#if record.type?? && !record.key?? && record.useItemForUpdate??>
        <#if record.description??>
    /** ${record.description} */
        </#if>
        <#if record.inputItemForUpdate??>
            <#if record.require??>
                <#switch record.type>
                    <#case "String">
    @NotEmpty
                        <#break>
                    <#default>
    @NotNull
                        <#break>
                </#switch>
            </#if>
            <#if record.regex??>
    @Pattern(regexp = "${record.regex}"<#if record.messageCode??>, message="{${record.messageCode}}"</#if>)
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
    @DateTimeFormat(pattern = Constant.DATETIME_FORMAT)
                <#break>
            <#case "LocalDate">
    @DateTimeFormat(pattern = Constant.DATE_FORMAT)
                <#break>
            <#default>
                <#break>
        </#switch>
    private ${record.type} ${record.itemName};

    </#if>
</#list>
    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE);
    }
}