import Foundation

struct Nutrient: Codable, Identifiable {
    var id = UUID()
    var unit: String
    var value: String

    enum CodingKeys: String, CodingKey {
        case unit
        case value
    }

    init(unit: String, value: String) {
        self.unit = unit
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        unit = try container.decode(String.self, forKey: .unit)
        // Custom decoding for value to handle both String and Number
        if let valueString = try? container.decode(String.self, forKey: .value) {
            value = valueString
        } else if let valueNumber = try? container.decode(Double.self, forKey: .value) {
            value = String(valueNumber)
        } else {
            throw DecodingError.typeMismatch(String.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Value cannot be decoded"))
        }
    }
}


struct NutrientObject: Codable {
    var foodNutrients: [String: Nutrient]
    var name: String

    enum CodingKeys: String, CodingKey {
        case foodNutrients = "food_nutrients"
        case name
    }
}
