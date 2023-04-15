// Copyright (C) 2022 Nouns Collective
//
// Originally authored by  Ziad Tamim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

import SwiftUI

/// `GTWalsheim` type safe font.
public enum GTWalsheim: String, CaseIterable {
  case boldOblique = "GT Walsheim Trial Bd Ob"
  case bold = "SartoshiScript-Regular"
  case mediumOblique = "GT Walsheim Trial Md Ob"
  case medium = "GT Walsheim Trial Md"
  case regularOblique = "GT Walsheim Trial Rg Ob"
  case regular = "GT Walsheim Trial Rg"
}

internal enum FontType: String {
  case `true` = "ttf"
  case `open` = "otf"
}

extension UIFont {
  
  public static func custom(_ font: GTWalsheim, size: CGFloat) -> UIFont {
    UIFont(name: font.rawValue, size: size) ?? .systemFont(ofSize: size)
  }
}

extension Font {
  
  public static func custom(_ font: GTWalsheim, relativeTo style: Font.TextStyle) -> Font {
    custom(font.rawValue, size: style.size, relativeTo: style)
  }
  
  public static func custom(_ font: GTWalsheim, size: CGFloat) -> Font {
    custom(font.rawValue, size: size)
  }
  
  internal static func registerFont(bundle: Bundle, name: String, type: FontType) {
    guard let fontURL = bundle.url(forResource: name, withExtension: type.rawValue),
          let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
          let font = CGFont(fontDataProvider)
    else {
      fatalError("⚠️ Couldn't register font with name: \(name)")
    }
    
    var error: Unmanaged<CFError>?
    CTFontManagerRegisterGraphicsFont(font, &error)
  }
}

public extension Font.TextStyle {
  
  /// Relative sizes to the text styles to match the UI Context.
  var size: CGFloat {
    switch self {
    case .largeTitle:
      return 52
      
    case .title:
      return 48
      
    case .title2:
      return 36
      
    case .title3:
      return 24
      
    case .headline, .body:
      return 18
      
    case .subheadline, .callout:
      return 17
      
    case .footnote:
      return 15
      
    case .caption, .caption2:
      return 16
      
    @unknown default:
      return 8
    }
  }
}
