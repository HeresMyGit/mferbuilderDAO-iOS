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
import NounsUI
import Services
import Combine

struct SlotMachine: View {
  
  /// List all various `Noun's Traits Types`.
  enum TraitType: Int, CaseIterable, Hashable {
    case background
    case head
    case headphones
    case smoke
    case beard
    case chain
    case eyes
    case hatOverHeadphones
    case hatUnderHeadphones
    case longHair
    case mouth
    case shirt
    case shortHair
    case watch
  }
  
  /// The initial seed of the noun creator, reflecting which traits are selected and displayed initially
  public var initialSeed: Seed
  
  /// A boolean to determine if the shadow should be visible below the noun
  public var showShadow: Bool
  
  /// A boolean to determine if the noun's `initialSeed` should animate into place
  public var animateEntrance: Bool
  
  private let nounComposer: NounComposer = AppCore.shared.nounComposer
  
  /// `Noun's Trait` default image size.
  public static let defaultImageSize: Double = 320
  
  /// The width of the noun (and height as the slot machine will be placed in a 1:1 aspect ratio)
  private let imageWidth: Double
  
  /// The threshold at which a swipe is registered as a next/previous advancement. The scroll's direction value
  /// is compared absolutely to this threshold value.
  ///
  /// Values below this threshold will not change the current trait value
  /// Values above this threshold will change the current trait value by a negative or positive index
  /// depending on the non-absolute value of the direction
  private static let scrollThreshold: Double = 40
  
  /// The current `Seed` in the slot machine
  @Binding var seed: Seed
  
  @Binding public var showAllTraits: Bool
  
  /// Indicates the current modifiable trait type selected in the slot machine.
  @Binding var currentModifiableTraitType: TraitType
    
  init(
    seed: Binding<Seed>,
    shouldShowAllTraits: Binding<Bool>,
    initialSeed: Seed = Seed.default,
    currentModifiableTraitType: Binding<TraitType> = .constant(.headphones),
    showShadow: Bool = true,
    animateEntrance: Bool = false,
    imageWidth: Double = SlotMachine.defaultImageSize
  ) {
    self.initialSeed = initialSeed
    self.showShadow = showShadow
    self.animateEntrance = animateEntrance
    self.imageWidth = imageWidth
    self._currentModifiableTraitType = currentModifiableTraitType
    self._showAllTraits = shouldShowAllTraits
    self._seed = seed
  }
  
  /// Sets the seed to a new randomly generated seed
  func randomizeSeed() {
    seed = nounComposer.randomSeed()
  }
  
  /// Resets the seed to the `initialSeed`
  func resetToInitialSeed() {
    seed = initialSeed
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      // An image of the shadow below the noun
      Image(R.image.shadow.name)
        .offset(y: 40)
        .padding(.horizontal, 20)
        .hidden(!showShadow)
      
      ZStack(alignment: .top) {
        let types: [TraitType] = [.background, .head, .smoke, .headphones]
        ForEach(types, id: \.self) { type in
          Segment(
            seed: $seed,
            type: type,
            currentModifiableTraitType: currentModifiableTraitType,
            showAllTraits: showAllTraits,
            imageWidth: imageWidth
          )
        }
      }
      .frame(maxHeight: imageWidth)
      .drawingGroup()
    }
    .onAppear {
      // A small delay is needed so that all the animation logic
      // happens after the view is rendered in it's complete form
      // at least once. If the animation logic + the appearance of the
      // view happens at the same time, the entire view will animate
      // into place (including the navigation title and background)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        
        // Animate the slot machine's seed if `animateEntrance` is
        // set to true. It will set the seed to something random,
        // show all the neighbouring traits for all trait types.
        // then animate the transition back to the original initial seed,
        // finally hiding all the neighbouring traits at the end
        if animateEntrance {
          randomizeSeed()
          showAllTraits = true
          
          withAnimation(.spring(response: 2.0, dampingFraction: 1.0, blendDuration: 1.0)) {
            resetToInitialSeed()
          }
          
          withAnimation(.spring().delay(3.0)) {
            self.showAllTraits = false
          }
        }
      }
    }
  }
}
