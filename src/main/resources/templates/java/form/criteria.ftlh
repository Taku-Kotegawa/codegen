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
 * ${screenName}管理の一覧画面のBean
 * @author Automatically generated
 *
 */
@Data
public class ${screenId?cap_first}SearchCriteriaForm implements Serializable {
 
    /** Serial Version UID */
    private static final long serialVersionUID = ${serialVersionUID}L;

    // TODO validation をカスタマイズ

    /** 選択された行のキー */
    @NotEmpty(message = "{e.validation.base.5006}")
    private String selectAlternateKey;

<#list records as record>
    <#if record.type??>
        <#if record.inputItemForList??>
            <#if record.description??>
    /** ${record.description} */
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
    </#if>
</#list>
    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE);
    }
}