/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # Encoder and Decoder customization
import Foundation

let encoder = JSONEncoder()

//: ### Output formatting
//: Human-readable JSON with indented output:
encoder.outputFormatting = .prettyPrinted

//: Keys sorted in lexicographic (alphabetic) order:
encoder.outputFormatting = .sortedKeys

//: ### Encoding (and decoding) Date
//: Formatting used by the Date type:
encoder.dateEncodingStrategy = .deferredToDate
/*:
    {
        date = "544477449.093259";
    }
*/

encoder.dateEncodingStrategy = .iso8601
/*:
    {
        date = "2018-04-03T19:46:52Z";
    }
*/

encoder.dateEncodingStrategy = .millisecondsSince1970
encoder.dateEncodingStrategy = .secondsSince1970
/*:
    {
        date = "1522784861.46883";
    }
 */

//: Use custom DateFormatter:
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "dd-MMM-yyyy"

encoder.dateEncodingStrategy = .formatted(dateFormatter)

struct 🗓: Codable {
    let date: Date
}

let today = 🗓(date: Date(timeIntervalSinceNow: 0))
let todayData = try encoder.encode(today)
let todayJSON = try JSONSerialization.jsonObject(with: todayData)

/*:
 * Callout(Update for Swift 4.1):
 Swift 4.1 adds new properties to JSONDecoder and JSONEncoder: `keyDecodingStrategy` and `keyEncodingStrategy` respectively.\
 Those properties allow convertion between snake case (`snake_case`) and camel case (`camelCase`) without writing custom implemantaion of CodingKeys.
 */
//: ### Encoding (and decoding) exceptional numbers (like infinity ∞)
//: Throw error:
encoder.nonConformingFloatEncodingStrategy = .throw

//: Convert to string:
encoder.nonConformingFloatEncodingStrategy = .convertToString(positiveInfinity: "+inf+", negativeInfinity: "-inf-", nan: "NaN")

struct allNumbers: Codable {
    let count: Float
}

let infinity = allNumbers(count: .infinity)
let infinityData = try encoder.encode(infinity)
let infinityJSON = try JSONSerialization.jsonObject(with: infinityData)

//: # Property List Encoder and Decoder
let plistEncoder = PropertyListEncoder()

plistEncoder.outputFormat = .openStep
plistEncoder.outputFormat = .binary
plistEncoder.outputFormat = .xml

let todayPlistData = try plistEncoder.encode(today)
try PropertyListSerialization.propertyList(from: todayPlistData, options: .mutableContainers, format: nil)

let plistDecoder = PropertyListDecoder()

if let myCalendarFilePath = Bundle.main.path(forResource: "MyCalendar", ofType: "plist"),
    let myCalendarData = FileManager.default.contents(atPath: myCalendarFilePath) {

    try plistDecoder.decode(🗓.self, from: myCalendarData)
}

/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */
