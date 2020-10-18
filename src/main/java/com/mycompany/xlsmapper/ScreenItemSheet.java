package com.mycompany.xlsmapper;

import java.util.List;

import com.gh.mygreen.xlsmapper.annotation.LabelledCellType;
import com.gh.mygreen.xlsmapper.annotation.XlsHorizontalRecords;
import com.gh.mygreen.xlsmapper.annotation.XlsLabelledCell;
import com.gh.mygreen.xlsmapper.annotation.XlsSheet;

import lombok.Data;

/**
 * POJO for mapping sheet.
 *
 * @author stnetadmin
 */
@XlsSheet(regex = "screenId.*")
@Data
public class ScreenItemSheet {

	@XlsLabelledCell(label = "画面定義ID", type = LabelledCellType.Right, skip = 1)
	String screenId;

	@XlsLabelledCell(label = "画面定義名称", type = LabelledCellType.Right, skip = 1)
	String screenName;

	@XlsLabelledCell(label = "Eventごとの入力検証", type = LabelledCellType.Right, skip = 1)
	String eventValidatation;

	@XlsHorizontalRecords(tableLabel = "画面項目定義・一覧", bottom = 3)
	List<ScreenItemRecord> screenItemRecord;

}
