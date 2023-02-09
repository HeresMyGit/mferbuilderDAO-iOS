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

extension MferSlotMachine {

  struct Segment: View {
    
    @GestureState private var dragOffset: CGFloat = 0
    
    @Binding var seed: Seed

    let type: MferSlotMachine.TraitType
    
    let currentModifiableTraitType: MferSlotMachine.TraitType
    
    let showAllTraits: Bool
    
    let imageWidth: Double
    
    /// A utility function to determine the opacity of the trait images
    /// If the type is currently selected (e.g. head) then all traits should be shown which may include images on the left or right of the main centered trait.
    /// If the type is NOT selected, then it should only show the trait that is currently selected in the centre and none on the sides.
    private func opacity(forIndex index: Int) -> Double {
      guard !showAllTraits else { return 1 }
      
      if currentModifiableTraitType == type {
        return 1
      } else {
        return isSelected(index, traitType: type) ? 1 : 0
      }
    }
    
    public var body: some View {
      GeometryReader { _ in
        LazyHStack(spacing: 0) {
          ForEach(0..<type.traits.count, id: \.self) { index in
            
            // Displays Noun's Trait Image.
            Image(nounTraitName: type.traits[index].assetImage)
              .interpolation(.none)
              .resizable()
              .frame(
                width: CGFloat(imageWidth),
                height: CGFloat(imageWidth)
              )
              .opacity(opacity(forIndex: index))
          }
        }
        .padding(.horizontal, (UIScreen.main.bounds.width - imageWidth) / 2)
        .offset(x: traitOffset(for: type, by: dragOffset))
        .gesture(onDrag)
        .allowsHitTesting(isDraggingEnabled(for: type))
        .animation(.easeInOut, value: dragOffset == 0)
      }
    }
    
    /// Handles Drag Gesture to navigate across different `Noun's Traits`.
    private var onDrag: some Gesture {
      DragGesture()
        .updating($dragOffset, body: { value, state, _ in
          state = value.translation.width
        })
        .onEnded({ value in
          // A negative horizontal velocity is a gesture starting from the right of the screen towards the left
          // A positive horizontal velocity is a gesture starting from the left of the screen towards the right
          let horizontalVelocity = value.predictedEndLocation.x - value.location.x
          didScroll(withVelocity: horizontalVelocity)
        })
    }
    
    /// Selecting a trait by swiping left or right on the noun
    func didScroll(withVelocity velocity: Double) {
      // Only allow swiping between traits if the difference between the predicted
      // gesture end location and the final drag location is greater than the scroll threshold.
      guard abs(velocity) >= 40 else { return }
      
      // If direction is negative, we should go to the next (right) trait
      // If direction is positive, we should go to the previous (left) trait
      let index: Int = velocity > 0 ? -1 : 1
      
      // Set Bounderies to not scroll over empty.
      let maxLimit = currentModifiableTraitType.traits.endIndex - 1
      let minLimit = 0
      
      switch currentModifiableTraitType {
      case .background:
        break
        
      case .smoke:
        seed.smoke = max(
          min(seed.smoke + index, maxLimit),
          minLimit)
        
      case .head:
        seed.head = max(
          min(seed.head + index, maxLimit),
          minLimit)
        
      case .headphones:
        seed.headphones = max(
          min(seed.headphones + index, maxLimit),
          minLimit)
        
      case .beard:
        seed.beard = max(
          min(seed.beard + index, maxLimit),
          minLimit)
        
      case .chain:
        seed.chain = max(
          min(seed.chain + index, maxLimit),
          minLimit)
        
      case .eyes:
        seed.eyes = max(
          min(seed.eyes + index, maxLimit),
          minLimit)
        
      case .hatOverHeadphones:
        seed.hatOverHeadphones = max(
          min(seed.hatOverHeadphones + index, maxLimit),
          minLimit)
        
      case .hatUnderHeadphones:
        seed.hatUnderHeadphones = max(
          min(seed.hatUnderHeadphones + index, maxLimit),
          minLimit)
        
      case .longHair:
        seed.longHair = max(
          min(seed.longHair + index, maxLimit),
          minLimit)
        
      case .mouth:
        seed.mouth = max(
          min(seed.mouth + index, maxLimit),
          minLimit)
        
      case .shirt:
        seed.shirt = max(
          min(seed.shirt + index, maxLimit),
          minLimit)
        
      case .shortHair:
        seed.shortHair = max(
          min(seed.shortHair + index, maxLimit),
          minLimit)
        
      case .watch:
        seed.watch = max(
          min(seed.watch + index, maxLimit),
          minLimit)
      }
    }
    
    /// Returns a boolean indicating if an index is the selected index given a trait type
    func isSelected(_ index: Int, traitType: TraitType) -> Bool {
      switch traitType {
      case .background:
        return index == seed.background
      case .smoke:
        return index == seed.smoke
      case .head:
        return index == seed.head
      case .headphones:
        return index == seed.headphones
      case .beard:
        return index == seed.beard
      case .chain:
        return index == seed.chain
      case .eyes:
        return index == seed.eyes
      case .hatOverHeadphones:
        return index == seed.hatOverHeadphones
      case .hatUnderHeadphones:
        return index == seed.hatUnderHeadphones
      case .longHair:
        return index == seed.longHair
      case .mouth:
        return index == seed.mouth
      case .shirt:
        return index == seed.shirt
      case .shortHair:
        return index == seed.shortHair
      case .watch:
        return index == seed.watch
      }
    }
    
    /// Moves the currently selected `Noun's Trait` by the given offset.
    func traitOffset(for type: TraitType, by offsetX: Double = 0) -> Double {
      switch type {
      case .background:
        return 0
        
      case .smoke:
        return (Double(seed.smoke) * -imageWidth) + offsetX
        
      case .head:
        return (Double(seed.head) * -imageWidth) + offsetX
        
      case .headphones:
        return (Double(seed.headphones) * -imageWidth) + offsetX
        
      case .beard:
        return (Double(seed.beard) * -imageWidth) + offsetX
        
      case .chain:
        return (Double(seed.chain) * -imageWidth) + offsetX
        
      case .eyes:
        return (Double(seed.eyes) * -imageWidth) + offsetX
        
      case .hatOverHeadphones:
        return (Double(seed.hatOverHeadphones) * -imageWidth) + offsetX
        
      case .hatUnderHeadphones:
        return (Double(seed.hatUnderHeadphones) * -imageWidth) + offsetX
        
      case .longHair:
        return (Double(seed.longHair) * -imageWidth) + offsetX
        
      case .mouth:
        return (Double(seed.mouth) * -imageWidth) + offsetX
        
      case .shirt:
        return (Double(seed.shirt) * -imageWidth) + offsetX
        
      case .shortHair:
        return (Double(seed.shortHair) * -imageWidth) + offsetX
        
      case .watch:
        return (Double(seed.watch) * -imageWidth) + offsetX
      }
    }
    
    /// Recognizes if the drag gesture should be enabled.
    /// - Parameter type: The Noun's `Trait Type` to validate.
    func isDraggingEnabled(for type: MferSlotMachine.TraitType) -> Bool {
      currentModifiableTraitType == type
    }
  }
}
