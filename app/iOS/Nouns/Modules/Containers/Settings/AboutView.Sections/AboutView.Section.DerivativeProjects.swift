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

struct DerivativeProjectsInfoSection: View {
  
  /// A boolean to load the noun.center link using a browser.
  @State private var isNounsCenterPresented = false
  
  /// A boolean to load the what are mfers link using a browser.
  @State private var isWhatAreMfersPresented = false
  
  /// A boolean to load the twitter links using a browser.
  @State private var isTwitterPresented = false
  @State private var selectedAccount = ""
  
  /// Holds a reference to the localized text.
  private let localize = R.string.derivativeProjects.self
  
  let teamMembers = [TeamInfoSection.TeamMember(id: "sartoshi_rip", image: R.image.sartoshiPfp),
                     TeamInfoSection.TeamMember(id: "unofficialmfers", image: R.image.mfersPfp)]
  
  var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      
      AboutView.SectionTitle(
        title: localize.title(),
        subtitle: localize.message())
      
      OutlineButton(
        text: localize.nounsCenterTitle(),
        smallAccessory: { Image.smArrowOut },
        action: { isNounsCenterPresented.toggle() })
        .controlSize(.large)
      
      OutlineButton(
        text: localize.whatAreMfersTitle(),
        smallAccessory: { Image.smArrowOut },
        action: { isWhatAreMfersPresented.toggle() })
        .controlSize(.large)
      
      ForEach(teamMembers) { teamMember in
        OutlineButton(
          text: "@\(teamMember.id)",
          largeIcon: { Image(teamMember.image.name) },
          smallAccessory: { Image.smArrowOut },
          action: {
            selectedAccount = teamMember.id
            isTwitterPresented = true
          }
        )
        .controlSize(.large)
      }
    }
    .fullScreenCover(isPresented: $isTwitterPresented) {
      if let url = URL(string: "https://twitter.com/\(selectedAccount)") {
        Safari(url: url)
      }
    }
    .fullScreenCover(isPresented: $isNounsCenterPresented) {
      if let url = URL(string: localize.nounsCenterLink()) {
        Safari(url: url)
      }
    }
    .fullScreenCover(isPresented: $isWhatAreMfersPresented) {
      if let url = URL(string: localize.whatAreMfersLink()) {
        Safari(url: url)
      }
    }
  }
}
