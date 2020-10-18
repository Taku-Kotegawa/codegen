package com.mycompany.xlsmapper;

import com.gh.mygreen.xlsmapper.XlsMapper;
import com.gh.mygreen.xlsmapper.XlsMapperException;
import java.io.FileNotFoundException;
import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;

/**
 * Return ScreenItemSheet.
 *
 * @author stnetadmin
 */
@Service
@PropertySource(value = {"classpath:application.properties"})
public class SheetMapper {

    private static final Logger logger = LoggerFactory.getLogger(SheetMapper.class);

    @Value(value = "file:${excel.screen.definition}")
    private Resource targetXlsx;

    /**
     * Return XlxBook.
     *
     * @return XlsBook.
     * @throws XlsMapperException
     * @throws IOException
     */
    public XlsBook mapping() throws XlsMapperException, IOException {
        //
        XlsBook xlsBook = new XlsBook();
        try {
            XlsMapper xlsMapper = new XlsMapper();
            ScreenItemSheet[] sheets = xlsMapper.loadMultiple(
                targetXlsx.getInputStream(),
                ScreenItemSheet.class
            );
            xlsBook.setScreenItemSheets(sheets);
        } catch (FileNotFoundException | XlsMapperException e) {
            logger.error("\n\t********** ERROR **********" + e.getLocalizedMessage());
        }

        try {
            XlsMapper xlsMapper = new XlsMapper();
            Object[] sheets = xlsMapper.loadMultiple(
                    targetXlsx.getInputStream(),
                    new Class[]{MainSheet.class, ControllerSheet.class, ItemsSheet.class}
                );
            
            xlsBook.setMainSheet((MainSheet) sheets[0]);
            xlsBook.setControllerSheet((ControllerSheet) sheets[1]);
            xlsBook.setItemsSheet((ItemsSheet) sheets[2]);

        } catch (FileNotFoundException | XlsMapperException e) {
            logger.error("\n\t********** ERROR **********" + e.getLocalizedMessage());
        }
        
        return xlsBook;
    }
}
