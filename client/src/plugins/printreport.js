import { saveAs } from 'file-saver'

function printExcel(data, filename, options) {
     const Excel = require('exceljs')
     const { Parser } = require('json2csv')

     let value = data
     let blobData = null
     const parser = new Parser()
     const csv = parser.parse(value)
     
     let headers = []
     let details = []
     let workbook = new Excel.Workbook()
     let worksheet = workbook.addWorksheet('Employees')
     // format excel
     let fillOption = { type: 'pattern', pattern: 'solid', fgColor: { argb:'FFFFFF00' }} 
     let borderCols = {top: {style:'thin'}, left: {style:'thin'},  bottom: {style:'thin'}, right: {style:'thin'}}

    // Convert data into JSON format
     data.forEach((rec, index) => {
          if(index == 0) {
               headers = Object.keys(rec)
          }
          details.push(Object.values(rec))
     })

     //Excel Headers
     const row = worksheet.getRow(1)
     headers.forEach((rec, index) => {
          row.getCell(index + 1).value = rec.toUpperCase()
          row.getCell(index + 1).fill = fillOption
          row.getCell(index + 1).border = borderCols
          row.getCell(index + 1).font = { bold: true }
          row.getCell(index + 1).alignment = { vertical: 'center', horizontal: 'center' }
          worksheet.getColumn(index + 1).width = rec.length < 12 ? 12 : rec.length
     })   

     // Excel Rows
     details.forEach((rec, index) => {
          const row = worksheet.getRow(index + 2)
          rec.forEach((value, index) => {
               row.getCell(index + 1).value = value
               row.getCell(index + 1).border = borderCols
               row.getCell(index + 1).alignment = { vertical: 'center', horizontal: 'center' }
               worksheet.getColumn(index + 1).width = 12
          })
     }) 

     switch (options) {
          case 'xls':
               workbook.xlsx.writeBuffer().then(data => {
                    let blob = new Blob([data], {type: "application/vnd.ms-excel;charset=utf-8"})
                    saveAs(blob, filename)
               })
               break;
     
          default:
               blobData = new Blob([csv], {type: "text/plain;charset=utf-8"})
               saveAs(blobData, filename)
               break;
     }

}

export default printExcel