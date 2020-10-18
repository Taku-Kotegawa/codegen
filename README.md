codegen-SpringMVC
===============

for Spring MVC Application (TERASOLUNA Version)

### masterからの変更点
* itemのラベル取得用キーを変更
* screenDefinitionTemplate.xlsxを変更
    * 型を追加
        * Long
        * LocalDate
        * LocalDateTime
* 以下の画面のみ作成するように変更
    * 一覧画面
    * 新規登録画面
    * 編集画面
* 必須項目の場合、Stringは@NotEmpty、それ以外は@NotNullを出力するように変更
