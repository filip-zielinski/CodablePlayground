/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # Manual Decoding
//: ### Customizing default implementation
//: ---
//: ## How to decode nested objects from flat object
import Foundation

struct RockStar {
    let name: String
    let instrument: Instrument
}

struct Instrument {
    let name: String
    let isElectric: Bool?
}

extension RockStar: Decodable {
/*:
- Note: `Decodable` protocol has one requirement:\
`init(from decoder: Decoder)`
*/
//: **First:** specify coding keys, typically with enumerator:
    enum CodingKeys: String, CodingKey {
        case name
        case instrumentName
        case isInstrumentElectric
    }
//: **Second:** customize initializer:
    init(from decoder: Decoder) throws {
//: **Third:** create container with stored data from decoder:
        let container = try decoder.container(keyedBy: CodingKeys.self)

//: **Than:** initialize properties with decoded values of the given type for the given key:
        name = try container.decode(String.self, forKey: .name)

        let instrumentName = try container.decode(String.self, forKey: .instrumentName)
        let isInstrumentElectric = try container.decodeIfPresent(Bool.self, forKey: .isInstrumentElectric)
        instrument = Instrument(name: instrumentName, isElectric: isInstrumentElectric)
    }
}

//: ---
//: ## Examples

let jimiData =
"""
{
  "name": "Jimi",
  "instrumentName": "Strat 🎸",
  "isInstrumentElectric": true
}
""".data(using: .utf8)!

let decoder = JSONDecoder()

let jimi = try? decoder.decode(RockStar.self, from: jimiData)

//: ---

let bandData =
"""
[
  {
    "name": "Jimi",
    "instrumentName": "Strat 🎸",
    "isInstrumentElectric": true
  },
  {
    "name": "Dave",
    "instrumentName": "Drums 🥁",
  },
  {
    "name": "John",
    "instrumentName": "Sax 🎷",
    "isInstrumentElectric": false
  }
]
""".data(using: .utf8)!

let band = try? decoder.decode([RockStar].self, from: bandData)

//: ---

let bandWithRolesData =
"""
[
  {
    "guitarist": {
      "name": "Jimi",
      "instrumentName": "Strat 🎸",
      "isInstrumentElectric": true
    }
  },
  {
    "drummer": {
      "name": "Dave",
      "instrumentName": "Drums 🥁",
      "isInstrumentElectric": false
    }
  },
  {
    "cat": {
      "name": "John",
      "instrumentName": "Sax 🎷",
      "isInstrumentElectric": false
    }
  }
]
""".data(using: .utf8)!

let bandWithRoles = try? decoder.decode([[String:RockStar]].self, from: bandWithRolesData)

print("Here comes the band of \(bandWithRoles?.count ?? 0)!")
dump(bandWithRoles)

//: ---
//: ## How to decode flat object from nested objects

struct Guitar {
    let name: String
    let numberOfStrings: Int
    let isElectric: Bool?
}

let ukuleleData =
"""
{
  "name": "Ukulele",
  "info": {
    "numberOfStrings": 4,
    "isElectric": false
  }
}
""".data(using: .utf8)!

extension Guitar: Decodable {

    enum CodingKeys: String, CodingKey {
        case name
        case info
    }

    enum InfoCodingKeys: CodingKey {
        case numberOfStrings
        case isElectric
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)

//: - Note: Create container for nested objects, decode their properties and assign them:
        let infoContainer = try container.nestedContainer(keyedBy: InfoCodingKeys.self, forKey: .info)
        numberOfStrings = try infoContainer.decode(Int.self, forKey: .numberOfStrings)
        isElectric = try infoContainer.decodeIfPresent(Bool.self, forKey: .isElectric)
    }
}

let myNewUkulele = try decoder.decode(Guitar.self, from: ukuleleData)

/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */


