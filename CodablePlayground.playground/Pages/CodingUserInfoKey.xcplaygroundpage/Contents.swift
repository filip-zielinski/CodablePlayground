/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # CodingUserInfoKey
//: ### When your representations differ across endpoints
//: Contextual information may be provided during encoding and decoding using `userInfo` property of Decoder and Encoder.
import Foundation

enum CustomCodingOptionsError: Error {
    case optionsNotProvided
}

struct CustomCodingOptions {
    enum ApiVersion { case v1, v2 }

    let apiVersion: ApiVersion
    let oldDateFormatter: DateFormatter

    static let key = CodingUserInfoKey(rawValue: "com.intive.customercodingoptions")!
}

struct Retailer {
    let name: String
    let website: URL?
    let founded: Date?

    enum CodingKeys: String, CodingKey {
        case oldName = "retailer_name"
        case name
        case website
        case founded
    }
}

extension Retailer: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        guard let options = encoder.userInfo[CustomCodingOptions.key] as? CustomCodingOptions else {
            throw CustomCodingOptionsError.optionsNotProvided
        }

        switch options.apiVersion {
        case .v1:
            try container.encode(name, forKey: .oldName)

            guard let founded = founded else { break }
            let oldDate = options.oldDateFormatter.string(from: founded)
            try container.encode(oldDate, forKey: .founded)
        case .v2:
            try container.encode(name, forKey: .name)
            try container.encode(founded, forKey: .founded)
        }

        try container.encode(website, forKey: .website)
    }
}

extension Retailer: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        guard let options = decoder.userInfo[CustomCodingOptions.key] as? CustomCodingOptions else {
            throw CustomCodingOptionsError.optionsNotProvided
        }

        switch options.apiVersion {
        case .v1:
            name = try container.decode(String.self, forKey: .oldName)
            let oldFounded = try container.decode(String.self, forKey: .founded)
            founded = options.oldDateFormatter.date(from: oldFounded)
        case .v2:
            name = try container.decode(String.self, forKey: .name)
            founded = try container.decode(Date.self, forKey: .founded)
        }

        website = try container.decode(URL.self, forKey: .website)
    }
}


let encoder = JSONEncoder()
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "MMM-dd-yyyy"
let options = CustomCodingOptions(apiVersion: .v1, oldDateFormatter: dateFormatter)

encoder.userInfo = [CustomCodingOptions.key: options]

/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */
