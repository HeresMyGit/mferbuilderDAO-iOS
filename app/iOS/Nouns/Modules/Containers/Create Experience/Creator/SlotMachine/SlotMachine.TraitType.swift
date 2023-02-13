// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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
import Combine
import Services

extension SlotMachine.TraitType {
  
  private var composer: NounComposer {
    AppCore.shared.nounComposer
  }
  
  /// Traits displayed in the same order as the trait picker
  var traits: [Trait] {
    switch self {
    case .background:
      return []
      
    case .body:
      return composer.bodies
      
    case .smoke:
      return composer.smokes
      
    case .head:
      return composer.heads
      
    case .headphones:
      return composer.headphones

    case .beard:
      return composer.beards
    case .chain:
      return composer.chains
    case .eyes:
      return composer.eyes
    case .hatOverHeadphones:
      return composer.hatOverHeadphones
    case .hatUnderHeadphones:
      return composer.hatUnderHeadphones
    case .longHair:
      return composer.longHairs
    case .mouth:
      return composer.mouths
    case .shirt:
      return composer.shirts
    case .shortHair:
      return composer.shortHairs
    case .watch:
      return composer.watches
    }
  }
  
  /// This is the order that the assets and traits should be presented in order to replicate how the nouns should look
  static let layeredOrder: [SlotMachine.TraitType] = [.background, .body, .smoke, .head, .beard, .chain, .eyes, .longHair, .shortHair, .hatUnderHeadphones, .headphones, .hatOverHeadphones, .mouth, .watch, .shirt]
  
  var description: String {
    switch self {
    case .background:
      return R.string.shared.background()
      
    case .body:
      //      return R.string.shared.accessory()
      return "Body"
      
    case .smoke:
      //      return R.string.shared.accessory()
      return "Smoke"
      
    case .head:
      //      return R.string.shared.head()
      return "Head"
      
    case .headphones:
      //      return R.string.shared.glasses()
      return "Headphones"
      
    case .beard:
      //    return R.string.shared.beard()
      return "Beard"
      
    case .chain:
      //    return R.string.shared.chain()
      return "Chain"
      
    case .eyes:
      //    return R.string.shared.eyes()
      return "Eyes"
      
    case .hatOverHeadphones:
      //    return R.string.shared.hatOverHeadphones()
      return "Hat Over Headphones"
      
    case .hatUnderHeadphones:
      //    return R.string.shared.hatUnderHeadphones()
      return "Hat Under Headphones"
      
    case .longHair:
      //    return R.string.shared.longHair()
      return "Long Hair"
      
    case .mouth:
      //    return R.string.shared.mouth()
      return "Mouth"
      
    case .shirt:
      //    return R.string.shared.shirt()
      return "Shirt"
      
    case .shortHair:
      //    return R.string.shared.shortHair()
      return "Short Hair"
      
    case .watch:
      //    return R.string.shared.watch()
      return "Watch"
      
    }
  }
}
