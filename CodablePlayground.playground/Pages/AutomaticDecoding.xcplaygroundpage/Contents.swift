/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # Automatic Decoding
import Foundation

let fruitData = """
{
  "id": "E621E1F8-C36C-495A-93FC-0C247A3E6E5F",
  "name": "Banana",
  "is_delicious": true,
  "images": [
    "http://www.whats4eats.com/files/ingredients-green-bananas-bunch-wikimedia-Rosendahl-4x3.jpg",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRAthibvroFTdhqMUvC5IWFaxO1VyAfcxGj6L8mWzxPm3uzeFc0Pg"
  ],
  "nutrition": {
    "carbs": 23,
    "protein": 1.1
  },
  "availability": [
    {
      "name": "Grocery Store"
    },
    {
      "name": "Mega Store",
      "founded": 1522324117
    }
  ]
}
""".data(using: .utf8)!

struct Vegetable: Decodable {
    let identifier: UUID
    let name: String?
    let isDelicious: Bool
    let imagesURLs: [URL]?
    let nutrition: [String: Float]
    let availability: [Retailer]?
}

struct Retailer: Decodable {
    let name: String
    let website: URL?
    let founded: Date?
}

extension Vegetable {

/*:
- Note: Custom CodingKeys, if needed.\
To convert keys between snake case (snake_case) and camel case (camelCase) you can just use `JSONDecoder`'s `keyDecodingStrategy` and set it to `convertFromSnakeCase`
 */
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case isDelicious
        case imagesURLs = "images"
        case nutrition
        case availability
    }
}

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .secondsSince1970
decoder.keyDecodingStrategy = .convertFromSnakeCase

let banana = try? decoder.decode(Vegetable.self, from: fruitData)

dump(banana)
/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */

