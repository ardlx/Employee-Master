import filesaver from 'file-saver'

function exportExcel(data, filename) {
    let strTableHeader = ''
    let strTableDetails = ''

    // Get Table Headers
    let objKeys = Object.keys(data[0])
    objKeys.forEach(rec => {
        strTableHeader += `<td height=36 style="background:#969696;font-size:10.0pt;height:27.0pt;width:100pt;font-weight: bold;border:thin solid black;">${rec}</td>`
    })
    strTableHeader = `<tr height=18 style='height:13.5pt; text-align:center;'>${strTableHeader}</tr>`

    // Loop through, add tr tags to each row, add td tags to each cell
    data.forEach(rec => {
        strTableDetails +="<tr style='text-align:center;'>";
        Object.values(rec).forEach(item => {
            strTableDetails +=`<td border: thin solid black">${item + '\t'}</td>`;
        })
        strTableDetails +='</tr>';
    })


    // console.log(`${strTableHeader}${strTableDetails},${filename}`);
    //Worksheet name
    let uri = 'data:application/vnd.ms-excel;base64,';

    //Downloaded form template data
    let template = `<html xmlns:o="urn:schemas-microsoft-com:office:office"
        xmlns:x="urn:schemas-microsoft-com:office:excel"
        xmlns="http://www.w3.org/TR/REC-html40">
        <head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet>
        <x:Name>${filename}</x:Name>
        <x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet>
        </x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]-->
        </head><body><table>${strTableHeader}${strTableDetails}</table></body></html>`;

    //Download template
    filesaver.saveAs(uri + base64(template), `${filename}.xls`, true)
}

// output base64 encoding
function base64(s) { 
    return window.btoa(unescape(encodeURIComponent(s))) 
}

export default exportExcel