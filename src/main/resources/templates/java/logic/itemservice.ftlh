package ${package};

import java.util.Locale;
import java.util.Map;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.stereotype.Component;

import jp.or.biken.base.common.util.StringUtils;

/**
 * ${className}
 * @author Automatically generated
 *
 */
@Component
public class ${className} implements inputItemsInterface {

    private Map<String, String> items;

    @Autowired
    MessageSource messageSource;

    public void setItems() {
        Locale locale = LocaleContextHolder.getLocale();
        items = new HashMap<>();

<#list items as key, value> 
        items.put("${key}", messageSource.getMessage("items.${itemsName?lower_case}.${value?lower_case}", null, locale));
</#list>
    }

    /**
     * 画面項目用のMapを返す
     * @return 画面項目用のMap
     */
    public Map<String, String> getInputItems() {
        // TODO キャッシュ
        setItems();
        Map<String, String> inputItems = new HashMap<>();

        for (String code : items.keySet()) {
            inputItems.put(code, StringUtils.concatCodeName(code, items.get(code)));
        }

        return inputItems;
    }
}
