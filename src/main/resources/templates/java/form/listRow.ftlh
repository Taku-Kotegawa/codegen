package ${package};

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Map;

import java.io.Serializable;
import java.time.LocalDateTime;

<#list imports as import>
import ${import};
</#list>

/**
 * ${screenName}管理の一覧の行のBean
 * @author Automatically generated
 *
 */
@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ${screenId?cap_first}ListRow implements Serializable {
 
    /**
     * Serial Version UID
     */
    private static final long serialVersionUID = ${serialVersionUID}L;

    /**
     * 操作
     */
    private String operations;

    /**
     * DataTables RowID
     */
    private String DT_RowId;

    /**
     * DataTables RowClass
     */
    private String DT_RowClass;

    /**
     * DataTables RT_RowAttr
     */
    private Map<String, String> DT_RowAttr;

    /**
     * 最終更新日
     */
    @JsonFormat(pattern = "yyyy/MM/dd HH:mm:ss")
    private LocalDateTime lastModifiedDate;

    @JsonProperty("DT_RowId")
    public String getDT_RowId() {
        return id.toString();
    }

    @JsonProperty("DT_RowClass")
    public String getDT_RowClass() {
        return DT_RowClass;
    }

    @JsonProperty("DT_RowAttr")
    public Map<String, String> getDT_RowAttr() {
        return DT_RowAttr;
    }

<#list records as record>
    <#if record.type?? && record.useItemForList??>
    <#if record.description??>
    /**
     * ${record.description}
     */
    </#if>
    <#switch record.type>
    <#case "LocalDateTime">
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy/MM/dd hh:mm")<#break>
    <#case "LocalDate">
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy/MM/dd")<#break>
    </#switch>
    private ${record.type} ${record.itemName};

    </#if>
</#list>
}