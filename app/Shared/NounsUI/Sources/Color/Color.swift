// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Ziad Tamim
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

/// Various component colors.
extension Color {
  
  /// A context-dependent aqua color suitable for use in UI elements.
  public static let componentAqua = Color("aqua", bundle: .module)
  
  /// A context-dependent Noun Raspberry color suitable for use in UI elements.
  public static let componentNounRaspberry = Color("noun.raspberry", bundle: .module)
  
  /// A context-dependent brambleberry color suitable for use in UI elements.
  public static let componentBrambleberry = Color("brambleberry", bundle: .module)
  
  /// A context-dependent canadian sky color suitable for use in UI elements.
  public static let componentCanadianSky = Color("canadian.sky", bundle: .module)
  
  /// A context-dependent clementine color suitable for use in UI elements.
  public static let componentClementine = Color("clementine", bundle: .module)
  
  /// A context-dependent concord color suitable for use in UI elements.
  public static let componentConcord = Color("concord", bundle: .module)
  
  /// A context-dependent cool grey color suitable for use in UI elements.
  public static let componentCoolGrey = Color("cool.grey", bundle: .module)
  
  /// A context-dependent eggplant color suitable for use in UI elements.
  public static let componentEggplant = Color("eggplant", bundle: .module)
  
  /// A context-dependent inside lime color suitable for use in UI elements.
  public static let componentInsideLime = Color("inside.lime", bundle: .module)
  
  /// A context-dependent linen color suitable for use in UI elements.
  public static let componentLinen = Color("linen", bundle: .module)
  
  /// A context-dependent mountain sky color suitable for use in UI elements.
  public static let componentMountainSky = Color("mountain.sky", bundle: .module)
  
  /// A context-dependent nouns black color suitable for use in UI elements.
  public static let componentNounsBlack = Color("nouns.black", bundle: .module)
  
  /// A context-dependent nuclear mint color suitable for use in UI elements.
  public static let componentNuclearMint = Color("nuclear.mint", bundle: .module)
  
  /// A context-dependent october sky color suitable for use in UI elements.
  public static let componentOctoberSky = Color("october.sky", bundle: .module)
  
  /// A context-dependent orange cream color suitable for use in UI elements.
  public static let componentOrangeCream = Color("orange.cream", bundle: .module)
  
  /// A context-dependent peachy color suitable for use in UI elements.
  public static let componentPeachy = Color("peachy", bundle: .module)
  
  /// A context-dependent perriwinkle color suitable for use in UI elements.
  public static let componentPerriwinkle = Color("perriwinkle", bundle: .module)
  
  /// A context-dependent purple cabbage color suitable for use in UI elements.
  public static let componentPurpleCabbage = Color("purple.cabbage", bundle: .module)
  
  /// A context-dependent raspberry color suitable for use in UI elements.
  public static let componentRaspberry = Color("raspberry", bundle: .module)
  
  /// A context-dependent smoothie color suitable for use in UI elements.
  public static let componentSmoothie = Color("smoothie", bundle: .module)
  
  /// A context-dependent soft cherry color suitable for use in UI elements.
  public static let componentSoftCherry = Color("soft.cherry", bundle: .module)
  
  /// A context-dependent soft grey color suitable for use in UI elements.
  public static let componentSoftGrey = Color("soft.grey", bundle: .module)
  
  /// A context-dependent spearmint color suitable for use in UI elements.
  public static let componentSpearmint = Color("spearmint", bundle: .module)
  
  /// A context-dependent unripe lemon color suitable for use in UI elements.
  public static let componentUnripeLemon = Color("unripe.lemon", bundle: .module)
  
  /// A context-dependent warm grey color suitable for use in UI elements.
  public static let componentWarmGrey = Color("warm.grey", bundle: .module)
  
  /// A context-dependent serious mango color suitable for use in UI elements.
  public static let componentSeriousMango = Color("serious.mango", bundle: .module)
  
  /// A context-dependent turquoise color suitable for use in UI elements.
  public static let componentTurquoise = Color("turquoise", bundle: .module)
  
  /// A context-dependent yellow color suitable for use in UI elements.
  public static let componentAngularYellow = Color("angular.yellow", bundle: .module)
  
  /// A context-dependent pink color suitable for use in UI elements.
  public static let componentAngularPink = Color("angular.pink", bundle: .module)
  
  /// A context-dependent purple color suitable for use in UI elements.
  public static let componentAngularPurple = Color("angular.purple", bundle: .module)
    
  public static let componentMferOrange = Color("mfer.orange", bundle: .module)

  public static let componentMferBlue = Color("mfer.blue", bundle: .module)

  public static let componentMferGreen = Color("mfer.green", bundle: .module)

  public static let componentMferRed = Color("mfer.red", bundle: .module)

  public static let componentMferYellow = Color("mfer.yellow", bundle: .module)
}

extension ShapeStyle where Self == Color {
  
  /// A context-dependent aqua color suitable for use in UI elements.
  public static var componentAqua: Color {
    .componentAqua
  }
  
  /// A context-dependent brambleberry color suitable for use in UI elements.
  public static var componentBrambleberry: Color {
    .componentBrambleberry
  }
  
  /// A context-dependent canadian sky color suitable for use in UI elements.
  public static var componentCanadianSky: Color {
    .componentCanadianSky
  }
  
  /// A context-dependent clementine color suitable for use in UI elements.
  public static var componentClementine: Color {
    .componentClementine
  }
  
  /// A context-dependent concord color suitable for use in UI elements.
  public static var componentConcord: Color {
    .componentConcord
  }
  
  /// A context-dependent cool grey color suitable for use in UI elements.
  public static var componentCoolGrey: Color {
    .componentCoolGrey
  }
  
  /// A context-dependent eggplant color suitable for use in UI elements.
  public static var componentEggplant: Color {
    .componentEggplant
  }
  
  /// A context-dependent inside lime color suitable for use in UI elements.
  public static var componentInsideLime: Color {
    .componentInsideLime
  }
  
  /// A context-dependent linen color suitable for use in UI elements.
  public static var componentLinen: Color {
    .componentLinen
  }
  
  /// A context-dependent mountain sky color suitable for use in UI elements.
  public static var componentMountainSky: Color {
    .componentMountainSky
  }
  
  /// A context-dependent nouns black color suitable for use in UI elements.
  public static var componentNounsBlack: Color {
    .componentNounsBlack
  }
  
  /// A context-dependent nuclear mint color suitable for use in UI elements.
  public static var componentNuclearMint: Color {
    .componentNuclearMint
  }
  
  /// A context-dependent october sky color suitable for use in UI elements.
  public static var componentOctoberSky: Color {
    .componentOctoberSky
  }
  
  /// A context-dependent orange cream color suitable for use in UI elements.
  public static var componentOrangeCream: Color {
    .componentOrangeCream
  }
  
  /// A context-dependent peachy color suitable for use in UI elements.
  public static var componentPeachy: Color {
    .componentPeachy
  }
  
  /// A context-dependent perriwinkle color suitable for use in UI elements.
  public static var componentPerriwinkle: Color {
    .componentPerriwinkle
  }
  
  /// A context-dependent purple cabbage color suitable for use in UI elements.
  public static var componentPurpleCabbage: Color {
    .componentPurpleCabbage
  }
  
  /// A context-dependent raspberry color suitable for use in UI elements.
  public static var componentRaspberry: Color {
    .componentRaspberry
  }
  
  /// A context-dependent smoothie color suitable for use in UI elements.
  public static var componentSmoothie: Color {
    .componentSmoothie
  }
  
  /// A context-dependent soft cherry color suitable for use in UI elements.
  public static var componentSoftCherry: Color {
    .componentSoftCherry
  }
  
  /// A context-dependent soft grey color suitable for use in UI elements.
  public static var componentSoftGrey: Color {
    .componentSoftGrey
  }
  
  /// A context-dependent spearmint color suitable for use in UI elements.
  public static var componentSpearmint: Color {
    .componentSpearmint
  }
  
  /// A context-dependent unripe lemon color suitable for use in UI elements.
  public static var componentUnripeLemon: Color {
    .componentUnripeLemon
  }
  
  /// A context-dependent warm grey color suitable for use in UI elements.
  public static var componentWarmGrey: Color {
    .componentWarmGrey
  }
}
