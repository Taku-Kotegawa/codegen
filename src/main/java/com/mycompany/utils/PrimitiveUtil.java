package com.mycompany.utils;

import java.util.ArrayList;
import java.util.List;

/**
 * プリミティブ型かどうかチェックする
 * @author ksuzuki
 *
 */
public class PrimitiveUtil {

	private static List<String> primitives;
	static{
		primitives = new ArrayList<String>();
		primitives.add("byte");
		primitives.add("short");
		primitives.add("int");
		primitives.add("long");
		primitives.add("char");
		primitives.add("float");
		primitives.add("double");
		primitives.add("boolean");
	}
	
	/**
	 * プリミティブ型かどうかチェックする
	 * @param _type 型
	 * @return
	 */
	public static boolean isPrimitive(String _type) {
		if(_type == null) return false;
		if(primitives.indexOf(_type) > -1)
			return true;
		return false;
	}
}

