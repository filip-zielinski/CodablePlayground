/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # Inheritance
//: ### Using classes for data models
//: ## Superclass
import Foundation

class Vehicle: Codable {
    let horsePower: Int

//: - Note: Mark Coding Keys private to hide them from subclasses:
    private enum CodingKeys: String, CodingKey {
        case horsePower
    }

    init(horsePower: Int) {
        self.horsePower = horsePower
    }

//: Provide required initializer (in this case it's not really needed. Thanks to default implementation, compiler would generate it for us):
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        horsePower = try container.decode(Int.self, forKey: .horsePower)
    }
//: Provide `encode(to:)` method (in this case it's not really needed):
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(horsePower, forKey: .horsePower)
    }
}

//: ## Subclass
class Motorcycle: Vehicle {
    let isChopper: Bool

//: - Note: Again Coding Keys are private, so they can have the same name as in super class
    private enum CodingKeys: String, CodingKey {
        case isChopper
        case generalInfo
    }

    init(horsePower: Int, isChopper: Bool) {
        self.isChopper = isChopper
        super.init(horsePower: horsePower)
    }

//: ### Subclass Decoding
    required init(from decoder: Decoder) throws {
//: First create container and decode subclass's properties into it
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isChopper = try container.decode(Bool.self, forKey: .isChopper)

/*:
Than create decoder for decoding super from the container.\
It can be associated with the default key ("super") or custom key
*/
        let superDecoder = try container.superDecoder(forKey: .generalInfo)
        try super.init(from: superDecoder)
    }

//: ### Subclass Encoding
    override func encode(to encoder: Encoder) throws {
//: First create container for subclass's properties
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isChopper, forKey: .isChopper)

//: Than call superclass's `encode(to:)` using superclass-ready encoder from the container
        try super.encode(to: container.superEncoder(forKey: .generalInfo))
//: As a result, subclass's properties are encoded to nested container
    }
}

//: ### Examples
let decoder = JSONDecoder()
let encoder = JSONEncoder()

let motorcycleData = """
{
    "generalInfo":     {
        "horsePower": 73
    },
    "isChopper": false
}
""".data(using: .utf8)!
let motorcycle = try decoder.decode(Motorcycle.self, from: motorcycleData)
//: ---
let ktm690Duke = Motorcycle(horsePower: 73, isChopper: false)
let ktm690DukeData = try encoder.encode(ktm690Duke)
let JSON = try JSONSerialization.jsonObject(with: ktm690DukeData)

print(JSON, terminator: "\n\n")
//: ---
//: ## Encoding to and decoding from shared container
class Train: Vehicle {
    let wagonsCount: Int

    private enum CodingKeys: String, CodingKey {
        case wagonsCount
    }

    init(horsePower: Int, wagonsCount: Int) {
        self.wagonsCount = wagonsCount
        super.init(horsePower: horsePower)
    }

//: To decode super and subclass's properties from single container, call `super.init(from: decoder)` after decoding subclass's properties.
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        wagonsCount = try container.decode(Int.self, forKey: .wagonsCount)

        try super.init(from: decoder)
    }

//: To encode super and subclass's properties to single container, call `super.encode(to: encoder)` before encoding subclass's properties.
    override func encode(to encoder: Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(wagonsCount, forKey: .wagonsCount)
    }
}

let unionPacific9000 = Train(horsePower: 4750, wagonsCount: 10)
let unionPacific9000Data = try encoder.encode(unionPacific9000)
let unionPacific9000JSON = try JSONSerialization.jsonObject(with: unionPacific9000Data)

print(unionPacific9000JSON)
//: ---
let trainData = """
{
    "horsePower": 4750,
    "wagonsCount": 10
}
""".data(using: .utf8)!
let train = try decoder.decode(Train.self, from: trainData)
/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */
