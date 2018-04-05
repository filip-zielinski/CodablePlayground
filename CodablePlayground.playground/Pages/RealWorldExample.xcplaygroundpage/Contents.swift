/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # Real World Example
//: ### Not so pretty now
import Foundation

let artistData = """
{
  "items": {
    "item": [
      {
        "id": "768g8g8",
        "name": "Sarsa",
        "bio": "Born in 1989 in Slupsk",
        "images": {
          "image": [
            {
              "width": "320",
              "height": "400",
              "format": "png",
              "imgUrl": "http://imageprovider.com/srsrs1.jpg"
            },
            {
              "width": "300",
              "height": "400",
              "format": "jpg",
              "imgUrl": "http://imageprovider.com/srsrs2.jpg"
            }
          ]
        }
      },
      {
        "id": "bvhjvy68",
        "name": "Jane Doe",
        "bio": "Jane Doe has done some things",
        "images": {
          "image": []
        }
      }
    ]
  }
}
""".data(using: .utf8)!

public struct ArtistsFeed {

    public var artists: [DetailedArtist]

    public init(from response: ArtistsFeedResponse) {
        artists = response.artists.map {
            DetailedArtist(artistId: $0.artistId,
                           name: $0.name, bio: $0.bio, artistImages: $0.artistImages)
        }
    }
}

public struct ArtistsFeedResponse: Decodable {

    let artists: [DetailedArtist]
}

extension ArtistsFeedResponse {

    enum CodingKeys: String, CodingKey {
        case items
    }

    enum AdditionalItemKeys: String, CodingKey {
        case item
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let itemContainer = try container.nestedContainer(keyedBy: AdditionalItemKeys.self, forKey: .items)
        var artistsContainer = try itemContainer.nestedUnkeyedContainer(forKey: .item)

        var artists = [DetailedArtist]()

        while artistsContainer.isAtEnd == false {
            let artist = try artistsContainer.decode(DetailedArtist.self)
            artists.append(artist)
        }

        self.init(artists: artists)
    }
}

public struct DetailedArtist: Decodable {

    public let artistId: String
    public var name: String
    public let bio: String?
    public let artistImages: [DetailedImage]
}

extension DetailedArtist {

    enum CodingKeys: String, CodingKey {
        case artistId = "id"
        case name
        case bio
        case artistImages = "images"
    }

    enum AdditionalImageKeys: String, CodingKey {
        case image
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let artistId = try container.decode(String.self, forKey: .artistId)
        let name = try container.decode(String.self, forKey: .name)
        let bio = try container.decodeIfPresent(String.self, forKey: .bio)

        let imagesContainer = try container.nestedContainer(keyedBy: AdditionalImageKeys.self, forKey: .artistImages)
        let images = try imagesContainer.decode([DetailedImage].self, forKey: .image)

        self.init(artistId: artistId, name: name, bio: bio, artistImages: images)
    }
}

public struct DetailedImage: Decodable {

    public let width: Int?
    public let height: Int?
    public let format: String
    public let url: URL?
}

extension DetailedImage {

    enum CodingKeys: String, CodingKey {
        case width
        case height
        case format
        case url = "imgUrl"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let width = try container.decode(String.self, forKey: .width)
        let height = try container.decode(String.self, forKey: .height)
        let format = try container.decode(String.self, forKey: .format)
        let url = try container.decode(URL.self, forKey: .url)

        self.init(width: Int(width), height: Int(height), format: format, url: url)
    }
}

let decoder = JSONDecoder()

let artistFeedResponse = try decoder.decode(ArtistsFeedResponse.self, from: artistData)
let feed = ArtistsFeed(from: artistFeedResponse)

dump(feed)

/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */
