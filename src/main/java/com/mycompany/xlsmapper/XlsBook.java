package com.mycompany.xlsmapper;

import lombok.Data;

/**
 *
 * @author stnetadmin
 */
@Data
public class XlsBook {

	MainSheet mainSheet;
	
	ScreenItemSheet[] screenItemSheets;

	ControllerSheet controllerSheet;
	
	ItemsSheet itemsSheet;

}
