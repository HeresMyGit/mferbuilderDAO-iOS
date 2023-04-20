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
import Services

/// Builds a Noun given the traits head, glass, body, and accessory.
struct NounPuzzle: View {
  
  @Environment(\.nounComposer) private var nounComposer: NounComposer
  
  private var traits: [String] = []
  
  init(seed: Seed) {
    traits = [
      nounComposer.bodies[seed.body].assetImage,
      nounComposer.smokes[seed.smoke].assetImage,
      nounComposer.heads[seed.head].assetImage,
      nounComposer.beards[seed.beard].assetImage,
      nounComposer.chains[seed.chain].assetImage,
      nounComposer.eyes[seed.eyes].assetImage,
      nounComposer.mouths[seed.mouth].assetImage, 
      nounComposer.longHairs[seed.longHair].assetImage,
      nounComposer.shortHairs[seed.shortHair].assetImage,
      nounComposer.hatUnderHeadphones[seed.hatUnderHeadphones].assetImage,
      nounComposer.headphones[seed.headphones].assetImage,
      nounComposer.hatOverHeadphones[seed.hatOverHeadphones].assetImage,
      nounComposer.shirts[seed.shirt].assetImage,
      nounComposer.watches[seed.watch].assetImage
    ]
    
    if nounComposer.backgroundColors.count >= seed.background {
      let background = nounComposer.backgroundColors[seed.background] 
      traits.insert(background, at: 0)
    }
  }
  
  init(head: String, body: String, glasses: String, accessory: String) {
    traits = [body, accessory, head, glasses]
  }
  
  public var body: some View {
    ZStack {
      ForEach(traits, id: \.self) {
        Image(nounTraitName: $0)
          .interpolation(.none)
          .resizable()
      }
    }
    .scaledToFit()
  }
}
