/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # Dynamic Coding Keys
//: ### Access data at different depths
//: Encoding to and decoding from structure that contains keys with names unknown until runtime is possible by implementing CodingKeys as a `struct` conforming to `CodingKey` protocol.
import Foundation

let bandWithRolesData =
"""
{
    "guitarist": {
        "name": "Jimi",
        "instrumentName": "Strat 🎸",
        "isInstrumentElectric": true
    },
    "drummer": {
        "name": "Dave",
        "instrumentName": "Drums 🥁",
        "isInstrumentElectric": false
    },
    "saxophonist": {
        "name": "John",
        "instrumentName": "Sax 🎷",
        "isInstrumentElectric": false
    }
}
""".data(using: .utf8)!

struct RockBand {

    struct RockStar {
        let name: String
        let role: String
        let instrument: Instrument

        struct Instrument {
            let name: String
            let isElectric: Bool?
        }
    }

    let rockStars: [RockStar]
}

extension RockBand {

    struct DynamicCodingKeys: CodingKey {
//: For named collection (e.g. a string-keyed dictionary):
        var stringValue: String

//: For integer-indexed collection (e.g. an int-keyed dictionary):
        var intValue: Int? { return nil }

        init(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) { return nil }

        static let name = DynamicCodingKeys(stringValue: "name")
        static let instrumentName = DynamicCodingKeys(stringValue: "instrumentName")
        static let isInstrumentElectric = DynamicCodingKeys(stringValue: "isInstrumentElectric")
    }
}

extension RockBand: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicCodingKeys.self)

        var rockStars = [RockStar]()
        for key in container.allKeys {
            let rockStarContainer = try container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: key)
            let name = try rockStarContainer.decode(String.self, forKey: .name)
            let instrumentName = try rockStarContainer.decode(String.self, forKey: .instrumentName)
            let isInstrumentElectric = try rockStarContainer.decode(Bool.self, forKey: .isInstrumentElectric)

            rockStars.append(RockStar(name: name, role: key.stringValue, instrument: RockStar.Instrument(name: instrumentName, isElectric: isInstrumentElectric)))
        }

        self.init(rockStars: rockStars)
    }
}

extension RockBand: Encodable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: DynamicCodingKeys.self)

        for rockStar in rockStars {
            let nameKey = DynamicCodingKeys(stringValue: rockStar.role)
            var rockStarContainer = container.nestedContainer(keyedBy: DynamicCodingKeys.self, forKey: nameKey)

            try rockStarContainer.encode(rockStar.name, forKey: .name)
            try rockStarContainer.encode(rockStar.instrument.name, forKey: .instrumentName)
            try rockStarContainer.encode(rockStar.instrument.isElectric, forKey: .isInstrumentElectric)
        }
    }
}

let decoder = JSONDecoder()
let bandWithRoles = try decoder.decode(RockBand.self, from: bandWithRolesData)
dump(bandWithRoles)

/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */

