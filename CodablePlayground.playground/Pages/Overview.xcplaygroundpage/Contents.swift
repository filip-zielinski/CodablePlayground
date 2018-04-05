/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

- - -

 # Overview

 Encoding and decoding is about the conversion between native and custom Swift data structures and archived formats, especially JSON.\
 Codable protocols allows easy convertion between loosely typed JSON and strong Swift type.

 _Codable_ - A type that can convert itself into and out of an external representation

 - Note: Codable by definition is alias to two protocols:
 \
 `typealias Codable = Decodable & Encodable`


 - Important:
 `Encodable` - A type that can encode itself **to** an external representation
 \
 `Decodable` - A type that can decode itself **from** an external representation

 ---
 Many standard and non standard types already adopt Codable protocols, including: `String`, `Int`, `Double`, `Decimal`, `Bool`, `Date`, `DateInterval`, `DateComponents`, `Calendar`, `TimeZone`, `Data`, `URL`, `PersonNameComponents`.

 Any type whose all properties are codable automatically conforms to Codable just by declaring that conformance:
 */
import Foundation

struct Retailer: Codable {
    let name: String
    let website: URL
    let establishedIn: Date
}
/*:
 `Retailer` now supports the `Codable` methods `init(from:)` and `encode(to:)` and can be serialized to and from any data formats provided by custom encoders and decoders (eg. JSONEncoder, PropertyListEncoder).
 */
struct Vegetable: Codable {
    let identifier: Int
    let name: String?
    let isDelicious: Bool
    let imagesURLs: [URL]
    let nutrition: [String: Float]
    let availability: [Retailer]
}
/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */
