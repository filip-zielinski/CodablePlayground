/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # Manual Encoding
//: ### Customizing default implementation
//: ---
//: ## How to manually encode nested objects to flat object
import Foundation
import CoreGraphics

struct Pixel {
    enum PixelState: String { case up, down }

    let state: PixelState
    let coordinates: CGPoint
}

extension Pixel: Encodable {
/*:
- Note:
`Encodable` protocol requirement is to adopt one method:\
`public func encode(to encoder: Encoder)`
 */
//: **First:** specify coding keys, typically with enumerator:
    enum CodingKeys: String, CodingKey {
        case state
        case x
        case y
    }

//: **Second:** customize `encode(to:)` method:
    func encode(to encoder: Encoder) throws {
/*:
**Third:** create container. Values will be written to the container, so it must be mutable (`var`).

- Note: Container types:\
_1. keyed container (dictionary): for holding multiple values provided by the key type\
_2. unkeyed container (array): for holding multiple unkeyed values\
_3. single value container: for holding a single primitive value
*/
        var container = encoder.container(keyedBy: CodingKeys.self)
//: **Than:** encode values for the given keys.
        try container.encode(state.rawValue, forKey: .state)
        try container.encode(coordinates.x, forKey: .x)
        try container.encode(coordinates.y, forKey: .y)
    }
}

let pixel = Pixel(state: .up, coordinates: CGPoint(x: 50, y: 100))

let encoder = JSONEncoder()

let pixelData = try encoder.encode(pixel)
let pixelJSON = try JSONSerialization.jsonObject(with: pixelData)

//: ---
//: ## How to encode flat object to nested objects

struct Guitar {
    let name: String
    let numberOfStrings: Int
    let isElectric: Bool?
}

let strat = Guitar(name: "Strat 🎸", numberOfStrings: 6, isElectric: true)

/*:
 Using default Encodable implementation, `Guitar` structure would be encoded to following form:

    {
    name = "Strat \Ud83c\Udfb8";
    numberOfStrings = 6;
    isElectric = 1;
    }

 To wrap some properties into nested collection use container's **nested containers**, which can be:

 - Note: Nested Container types:\
 _1. keyed (dictionary): returned by container's `nestedContainer(keyedBy:forKey:)`\
 _2. unkeyed (array): returned by container's `nestedUnkeyedContainer(forKey:)`
 */
extension Guitar: Encodable {

    enum CodingKeys: String, CodingKey {
        case name
        case info
    }

    enum InfoCodingKeys: CodingKey {
        case numberOfStrings
        case isElectric
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)

        var infoContainer = container.nestedContainer(keyedBy: InfoCodingKeys.self, forKey: .info)
        try infoContainer.encode(numberOfStrings, forKey: .numberOfStrings)
        try infoContainer.encode(isElectric, forKey: .isElectric)

/*:
- Note:
When automatically encoding optional type, `encodeIfPresent` method is used by default.\
Using manual encoding `encode` method can be used explicitly, so the key won't be missing in the encoded object in case it's nil.
 */
    }
}

let data = try encoder.encode(strat)
let JSON = try JSONSerialization.jsonObject(with: data)

/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */

