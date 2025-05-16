import SwiftUI

struct AppTheme {
    static let accent = Color(red: 0.13, green: 0.19, blue: 0.36) // Azul oscuro profesional
    static let background = Color(red: 0.96, green: 0.97, blue: 0.99) // Gris muy claro para efecto flotante
    static let cardBackground = Color.white
    static let titleFont = Font.largeTitle.weight(.bold)
    static let subtitleFont = Font.title2.weight(.semibold)
    static let bodyFont = Font.body
    static let cornerRadius: CGFloat = 44 // Esquinas del iPhone
    static let shadow = Color.black.opacity(0.08)
} 