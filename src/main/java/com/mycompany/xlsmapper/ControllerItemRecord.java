package com.mycompany.xlsmapper;

import com.gh.mygreen.xlsmapper.annotation.XlsColumn;

import lombok.Data;

/**
 * POJO for record mapping.
 *
 * @author stnetadmin
 */
@Data
public class ControllerItemRecord {

    @XlsColumn(columnName = "controller")
    String controller;

    @XlsColumn(columnName = "url")
    String url;

    @XlsColumn(columnName = "/")
    String slash;

    @XlsColumn(columnName = "action")
    String action;

    @XlsColumn(columnName = "method")
    String method;

    @XlsColumn(columnName = "params")
    String params;

    @XlsColumn(columnName = "handler")
    String hander;

    @XlsColumn(columnName = "description")
    String description;

}
