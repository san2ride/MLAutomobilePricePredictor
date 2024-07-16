import Cocoa
import TabularData


let fileURL = Bundle.main.url(forResource: "carvana", withExtension: "csv")!
let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")

let formattingOptions = FormattingOptions(maximumLineWidth: 250, maximumCellWidth: 250, maximumRowCount: 100, includesColumnTypes: true)

let dataFrame = try DataFrame(contentsOfCSVFile: fileURL, options: options)
print(dataFrame.description(options: formattingOptions))

