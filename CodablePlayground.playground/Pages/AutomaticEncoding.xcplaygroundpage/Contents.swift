/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
*/
//: # Automatic Encoding
import Foundation

struct Retailer: Codable {
    let name: String
    let website: URL?
    let founded: Date?
}

struct Vegetable: Codable {
    let identifier: UUID
    let name: String?
    let isDelicious: Bool
    let imagesURLs: [URL]?
    let nutrition: [String: Float]
    let availability: [Retailer]?
    let kingdom: String = "Plantae"
}

/*:
  You **can** declare custom `CodingKeys` object (typically an enumerator) with list of properties that must be included when instances of a codable type are encoded or decoded.

  - Important: About CodingKeys:\
  _1. CodingKeys enum has Raw Type `String` and conforms to `CodingKey` protocol\
  _2. Names of cases must match names of properties\
  _3. Properties you want to omit from encoding/decoding need to have default value\
  _4. To use custom keys for serialized data provide them as enum's raw values

    To convert keys between snake case (`snake_case`) and camel case (`camelCase`) you can just use `JSONEncoder`'s `keyEncodingStrategy` and set it to `convertToSnakeCase`
*/

extension Vegetable {

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case isDelicious
        case imagesURLs = "images"
        case nutrition
        case availability
    }
}

let nearbyFamilyStore = Retailer(name: "StoreNo1", website: nil, founded: Date(timeIntervalSince1970: 1522324117))

let vegy = Vegetable(identifier: UUID(),
                     name: "Brocoli 🥦",
                     isDelicious: true,
                     imagesURLs: [URL(string: "http://harisabzi.com/wp-content/uploads/2017/10/Brocoli.jpg")!],
                     nutrition: ["protein": 5],
                     availability: [nearbyFamilyStore])

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
encoder.dateEncodingStrategy = .secondsSince1970
encoder.keyEncodingStrategy = .convertToSnakeCase

let data = try encoder.encode(vegy)
let JSON = try JSONSerialization.jsonObject(with: data)

print(JSON)

/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */
