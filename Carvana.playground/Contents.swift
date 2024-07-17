import Cocoa
import TabularData
import CreateML

let fileURL = Bundle.main.url(forResource: "carvana", withExtension: "csv")!
let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")

let formattingOptions = FormattingOptions(maximumLineWidth: 250, maximumCellWidth: 250, maximumRowCount: 20, includesColumnTypes: true)

let dataFrame = try DataFrame(contentsOfCSVFile: fileURL, options: options)

let dataFrameUnder60KMiles = dataFrame.filter(on: "Miles", Int.self) { miles in
    guard let miles = miles else { return false }
    return miles <= 60000
}

print(dataFrameUnder60KMiles.description(options: formattingOptions))

let regressor = try MLLinearRegressor(trainingData: dataFrame, targetColumn: "Price")

let metaData = MLModelMetadata(author: "Jason Sanchez",
                               shortDescription: "Carvana Model",
                               license: nil, version: "1.0",
                               additional: nil)
// try regressor.write(toFile: "/Users/jasonspro/Develop/MLAutomobilePricePredictor/Carvana.mlmodel", metadata: metaData)
