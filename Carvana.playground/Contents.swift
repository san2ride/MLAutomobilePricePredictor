import Cocoa
import TabularData
import CreateML

let fileURL = Bundle.main.url(forResource: "carvana", withExtension: "csv")!
let options = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")

let formattingOptions = FormattingOptions(maximumLineWidth: 250, 
                                          maximumCellWidth: 250,
                                          maximumRowCount: 100,
                                          includesColumnTypes: true)

let calendar = Calendar.current
let currentYear = calendar.component(.year, from: Date())

let dataFrame = try DataFrame(contentsOfCSVFile: fileURL, options: options)

let dataSliceUnder60KMiles = dataFrame.filter(on: "Miles", Int.self) { miles in
    guard let miles = miles else { return false }
    return miles <= 60000
}

let dataSliceLessThan5YearsOld = dataSliceUnder60KMiles.filter(on: "Year", Int.self) { year in
    guard let year = year else { return false }
    return currentYear - Int(year) >= 0 && currentYear - Int(year) <= 5
}

let dataSliceToyotaAndJeep = dataSliceLessThan5YearsOld.filter(on: "Name", String.self) { name in
    guard let name = name else { return false}
    return name.contains("Toyota") || name.contains("Jeep")
}

print(dataSliceToyotaAndJeep.description(options: formattingOptions))

let carvanaDataFrame = DataFrame(dataSliceToyotaAndJeep)

let regressor = try MLLinearRegressor(trainingData: dataFrame, targetColumn: "Price")

let metaData = MLModelMetadata(author: "Jason Sanchez",
                               shortDescription: "Carvana Model",
                               license: nil,
                               version: "1.0",
                               additional: nil)

try regressor.write(toFile: "/Users/jasonspro/Develop/MLAutomobilePricePredictor/Carvana.mlmodel", metadata: metaData)

let nameDataFrame = carvanaDataFrame.selecting(columnNames: ["Name"])
let nameColumnSlice = nameDataFrame["Name"].distinct()
let uniqueNames: [String] = nameColumnSlice.compactMap {
    ($0 as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
}

let nameColumn = Column(name: "name", contents: uniqueNames)

var uniqueNameDataFrame = DataFrame()
uniqueNameDataFrame.append(column: nameColumn)

print(uniqueNameDataFrame)

//try uniqueNameDataFrame.writeJSON(to: URL(fileURLWithPath: "/Users/jasonspro/Develop/MLAutomobilePricePredictor/CarNames.json"))
