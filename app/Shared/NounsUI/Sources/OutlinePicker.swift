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

/// Accessing the current selected tab in the environment.
struct OutlinePickerSelection: EnvironmentKey {
  static var defaultValue: Int = 0
}

extension EnvironmentValues {
  
  var outlinePickerSelection: Int {
    get { self[OutlinePickerSelection.self] }
    set { self[OutlinePickerSelection.self] = newValue }
  }
}

/// Accessing the newly selected tab triggered by child views
struct OutlinePickerSelectionChange: PreferenceKey {
  static var defaultValue: Int = 0
  static func reduce(value: inout Int, nextValue: () -> Int) {
    value = nextValue()
  }
}

/// The picker tab item.
internal struct OutlinePickerItem: ViewModifier {
  @Environment(\.outlinePickerSelection) private var selection
  @State private var isSelected = false
  private let namespace: Namespace.ID
  private let tag: Int
  
  internal init(_ tag: Int, namespace: Namespace.ID) {
    self.tag = tag
    self.namespace = namespace
  }
  
  internal func body(content: Content) -> some View {
    content
      .font(font)
      .foregroundColor(foregroundColor)
      .padding(.horizontal, 15)
      .frame(height: 36)
      .background(
        Group {
          // TODO: Fix the glitch hapening on the animation by moving the code to the parent view.
          if isSelected {
            activeTabBackground
              .matchedGeometryEffect(id: "SlideActiveTabID", in: namespace)
          }
        }
      )
      .preference(key: OutlinePickerSelectionChange.self, value: isSelected ? tag : selection)
      .onTapGesture {
        withAnimation(.spring(blendDuration: 0.05)) {
          isSelected = true
        }
      }
      .onChange(of: selection) { newValue in
        if newValue != tag {
          isSelected = false
        }
      }
      .onAppear {
        isSelected = (selection == tag)
      }
      .onChange(of: selection, perform: { newValue in
        withAnimation(.spring(blendDuration: 0.05)) {
          isSelected = (newValue == tag)
        }
      })
  }
  
  private var font: Font {
      .custom(isSelected ? .medium : .regular, relativeTo: .footnote)
  }
  
  private var foregroundColor: Color {
    .componentNounsBlack.opacity(isSelected ? 1 : 0.8)
  }
  
  private var activeTabBackground: some View {
    RoundedRectangle(cornerRadius: 6)
      .stroke(.black, lineWidth: 2)
      .background(
        RoundedRectangle(cornerRadius: 6)
          .fill(.white)
      )
  }
}

// TODO: Remove the namespace from the view modifier, and use Anchor instead to move the background for the selected tab.
extension View {
  
  /// Sets the picker tab item.
  /// - Parameters:
  ///   - tag: Sets the unique tag value of this view.
  ///   - namespace: A namespace defined by the persistent identity.
  public func pickerItemTag(_ tag: Int, namespace: Namespace.ID) -> some View {
    modifier(OutlinePickerItem(tag, namespace: namespace))
  }
}

// TODO: Set the selection to conform to `Hashable` instead of `Int`.

/// A control for selecting from a set of mutually exclusive values.
public struct OutlinePicker<Content>: View where Content: View {
  @Binding private var selection: Int
  private let content: Content
  
  ///  create a picker by providing a selection binding, and
  ///  the content for the picker to display.
  ///
  /// ```swift
  ///     OutlinePicker(selection: $selection) {
  ///     Text("Activities")
  ///         .pickerItemTag(0, namespace: slideActiveTabSpace)
  ///
  ///     Text("Big history")
  ///         .pickerItemTag(1, namespace: slideActiveTabSpace)
  ///     }
  ///     .padding()
  /// ```
  /// - Parameters:
  ///     - selection: A binding to a property that determines the
  ///       currently-selected option.
  ///     - content: A view that contains the set of options.
  public init(
    selection: Binding<Int>,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.content = content()
    self._selection = selection
  }
  
  public var body: some View {
    HStack {
      content
        .environment(\.outlinePickerSelection, selection)
        .onPreferenceChange(OutlinePickerSelectionChange.self) { newSelectedTab in
          selection = newSelectedTab
        }
    }
    .padding(.horizontal, 5)
    .frame(height: 44)
    .background(Color.black.opacity(0.05))
    .cornerRadius(9)
  }
}

// TODO: Removes the preview when all the TODOs have been addressed.
struct OutlinePicker_preview: PreviewProvider {
  
  struct OutlinePickerView: View {
    @Namespace private var slideActiveTabSpace
    @State var selection: Int = 0
    
    var body: some View {
      ZStack {
        Gradient.orangesicle
          .ignoresSafeArea()
        
        OutlinePicker(selection: $selection) {
          Text("Activities")
            .pickerItemTag(0, namespace: slideActiveTabSpace)
          
          Text("Big history")
            .pickerItemTag(1, namespace: slideActiveTabSpace)
        }
        .padding()
      }
    }
  }
  
  static var previews: some View {
    OutlinePickerView()
      .onAppear {
        NounsUI.configure()
      }
  }
}
