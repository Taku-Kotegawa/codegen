package com.mycompany;

import com.mycompany.utils.PrimitiveUtil;
import com.mycompany.utils.RegFormatUtil;
import com.mycompany.xlsmapper.*;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateExceptionHandler;
import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.batch.core.configuration.annotation.EnableBatchProcessing;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.ApplicationContext;

import java.io.File;
import java.io.IOException;
import java.io.Writer;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.*;

@SpringBootApplication
@EnableAutoConfiguration
@EnableBatchProcessing
@EnableConfigurationProperties
public class Application implements CommandLineRunner {

    private static final Logger logger = LoggerFactory.getLogger(Application.class);

    @Autowired
    SheetMapper sheetMapper;

    /**
     * Application Entry Point
     *
     * @param args
     */
    public static void main(String[] args) {
        SpringApplication application = new SpringApplication(Application.class);
        application.setWebEnvironment(false);
        ApplicationContext context = application.run();
        SpringApplication.exit(context);
    }

    /**
     * Run Application
     *
     * @param args
     * @throws Exception
     */
    @Override
    public void run(String... args) throws Exception {

        logger.info("処理開始");

        // execute
        XlsBook xlsBook = sheetMapper.mapping();

        // 出力先ディレクトリの生成
        String projectRootDirPath = System.getProperty("user.dir");
        File distDir = new File(projectRootDirPath, "dist");
        if (distDir.exists())
            FileUtils.deleteDirectory(distDir);
        File srcDir = new File(projectRootDirPath, "static");
        FileUtils.copyDirectory(srcDir, distDir);

        // java用ディレクトリの生成
        File javaDir = new File(distDir, "src/main/java");
        // resouces用ディレクトリの生成
        File resourcesDir = new File(distDir, "src/main/resources");
        // properties用ディレクトリの生成
        File i18nDir = new File(resourcesDir, "i18n");
        // templates用ディレクトリの生成
        File templatesDir = new File(resourcesDir, "templates");

        // アプリケーション全体の設定 ----------------------------------------------------
        // packageの生成
        String rootPackage = xlsBook.getMainSheet().getRootPackage();
        String itemsPackage = xlsBook.getMainSheet().getItemsPackage();

        // 選択項目用クラスの配備
//        createItems(javaDir, i18nDir, xlsBook.getItemsSheet(), itemsPackage);

        // Controllerクラス,Formクラスの配備
        List<String> screenIds = new ArrayList<>();
        for (ScreenItemSheet screenItemSheet : xlsBook.getScreenItemSheets()) {
            // templateの作成
            createTmeplate(i18nDir, templatesDir, screenItemSheet);

            // bookをオブジェクトにマッピング
            String screenId = screenItemSheet.getScreenId();

            // パッケージディレクトリの作成
            String packageName = rootPackage + "." + StringUtils.lowerCase(screenId);
            File packageDir = createPackageDir(javaDir, packageName);

            screenIds.add(
                    createScreenItem(packageDir, /* i18nDir, templatesDir, */ screenItemSheet,
                            packageName/* , itemsPackage */));
            createController(packageDir, screenItemSheet, packageName, itemsPackage);
        }

        logger.info("処理終了");
    }

    /**
     * テンプレートをもとにファイルを出力する
     *
     * @param _template  テンプレートパス
     * @param _root      マッピングオブジェクト
     * @param _name      出力ファイル名
     * @param _outputDir 出力先
     * @param _fileExt   出力ファイル拡張子
     */
    private void output(String _template, Map<String, Object> _root, String _name, File _outputDir, String _fileExt) {

        Writer out = null;
        try {
            ClassLoader classLoader = getClass().getClassLoader();

            // コンフィグレーション
            Configuration cfg = new Configuration(Configuration.VERSION_2_3_25);
            // テンプレート置き場
            cfg.setDirectoryForTemplateLoading(new File(classLoader.getResource("templates").getFile()));
            // Encode
            cfg.setDefaultEncoding("UTF-8");
            // Exception発生時の動作
            cfg.setTemplateExceptionHandler(TemplateExceptionHandler.RETHROW_HANDLER);

            // テンプレートを読み込み
            Template temp = cfg.getTemplate(_template);

            Path path = Paths.get(new File(_outputDir, _name + _fileExt).getPath());
            try (Writer writer = Files.newBufferedWriter(path, StandardCharsets.UTF_8)) {
                temp.process(_root, writer);
            }

        } catch (Exception e) {
            logger.error("エラー：" + e.getMessage());
        } finally {
            if (out != null) {
                try {
                    out.close();
                } catch (IOException e) {
                }
            }
        }
    }

    /**
     * 選択用項目定義を配備する
     *
     * @param _outputDir     出力先(クラス)
     * @param _outputI18nDir 出力先(リソース)
     * @param _itemsSheet    項目定義シート
     * @param _packageName   パッケージ名
     */
    private void createItems(File _outputDir, File _outputI18nDir, ItemsSheet _itemsSheet, String _packageName) {
        File logicPackageDir = createPackageDir(_outputDir, _packageName);

        Map<String, Map<String, String>> map = new HashMap<>();

        for (ItemRecord itemRecord : _itemsSheet.getItemRecord()) {
            Map<String, String> group = map.get(itemRecord.getGroupName());
            if (group == null)
                group = new HashMap<>();
            group.put(itemRecord.getValue(), itemRecord.getLabel());
            map.put(itemRecord.getGroupName(), group);
        }

        for (Map.Entry<String, Map<String, String>> entry : map.entrySet()) {
            Map<String, Object> model = new HashMap<String, Object>();
            String itemsName = entry.getKey();
            String className = StringUtils.capitalize(entry.getKey()) + "Service";
            model.put("package", _packageName);
            model.put("className", className);
            model.put("itemsName", itemsName);
            model.put("items", entry.getValue());
            output("java/logic/itemservice.ftlh", model, className, logicPackageDir, ".java");
        }

        Map<String, Object> model = new HashMap<String, Object>();
        model.put("records", _itemsSheet.getItemRecord());
        output("properties/items_message.ftlh", model, "items", _outputI18nDir, ".properties");
        output("properties/items_messageja.ftlh", model, "items_ja", _outputI18nDir, ".properties");
    }

    /**
     * 画面定義に付随するtmeplateを配備する
     *
     * @param _outputI18nDir      出力先（リソース）
     * @param _outputTemplatesDir 出力先（テンプレート）
     * @param _screenItemSheet    画面定義設定シート
     * @return 画面定義ID
     */
    private String createTmeplate(File _outputI18nDir, File _outputTemplatesDir, ScreenItemSheet _screenItemSheet) {

        // bookをオブジェクトにマッピング
        String screenId = _screenItemSheet.getScreenId();
        List<ScreenItemRecord> screenItemRecord = _screenItemSheet.getScreenItemRecord();
        String screenName = _screenItemSheet.getScreenName();

        // テンプレート差し込み用modelの構築
        Map<String, Object> root = new HashMap<String, Object>();
        root.put("screenId", screenId);
        root.put("records", screenItemRecord);
        root.put("screenName", screenName);

        // properties生成
//        output("properties/form_message.ftlh", root, screenId.toLowerCase(), _outputI18nDir, ".properties");
//        output("properties/form_messageja.ftlh", root, screenId.toLowerCase(), _outputI18nDir, "_ja.properties");
//        output("properties/application_message.ftlh", root, "application_message_" + screenId.toLowerCase(),
//                _outputI18nDir, ".properties");

        // テンプレート用ディレクトリの生成
        File templateOutputDir = createPackageDir(_outputTemplatesDir, screenId);

        // update用URLの{ID}部分の生成
        StringBuffer updateUrlId = new StringBuffer();
        for (ScreenItemRecord rec : screenItemRecord) {
            String itemName = rec.getItemName();
            String key = rec.getKey();
            if (itemName != null && itemName.length() > 0) {
                if (key != null && key.length() > 0) {
                    if (updateUrlId.length() > 0) {
                        updateUrlId.setLength(0);
                        updateUrlId.append("${alternateKey}");
                    } else {
                        updateUrlId.append("${");
                        updateUrlId.append(itemName);
                        updateUrlId.append("}");
                    }
                }
            }
        }
        root.put("updateUrlId", updateUrlId.toString());

        // terasolna ver.
        output("jsp/list.ftlh", root, "list", templateOutputDir, ".jsp");
        // output("jsp/listall.ftlh", root, "listAll", templateOutputDir,
        // ".jsp");
        output("jsp/create.ftlh", root, "form", templateOutputDir, ".jsp");
        // output("jsp/createConfirm.ftlh", root, "createConfirm",
        // templateOutputDir, ".jsp");
        // output("jsp/createComplete.ftlh", root, "createComplete",
        // templateOutputDir, ".jsp");
        // output("jsp/info.ftlh", root, "info", templateOutputDir, ".jsp");
        // output("jsp/update.ftlh", root, "form", templateOutputDir, ".jsp");
        // output("jsp/updateConfirm.ftlh", root, "updateConfirm",
        // templateOutputDir, ".jsp");
        // output("jsp/updateComplete.ftlh", root, "updateComplete",
        // templateOutputDir, ".jsp");
        // output("jsp/deleteComplete.ftlh", root, "deleteComplete",
        // templateOutputDir, ".jsp");
        // output("jsp/import.ftlh", root, "importForm", templateOutputDir, ".jsp");
        // output("jsp/complete.ftlh", root, "completeForm", templateOutputDir, ".jsp");

        return screenId;
    }

    /**
     * 画面定義に付随するクラスを配備する
     *
     * @param _packageDir      出力先（クラス）
     * @param _screenItemSheet 画面定義設定シート
     * @param _packageName     配備先パッケージ名
     * @return 画面定義ID
     */
    private String createScreenItem(File _packageDir, ScreenItemSheet _screenItemSheet, String _packageName) {

        // bookをオブジェクトにマッピング
        String screenId = _screenItemSheet.getScreenId();
        List<ScreenItemRecord> screenItemRecord = _screenItemSheet.getScreenItemRecord();

        // データモデル
        List<String> importsForForm = new ArrayList<String>();
        importsForForm.add("java.lang.String");

        // キー列の項目名
        String keyName = "";

        // screenItem シート内容検証
        // logger.debug("ScreenId:{}, ScreenName:{}", screenId, screenName);
        for (ScreenItemRecord rec : screenItemRecord) {
            // importの追加
            if (importsForForm.indexOf(rec.getType()) < 0) {
                if (!PrimitiveUtil.isPrimitive(rec.getType()))
                    importsForForm.add(rec.getType());
            }

            // 型からパッケージを除去
            String type = rec.getType();
            int point = type.lastIndexOf(".");
            if (point > -1) {
                type = type.substring(point + 1);
                rec.setType(type);
            }

            // 形式タイプから正規表現フォーマットを設定
            String format = null;
            String formatType = rec.getFormatType();
            if (formatType != null) {
                if (!"".equals(formatType) && !FormatType.なし.name().equals(formatType)) {
                    format = RegFormatUtil.getFormat(formatType);
                    if (format != null)
                        format = format.replaceAll("\\\\", "\\\\\\\\");
                    rec.setRegex(format);
                }
            } else {
                format = rec.getRegex();
                if (format != null)
                    format = format.replaceAll("\\\\", "\\\\\\\\");
                rec.setRegex(format);
            }

            if (format != null && !"String".equals(type)) {
                logger.warn("String以外の属性に形式Validateが指定されています。");
            }

            // キー項目の退避
            if (rec.getKey() != null && "○".equals(rec.getKey())) {
                if (keyName.length() > 0) {
                    keyName = "alternateKey";
                } else {
                    keyName = rec.getItemName();
                }
            }
        }

        // テンプレート差し込み用modelの構築
        String screenName = _screenItemSheet.getScreenName();
        Map<String, Object> root = new HashMap<String, Object>();
        root.put("package", _packageName);
        root.put("screenName", screenName);
        root.put("screenId", screenId);
        root.put("imports", importsForForm);
        root.put("records", screenItemRecord);
        root.put("serialVersionUID", generateUID());
        root.put("keyName", keyName);

        // 固有Form生成
//        output("java/form/bean.ftlh", root, StringUtils.capitalize(screenId) + "Bean", _packageDir, ".java");
        output("java/form/form.ftlh", root, StringUtils.capitalize(screenId) + "Form", _packageDir, ".java");
//        output("java/form/create.ftlh", root, StringUtils.capitalize(screenId) + "CreateForm", _packageDir, ".java");
//        output("java/form/update.ftlh", root, StringUtils.capitalize(screenId) + "UpdateForm", _packageDir, ".java");
//        output("java/form/delete.ftlh", root, StringUtils.capitalize(screenId) + "DeleteForm", _packageDir, ".java");
//        output("java/form/criteria.ftlh", root, StringUtils.capitalize(screenId) + "SearchCriteriaForm", _packageDir, ".java");
        output("java/form/listRow.ftlh", root, StringUtils.capitalize(screenId) + "ListRow", _packageDir, ".java");
//        output("java/form/import.ftlh", root, StringUtils.capitalize(screenId) + "ImportForm", _packageDir, ".java");
        output("java/form/csvBean.ftlh", root, StringUtils.capitalize(screenId) + "CsvBean", _packageDir, ".java");
//        output("java/form/csvView.ftlh", root, StringUtils.capitalize(screenId) + "CsvFileDownloadView", _packageDir, ".java");
//        output("java/form/excelBean.ftlh", root, StringUtils.capitalize(screenId) + "ExcelBean", _packageDir, ".java");
//        output("java/form/excelView.ftlh", root, StringUtils.capitalize(screenId) + "ExcelFileDownloadView",
//                _packageDir, ".java");

        return screenId;
    }

    /**
     * コントローラークラスを配備する
     *
     * @param _packageDir      出力先（クラス）
     * @param _screenItemSheet 画面定義設定シート
     * @param _packageName     配備先パッケージ名
     * @param _itemsPackage    選択用項目の配備先パッケージ名
     * @return 画面定義ID
     */
    private String createController(File _packageDir, ScreenItemSheet _screenItemSheet, String _packageName,
                                    String _itemsPackage) {

        // import
        List<String> imports = new ArrayList<String>();
        // autowired
        List<String> items = new ArrayList<String>();

        // bookをオブジェクトにマッピング
        String screenId = _screenItemSheet.getScreenId();
        String screenName = _screenItemSheet.getScreenName();
        List<ScreenItemRecord> screenItemRecord = _screenItemSheet.getScreenItemRecord();

        // キー列の項目名
        String keyName = "";

        // screenItem シート内容検証
        // logger.debug("ScreenId:{}, ScreenName:{}", screenId, screenName);
        for (ScreenItemRecord rec : screenItemRecord) {
            // importの追加
            if (rec.getGroupName() != null && rec.getGroupName().length() > 0) {
                String groupName = rec.getGroupName();
                String work = _itemsPackage + "." + StringUtils.capitalize(groupName) + "Service";
                if (items.indexOf(groupName) < 0) {
                    items.add(groupName);
                    imports.add(work);
                }
            }

            // キー項目の退避
            if (rec.getKey() != null && "○".equals(rec.getKey())) {
                if (keyName.length() > 0) {
                    keyName = "alternateKey";
                } else {
                    keyName = rec.getItemName();
                }
            }
        }

        // Controller
        String className = StringUtils.capitalize(screenId) + "Controller";

        // テンプレート差し込み用modelの構築
        Map<String, Object> root = new HashMap<String, Object>();
        root.put("package", _packageName);
        root.put("className", className);
        root.put("classNameJp", screenName);
        root.put("screenId", screenId);
        root.put("imports", imports);
        root.put("items", items);
        root.put("keyName", keyName);

        // 固有Controller生成
        output("java/controller/controller.ftlh", root, className, _packageDir, ".java");

        return screenId;
    }

    /**
     * パッケージからディレクトリを生成する
     *
     * @param _outputRootDirPath 生成先ルートパス
     * @param _packageNames      javaパッケージ名
     * @return
     */
    private File createPackageDir(File _outputDir, String _packageName) {
        File newDir = new File(_outputDir.getPath());
        if (_packageName == null)
            return newDir;
        if (".".equals(_packageName))
            return newDir;

        String[] packageNames = _packageName.split("\\.");
        for (String packageName : packageNames) {
            newDir = new File(newDir, packageName);
            if (!newDir.exists())
                newDir.mkdir();
        }
        return newDir;
    }

    /**
     * Serial Version UIDを生成する
     *
     * @return
     */
    private String generateUID() {
        // Randomクラスのインスタンス化
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder();
        sb.append(rnd.nextInt(9));
        for (int i = 0; i < 18; i++) {
            sb.append(rnd.nextInt(10));
        }
        return String.valueOf(Long.parseLong(sb.toString()));
    }
}
