package com.mycompany.xlsmapper;

import com.gh.mygreen.xlsmapper.annotation.XlsColumn;

import lombok.Data;

/**
 * POJO for record mapping.
 *
 * @author stnetadmin
 */
@Data
public class ItemRecord {

	@XlsColumn(columnName = "groupName")
	String groupName;

	@XlsColumn(columnName = "value")
	String value;

	@XlsColumn(columnName = "label")
	String label;

	@XlsColumn(columnName = "labelJA")
	String labelJa;

}
