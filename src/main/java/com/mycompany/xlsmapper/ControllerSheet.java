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
@XlsSheet(name = "controller")
@Data
public class ControllerSheet {

	@XlsHorizontalRecords(tableLabel = "コントローラ", bottom = 1)
	List<ControllerItemRecord> controllerItemRecord;

}
