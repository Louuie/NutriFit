//
//  CamerViewControllerRepresentable.swift
//  NutriFit
//
//  Created by Elias Dandouch on 5/20/24.
//


import SwiftUI

struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {}
}



