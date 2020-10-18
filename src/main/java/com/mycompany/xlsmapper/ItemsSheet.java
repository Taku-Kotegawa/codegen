package com.mycompany.xlsmapper;

import java.util.List;

import com.gh.mygreen.xlsmapper.annotation.XlsHorizontalRecords;
import com.gh.mygreen.xlsmapper.annotation.XlsSheet;

import lombok.Data;

/**
 * POJO for mapping sheet.
 *
 * @author stnetadmin
 */
@XlsSheet(name = "items")
@Data
public class ItemsSheet {

	@XlsHorizontalRecords(tableLabel = "選択項目用定義・一覧", bottom = 3)
	List<ItemRecord> itemRecord;

}
