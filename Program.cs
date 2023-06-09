using DevExpress.Spreadsheet;

using (var workbook = new Workbook())
{
    workbook.LoadDocument("ClusterTemplate.xlsx");
    var workSheet = workbook.Worksheets[0];

    workSheet.Cells["B2"].Value = "hello world!";

    workSheet.Cells["A2"].Value = DateTime.Now;

    workbook.SaveDocument("test.xlsx");
}