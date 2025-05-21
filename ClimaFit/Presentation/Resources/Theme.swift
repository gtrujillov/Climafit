import SwiftUI

public struct AppTheme {
    // Colores principales
    static let prussianBlue = Color(red: 1/255, green: 42/255, blue: 74/255)
    static let background = Color(red: 169/255, green: 214/255, blue: 229/255)
    static let cardBackground = Color.white.opacity(0.9)
    static let shadow = Color.black.opacity(0.1)

    // Paleta extendida
    static let indigoDye1 = Color(red: 1/255, green: 58/255, blue: 99/255)
    static let indigoDye2 = Color(red: 1/255, green: 73/255, blue: 124/255)
    static let indigoDye3 = Color(red: 1/255, green: 79/255, blue: 134/255)
    static let uclaBlue = Color(red: 42/255, green: 111/255, blue: 151/255)
    static let cerulean = Color(red: 44/255, green: 125/255, blue: 160/255)
    static let airForceBlue = Color(red: 70/255, green: 143/255, blue: 175/255)
    static let airSuperiorityBlue = Color(red: 97/255, green: 165/255, blue: 194/255)
    static let skyBlue = Color(red: 137/255, green: 194/255, blue: 217/255)
    static let lightBlue = Color(red: 169/255, green: 214/255, blue: 229/255)

    // Radio de esquina
    static let cornerRadius: CGFloat = 44

    // Tipografía personalizada
    public enum CarosSoftFont: String {
        case regular = "CarosSoft"
        case black = "CarosSoftBlack"
        case bold = "CarosSoftBold"
        case extraBold = "CarosSoftExtraBold"
        case extraLight = "CarosSoftExtraLight"
        case heavy = "CarosSoftHeavy"
        case light = "CarosSoftLight"
        case medium = "CarosSoftMedium"
        case thin = "CarosSoftThin"
    }

    public static func carosSoftFont(_ style: CarosSoftFont, size: CGFloat) -> Font {
        .custom(style.rawValue, size: size)
    }

    // Ejemplos de fuentes predefinidas usando CarosSoft
    static let titleFont = carosSoftFont(.bold, size: 34)
    static let subtitleFont = carosSoftFont(.medium, size: 22)
    static let bodyFont = carosSoftFont(.regular, size: 17)
}
