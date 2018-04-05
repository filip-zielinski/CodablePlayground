/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # Error Handling
//: ## Decoding Errors

import Foundation

struct Vegetable: Codable {
    let id: UUID
    let name: String?
    let waterContent: Float

    init(id: UUID, name: String?, waterContent: Float) {
        self.id = id
        self.name = name
        self.waterContent = waterContent
    }
}

//: ### Catching errors during decoding:

extension Vegetable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        waterContent = try container.decode(Float.self, forKey: .waterContent)
        guard case 0...100 = waterContent else {
            let context = DecodingError.Context(codingPath: container.codingPath + [CodingKeys.waterContent],
                                                debugDescription: "Wrong value: waterContent does not lie within the range of 0 - 100")
            throw DecodingError.dataCorrupted(context)
        }
    }
}

let decoder = JSONDecoder()

let wrongValue = """
{
  "id": "E621E1F8-C36C-495A-93FC-0C247A3E6E5F",
  "name": "Banana",
  "waterContent": 101
}
""".data(using: .utf8)!

do {
    _ = try decoder.decode(Vegetable.self, from: wrongValue)
} catch DecodingError.dataCorrupted(let context) {
    print("‼️ \(context.debugDescription)\n")
} catch {
    print(error.localizedDescription)
}

//: ### Corrupted Data
let corruptedData = """
👾👾👾
""".data(using: .utf8)!

do {
    _ = try decoder.decode(Vegetable.self, from: corruptedData)
} catch DecodingError.dataCorrupted(let context) {
    print("‼️ \(context.debugDescription)")
    print(context.underlyingError ?? "Underlying error unknown", terminator: "\n\n")
} catch {
    print(error.localizedDescription)
}

//: ### Key not found
let keyNotFoundData = """
{
  "id": "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"
}
""".data(using: .utf8)!

do {
    _ = try decoder.decode(Vegetable.self, from: keyNotFoundData)
} catch DecodingError.keyNotFound(let key, let context) {
    print("‼️ Missing key: \(key)")
    print("Debug description: \(context.debugDescription)\n")
} catch {
    print(error.localizedDescription)
}

//: ### Type mismatch
let wrongTypeData = """
{
  "id": 9,
  "name": "Banana",
  "waterContent": 74.9
}
""".data(using: .utf8)!

do {
    _ = try decoder.decode(Vegetable.self, from: wrongTypeData)
} catch DecodingError.typeMismatch(let type, let context) {
    print("‼️ Type mismatch: expected \(type)")
    print("Debug description: \(context.debugDescription)\n")
} catch {
    print(error.localizedDescription)
}

//: ### Value not found

let valueNotFoundData = """
{
  "id": null,
  "name": "Banana",
  "waterContent": 74.9
}
""".data(using: .utf8)!

do {
    _ = try decoder.decode(Vegetable.self, from: valueNotFoundData)
} catch DecodingError.valueNotFound(let type, let context) {
    print("‼️ Value of type \(type) not found")
    print("Debug description: \(context.debugDescription)\n")
} catch {
    print(error.localizedDescription)
}

//: ## Encoding Error
//: ### Invalid Value

let eggplant = Vegetable(id: UUID(), name: "Eggplant 🍆", waterContent: .infinity)
let encoder = JSONEncoder()

do {
    _ = try JSONEncoder().encode(eggplant)
} catch EncodingError.invalidValue(let value, let context) {
    print("‼️ Invalid value: \(value)")
    print("Debug description: \(context.debugDescription)\n")
} catch {
    print(error.localizedDescription)
}

/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */
