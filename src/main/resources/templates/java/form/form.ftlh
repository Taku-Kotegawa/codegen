package ${package};

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;
import org.terasoluna.gfw.common.codelist.ExistInCodeList;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import java.io.Serializable;

<#list imports as import>
import ${import};
</#list>

/**
 * ${screenName}管理の編集画面のBean
 * @author Automatically generated
 *
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ${screenId?cap_first}Form implements Serializable {
 
    /**
     * Serial Version UID
     */
    private static final long serialVersionUID = ${serialVersionUID}L;

    // TODO validation をカスタマイズ


    <#list records as record>
    <#if record.itemName?? && record.type?? && record.useItemForCreate??>
    <#if record.description??>
    /**
     * ${record.description}
     */
    </#if><#-- END record.description?? -->
    <#if record.key??>
    </#if><#-- END record.key?? -->
    <#if record.require??>
    @NotNull
    </#if><#-- END record.require?? -->
    <#if record.regex??>
    @Pattern(regexp = "${record.regex}"<#if record.messageCode??>, message="{${record.messageCode}}"</#if>)
    </#if><#-- END record.regex?? -->
    <#if record.min??>
    @DecimalMin("${record.min}")
    </#if><#-- END record.min?? -->
    <#if record.max??>
    @DecimalMax("${record.max}")
    </#if><#-- END record.max?? -->
    <#if record.digitPattern?? && record.digitPattern == "文字数">
    <#if record.minLength?? && record.maxLength??>
    @Size(min = ${record.minLength}, max = ${record.maxLength})
    <#elseif record.minLength??>
    @Size(min = ${record.minLength})
    <#elseif record.maxLength??>
    @Size(max = ${record.maxLength})
    </#if><#-- END record.minLength?? && record.maxLength?? -->
    <#elseif record.digitPattern?? && record.digitPattern == "byte数">
    <#if record.minLength??>
    @ByteMin(${record.minLength})
    </#if><#-- END record.minLength?? -->
    <#if record.maxLength??>
    @ByteMax(${record.maxLength})
    </#if><#-- END record.maxLength?? -->
    </#if><#-- END record.digitPattern?? && record.digitPattern == "文字数" -->
    <#switch record.type>
    <#case "LocalDateTime">
    @DateTimeFormat(pattern = "yyyy/MM/dd hh:mm:ss")
    <#break>
    <#case "LocalDate">
    @DateTimeFormat(pattern = "yyyy/MM/dd")
    <#break>
    </#switch>
    <#if record.existInCodeList??>
    @ExistInCodeList(codeListId = "${record.existInCodeList}")
    </#if><#-- END record.existInCodeList?? -->
    private ${record.type} ${record.itemName};
    </#if><#-- END record.itemName?? && record.type?? && record.useItemForCreate?? -->

    </#list>

    public interface Create {
    }

    public interface Update {
    }

}