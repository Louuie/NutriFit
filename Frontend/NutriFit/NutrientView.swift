import SwiftUI

struct NutrientView: View {
    @State private var nutrientObject: NutrientObject?
    var upc: String

    var body: some View {
        NavigationView {
            if let nutrientObject = nutrientObject {
                List {
                    Section(header: Text(nutrientObject.name)) {
                        ForEach(nutrientObject.foodNutrients.keys.sorted(), id: \.self) { key in
                            if let nutrient = nutrientObject.foodNutrients[key] {
                                VStack(alignment: .leading) {
                                    Text(key)
                                        .font(.headline)
                                    Text("\(nutrient.value) \(nutrient.unit)")
                                        .font(.subheadline)
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("Nutrients")
            } else {
                Text("Loading...")
                    .onAppear(perform: fetchNutrients)
            }
        }
    }

    func fetchNutrients() {
        var normalizedUPC = upc
        if normalizedUPC.hasPrefix("0") {
            normalizedUPC.removeFirst()
            if normalizedUPC.hasPrefix("00") {
                normalizedUPC.removeFirst()
            }
        }
        print("normalized UPC: \(normalizedUPC)")
        guard var urlComponents = URLComponents(string: "http://192.168.1.8:3000/search") else { return }
        urlComponents.queryItems = [URLQueryItem(name: "upc", value: normalizedUPC)]
        
        guard let url = urlComponents.url else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                // Print the raw JSON response for debugging
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
                    print("Raw JSON response: \(json)")
                }
                
                let decoder = JSONDecoder()
                let nutrientObject = try decoder.decode(NutrientObject.self, from: data)
                DispatchQueue.main.async {
                    self.nutrientObject = nutrientObject
                }
            } catch let DecodingError.dataCorrupted(context) {
                print("Data corrupted: \(context)")
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found: \(context.debugDescription)")
                print("CodingPath: \(context.codingPath)")
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found: \(context.debugDescription)")
                print("CodingPath: \(context.codingPath)")
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch: \(context.debugDescription)")
                print("CodingPath: \(context.codingPath)")
            } catch {
                print("Error decoding data: \(error)")
            }
        }.resume()
    }
}

// Preview
struct NutrientView_Previews: PreviewProvider {
    static var previews: some View {
        NutrientView(upc: "611269716467")
    }
}
