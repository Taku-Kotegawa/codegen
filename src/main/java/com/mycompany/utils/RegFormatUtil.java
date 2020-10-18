package com.mycompany.utils;

import java.util.HashMap;
import java.util.Map;

/**
 * 正規表現チェックのフォーマット変換
 * @author ksuzuki
 *
 */
public class RegFormatUtil {

	
	static Map<String, String> formats;
	static {
		formats = new HashMap<String, String>();
		formats.put("なし", null);
		formats.put("半角", "^[｡-ﾟ+a-zA-Z0-9 -/:-@\\[-\\`\\{-\\~]*$");
		formats.put("全角", "^[^ -~｡-ﾟ]*$");
		formats.put("半角数字", "^[0-9]*$");
		formats.put("半角英字", "^[a-zA-Z]*$");
		formats.put("半角英字大文字", "^[A-Z]*$");
		formats.put("半角英字小文字", "^[a-z]*$");
		formats.put("半角英数字", "^[a-zA-Z0-9]*$");
		formats.put("半角英数字記号", "^[a-zA-Z0-9 -/:-@\\[-\\`\\{-\\~]*$");
		formats.put("半角カタカナ", "^[｡-ﾟ+]*$");
		formats.put("全角英字大文字", "^[Ａ-Ｚ]*$");
		formats.put("全角英字小文字", "^[ａ-ｚ]*$");
		formats.put("全角英字", "^[ａ-ｚＡ-Ｚ]*$");
		formats.put("全角数字", "^[０-９]*$");
		formats.put("全角英数字", "^[ａ-ｚＡ-Ｚ０-９]*$");
		formats.put("全角英数字記号", "^[ａ-ｚＡ-Ｚ０-９　-＠]*$");
		formats.put("全角ひらがな", "^[ぁ-ん]*$");
		formats.put("全角カタカナ", "^[ァ-ヶ]*$");
		formats.put("全角ひらがなカタカナ", "^[ぁ-んァ-ヶ]*$");
		formats.put("年月日 (YYYYMMDD)", "^([0-9]{4})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])$");
		formats.put("年月日 (YYMMDD)", "^([0-9]{2})(0[1-9]|1[0-2])(0[1-9]|[12][0-9]|3[01])$");
		formats.put("月日 (MM/DD)", "^(0[1-9]|1[0-2])/(0[1-9]|[12][0-9]|3[01])$");
	}
	
	/**
	 * 形式タイプの正規表現を返す
	 * @param formatType 形式タイプ
	 * @return 正規表現文字列
	 */
	public static String getFormat(String _formatType) {
		return  formats.get(_formatType);
	}
}
