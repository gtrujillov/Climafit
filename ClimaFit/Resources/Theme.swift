import SwiftUI

public struct AppTheme {
    
    static let primaryBrown = Color(red: 80/255, green: 55/255, blue: 40/255)
    static let background = Color(red: 240/255, green: 230/255, blue: 210/255) // Beige suave para fondo
    static let cardBackground = Color.white.opacity(0.85) // Blanco suave para tarjetas
    static let shadow = Color.black.opacity(0.1) // Sombra ligera

    // Paleta extendida con tonos cálidos y sofisticados
    static let wineRed = Color(red: 120/255, green: 30/255, blue: 40/255)
    static let softCream = Color(red: 250/255, green: 245/255, blue: 235/255)
    static let warmTaupe = Color(red: 130/255, green: 110/255, blue: 100/255)
    static let mutedGold = Color(red: 190/255, green: 170/255, blue: 120/255)
    static let deepChocolate = Color(red: 50/255, green: 30/255, blue: 20/255)

    // Radio de esquina
    static let cornerRadius: CGFloat = 44
}

extension AppTheme {
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

    // Tamaños de fuente comunes
    public enum FontSize: CGFloat {
        case extraSmall = 10
        case small = 12
        case body = 14
        case callout = 16
        case subheadline = 18
        case headline = 20
        case title3 = 22
        case title2 = 28
        case title1 = 34
        case largeTitle = 38
    }
}

extension AppTheme {
    // Helpers para fuentes comunes
    public static func boldFont(size: FontSize) -> Font {
        carosSoftFont(.bold, size: size.rawValue)
    }
    
    public static func regularFont(size: FontSize) -> Font {
        carosSoftFont(.regular, size: size.rawValue)
    }
    
    public static func mediumFont(size: FontSize) -> Font {
        carosSoftFont(.medium, size: size.rawValue)
    }
    
    // Atajos para usar fuentes con tamaños comunes
    public static var headlineBold: Font {
        boldFont(size: .headline)
    }
    
    public static var title1Bold: Font {
        boldFont(size: .title1)
    }
    
    public static var bodyRegular: Font {
        regularFont(size: .body)
    }
    
    public static func thinFont(size: FontSize) -> Font {
        carosSoftFont(.thin, size: size.rawValue)
    }
}
