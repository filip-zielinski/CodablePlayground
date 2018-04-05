/*:
 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)

 - - -
 */
//: # Decoding nested data using intermediate type
//: ### Ignore structure and data in JSON that you don’t need in your code
import Foundation
//: Target data structure:
struct Restaurant {
    let name: String
    let cheapestDish: Dish?

    struct Dish: Decodable {
        let name: String
        let price: Float
    }
}

//: Actual structure:
let restaurantsJSON = """
[
  {
    "name": "Healthy Place #1",
    "menuSections": [
      {
        "name": "Appetizers",
        "dishes": [
          {
            "name": "Topas",
            "price": 10
          }
        ]
      },
      {
        "name": "Regular Meals",
        "dishes": [
          {
            "name": "Chickpeas Curry",
            "price": 20
          },
          {
            "name": "Jumbo Large Pizza",
            "price": 40
          }
        ]
      },
      {
        "name": "Desserts",
        "dishes": [
          {
            "name": "🍧 Ice Cream 🍦",
            "price": 9.90
          },
          {
            "name": "Cake",
            "price": 15
          }
        ]
      }
    ]
  }
]
""".data(using: .utf8)!

//: - Note: To decode actual data to desired structure you can use intermediate decodable type that mirrors actual data structure:
struct RestaurantMediator: Decodable {
    let name: String
    let menuSections: [MenuSection]

    struct MenuSection: Decodable {
        let name: String
        let dishes: [Restaurant.Dish]
    }
}

//: Than create your type using intermediate type
extension Restaurant {
    init(using mediator: RestaurantMediator) {
        name = mediator.name

        let allDishes = mediator.menuSections.flatMap { $0.dishes }
        cheapestDish = allDishes.min { $0.price < $1.price }
    }
}

let decoder = JSONDecoder()
let restaurantsMediator = try decoder.decode([RestaurantMediator].self, from: restaurantsJSON)

let restaurants = restaurantsMediator.map { Restaurant(using: $0) }
dump(restaurants)

//: ---
//: ## Different way of accesing nested data
struct OtherRestaurant: Decodable {
    let name: String
    let cheapestDish: Dish?

    struct Dish: Decodable {
        let name: String
        let price: Float
    }
}

extension OtherRestaurant {

    enum CodingKeys: CodingKey {
        case name, menuSections
    }

    enum SectionsCodingKeys: CodingKey {
        case name, dishes
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)

        var sectionsArray = try container.nestedUnkeyedContainer(forKey: .menuSections)

        var dishes = [Dish]()

/*:
- Note:
Access all elements in the container using while loop and unkeyed container's `isAtEnd` property.\
To access current decoding index of the container use `currentIndex` property.\
Number of elements can be accessed through `count` property.
 */
        while sectionsArray.isAtEnd == false {
            let sectionContainer = try sectionsArray.nestedContainer(keyedBy: SectionsCodingKeys.self)
            var dishesForSectionArray = try sectionContainer.nestedUnkeyedContainer(forKey: .dishes)

            while dishesForSectionArray.isAtEnd == false {
                let dish = try dishesForSectionArray.decode(Dish.self)
                dishes.append(dish)
            }
        }

//: - Note: Similarly for keyed containers, keys can be accessed using `allKeys` property.

        cheapestDish = dishes.min { $0.price < $1.price }
    }
}

let otherRestaurant = try? decoder.decode([OtherRestaurant].self, from: restaurantsJSON)

/*:
 - - -

 [[< Previous]](@previous)  [[Table of Contents]](Start)  [[Next >]](@next)
 */



