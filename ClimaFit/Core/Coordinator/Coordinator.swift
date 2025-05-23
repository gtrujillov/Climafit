//
//  Coordinator.swift
//  ClimaFit
//
//  Created by Gonzalo Trujillo Vallejo on 23/5/25.
//

import Foundation
import SwiftUI

protocol Coordinator {
    associatedtype Content: View
    func start() -> Content
}
