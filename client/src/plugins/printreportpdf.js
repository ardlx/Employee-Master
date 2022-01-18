function printData(header, data, image) {
    let headerFields = []
    let detailsBody = []
    let docDefinition = {}
    let pdfMake = require('pdfmake/build/pdfmake.js')
    if (pdfMake.vfs == undefined){
        let pdfFonts = require('pdfmake/build/vfs_fonts.js')
        pdfMake.vfs = pdfFonts.pdfMake.vfs;
    }
    
    // Format headers
    header.forEach(rec => {
        headerFields.push({
            text: rec.value,
            style: 'tableHeader'
        })
    })

    //content
    docDefinition = {
        pageSize: 'A4',
        pageOrientation: 'landscape',
        pageMargins: [ 40, 60, 40, 60 ],
        content: [
            {text: 'Results', style: 'header'},
            {
				headerRows: 1,
                style: 'tableExample', 
				widths: ['*', 'auto'],
                table: {
                    body: [
                        headerFields
                    ]
                }
            },
        ],
        styles: {
            header: {
                fontSize: 18,
                bold: true,
                margin: [0, 0, 0, 10]
            },
            subheader: {
                fontSize: 16,
                bold: true,
                margin: [0, 10, 0, 5]
            },
            tableExample: {
                fontSize: 10,
                margin: [0, 5, 0, 15]
            },
            tableHeader: {
                bold: true,
                fontSize: 10,
                color: 'black'
            }
        },
    }

    // Get details based on headers
    data.forEach(rec => {
        headerFields.forEach(val => {
            detailsBody.push(rec[val.text])
        })
        docDefinition.content[1].table.body.push(detailsBody)
        detailsBody = []
    })

    // Insert Chart 
    if(image) {
        docDefinition.content.push({
            image: image,
            width: 750,
            height: 350
        })
    }

    window.open(pdfMake.createPdf(docDefinition).open(), '_blank')
}

export default printData