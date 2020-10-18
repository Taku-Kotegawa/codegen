package com.mycompany.xlsmapper;


import com.gh.mygreen.xlsmapper.annotation.LabelledCellType;
import com.gh.mygreen.xlsmapper.annotation.XlsLabelledCell;
import com.gh.mygreen.xlsmapper.annotation.XlsSheet;

import lombok.Data;

/**
 * POJO for mapping sheet.
 *
 * @author stnetadmin
 */
@XlsSheet(name = "main")
@Data
public class MainSheet {

	@XlsLabelledCell(label = "パッケージ（root）", type = LabelledCellType.Right, skip = 1)
	String rootPackage;

	@XlsLabelledCell(label = "パッケージ（items）", type = LabelledCellType.Right, skip = 1)
	String itemsPackage;
}
