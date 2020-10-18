package com.mycompany.xlsmapper;

import com.gh.mygreen.xlsmapper.annotation.XlsColumn;

import lombok.Data;

/**
 * POJO for record mapping.
 *
 * @author stnetadmin
 */
@Data
public class ScreenItemRecord {

    @XlsColumn(columnName = "no")
    int no;

    @XlsColumn(columnName = "itemName")
    String itemName;

    @XlsColumn(columnName = "itemNameJA")
    String itemNameJa;

    @XlsColumn(columnName = "description")
    String description;

    @XlsColumn(columnName = "itemType")
    String itemType;

    @XlsColumn(columnName = "type")
    String type;

    @XlsColumn(columnName = "groupName")
    String groupName;

    @XlsColumn(columnName = "useItemForList")
    String useItemForList;

    @XlsColumn(columnName = "inputItemForList")
    String inputItemForList;

    @XlsColumn(columnName = "useItemForDetail")
    String useItemForDetail;

    @XlsColumn(columnName = "useItemForCreate")
    String useItemForCreate;

    @XlsColumn(columnName = "inputItemForCreate")
    String inputItemForCreate;

    @XlsColumn(columnName = "useItemForUpdate")
    String useItemForUpdate;

    @XlsColumn(columnName = "inputItemForUpdate")
    String inputItemForUpdate;

    @XlsColumn(columnName = "useItemForExport")
    String useItemForExport;

    @XlsColumn(columnName = "useItemForImport")
    String useItemForImport;

    @XlsColumn(columnName = "inputItemForImport")
    String inputItemForImport;

    @XlsColumn(columnName = "specifiedValue")
    String specifiedValue;

    @XlsColumn(columnName = "isSubmit")
    String isSubmit;

    @XlsColumn(columnName = "isToken")
    String isToken;

    @XlsColumn(columnName = "checkMethod")
    String checkMethod;

    @XlsColumn(columnName = "key")
    String key;

    @XlsColumn(columnName = "require")
    String require;
    @XlsColumn(columnName = "formatType")
    String formatType;

    @XlsColumn(columnName = "regex")
    String regex;

    @XlsColumn(columnName = "messageCode")
    String messageCode;

    @XlsColumn(columnName = "minLength")
    String minLength;

    @XlsColumn(columnName = "maxLength")
    String maxLength;

    @XlsColumn(columnName = "digitPattern")
    String digitPattern;

    @XlsColumn(columnName = "min")
    String min;

    @XlsColumn(columnName = "max")
    String max;

    @XlsColumn(columnName = "inputFormat")
    String inputFormat;

    @XlsColumn(columnName = "annotation")
    String annotation;

    @XlsColumn(columnName = "existInCodeList")
    String existInCodeList;

}
