<!-- DataTables -->
<script
  src="${r"${pageContext.request.contextPath"}${r"}"}/resources/plugins/DataTablesPack/datatables.min.js"></script>
<script
  src="${r"${pageContext.request.contextPath"}${r"}"}/resources/app2/js/dataTables.js"></script>

<!-- page script -->
<script>
  $(document).ready(
    function() {
      var parentWindow = window.opener;
      reloadDataTablesAndCloseOwnWindow(parentWindow == null ? null : parentWindow.table);
    });
</script>