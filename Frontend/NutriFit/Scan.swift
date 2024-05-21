//
//  Scan.swift
//  NutriFit
//
//  Created by Elias Dnadouch on 5/20/24.
//

import SwiftUI

struct Scan: View {
    @State private var isShowingScanner = false
    @State private var scannedCode: String?

    var body: some View {
        VStack {
            if let scannedCode = scannedCode {
                Text("Scanned Code: \(scannedCode)")
                    .font(.largeTitle)
                    .padding()
            } else {
                if isShowingScanner {
                    BarcodeScannerView {
                        self.scannedCode = $0
                        self.isShowingScanner = false
                    }
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
    }
}


#Preview {
    Scan()
}
