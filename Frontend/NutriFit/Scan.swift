//
//  Scan.swift
//  NutriFit
//
//  Created by Elias Dnadouch on 5/20/24.
//

import SwiftUI

import SwiftUI

struct Scan: View {
    @State private var isShowingScanner = false
    @State private var scannedCode: String?

    var body: some View {
        VStack {
            if let scannedCode = scannedCode {
                NutrientView(upc: scannedCode)
            } else {
                if isShowingScanner {
                    CameraViewControllerRepresentable()
                        .edgesIgnoringSafeArea(.all)
                } else {
                    Button(action: {
                        self.isShowingScanner = true
                    }) {
                        Text("Scan Barcode")
                            .font(.largeTitle)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .didFindBarcode)) { notification in
            if let code = notification.object as? String {
                self.scannedCode = code
                self.isShowingScanner = false
            }
        }
    }
}

extension Notification.Name {
    static let didFindBarcode = Notification.Name("didFindBarcode")
}


#Preview {
    Scan()
}
