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
 * ${screenName}管理のBean
 * @author Automatically generated
 *
 */
@Data
public class ${screenId?cap_first}Bean implements Serializable {
 
    /** Serial Version UID */
    private static final long serialVersionUID = ${serialVersionUID}L;

    /** サロゲートキー */
    private String alternateKey;

    /** 選択された行のサロゲートキー */
    private String selectAlternateKey;

<#list records as record>
    <#if record.type??>
        <#if record.description??>
    /** ${record.description} */
        </#if>
    private ${record.type} ${record.itemName};

    </#if>
</#list>
    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this, ToStringStyle.DEFAULT_STYLE);
    }
}