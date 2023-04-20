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
import Combine
import NounsUI
import SpriteKit

/// Display the auction of the day in real time.
struct LiveAuctionCard: View {
  
  static let liveAuctionMarqueeString = Array(repeating: R.string.shared.liveAuction().uppercased(), count: 10).joined(separator: "        ").appending("        ")
  
  @ObservedObject var viewModel: ViewModel
  
  @State private var showNounProfile = false
  
  @State private var width: CGFloat = 100
  
  /// A view that displays an animated noun.
  ///
  /// - Returns: This view contains the play scene to animate the Noun's eyes.
  private let talkingNoun: TalkingNoun
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    talkingNoun = TalkingNoun(seed: viewModel.auction.noun.seed)
  }
  
  var body: some View {
    StandardCard(
      header: viewModel.title, accessory: {
        Image.mdArrowCorner
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
      },
      media: {
        VStack(spacing: 0) {
//          SpriteView(scene: talkingNoun, options: [.allowsTransparency])
          NounPuzzle(seed: viewModel.auction.noun.seed)
            .id(viewModel.auction.id)
            .background(
              GeometryReader { proxy in
                Color(hex: viewModel.nounBackground)
                  .onAppear {
                    self.width = proxy.size.width
                  }
              }
            )
            .frame(
              minWidth: 100,
              idealWidth: self.width,
              maxWidth: .infinity,
              minHeight: 100,
              idealHeight: self.width,
              maxHeight: .infinity,
              alignment: .center
            )
            
          MarqueeText(text: LiveAuctionCard.liveAuctionMarqueeString, alignment: .center, font: UIFont.custom(.bold, size: 14))
            .padding(.top, 5)
            .padding(.bottom, 4)
            .border(width: 2, edges: [.top], color: .componentNounsBlack)
            .background(Color.white)
        }
      },
      content: {
        HStack {
          Group {
            if viewModel.isWinnerAnnounced {
              // Displays the winner.
              CompoundLabel({
                ENSText(token: viewModel.winner)
                  .font(.custom(.medium, relativeTo: .footnote))
              }, icon: Image.crown, caption: R.string.liveAuction.winner())
              
            } else {
              // Displays remaining time.
              CompoundLabel({
                CountdownLabel(endTime: viewModel.auction.endTime)
              },
              icon: Image.timeleft,
              caption: R.string.liveAuction.timeLeftLabel())
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          // Displays Bid Status.
          CompoundLabel({
            SafeLabel(viewModel.lastBid, icon: Image.eth) },
                        icon: Image.currentBid,
                        caption: viewModel.bidStatus)
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 20)
      })
      .headerStyle(.large)
      .onTapGesture {
        showNounProfile.toggle()
      }
      .fullScreenCover(isPresented: $showNounProfile) {
        NounProfileInfo(viewModel: .init(auction: viewModel.auction, winner: viewModel.winner))
      }
      .onWidgetOpen {
//        AppCore.shared.analytics.logEvent(withEvent: .openAppFromWidget, parameters: ["noun_id": viewModel.auction.noun.id])
        if !showNounProfile {
          DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            showNounProfile = true
          }
        }
      }
  }
}


struct MferCard: View {
  
  static let liveAuctionMarqueeString = Array(repeating: R.string.shared.liveAuction().uppercased(), count: 10).joined(separator: "        ").appending("        ")
  
  @ObservedObject var viewModel: ViewModel
  
  @State private var showNounProfile = false
  
  @State private var width: CGFloat = 100
  
  /// A view that displays an animated noun.
  ///
  /// - Returns: This view contains the play scene to animate the Noun's eyes.
  private let talkingNoun: TalkingNoun
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    talkingNoun = TalkingNoun(seed: viewModel.auction.noun.seed)
  }
  
  var body: some View {
    StandardCard(
      header: viewModel.title, accessory: {
        Image.mdArrowCorner
          .resizable()
          .scaledToFit()
          .frame(width: 24, height: 24)
      },
      media: {
        VStack(spacing: 0) {
          NounPuzzle(seed: viewModel.auction.noun.seed)
            .id(viewModel.auction.id)
            .background(
              GeometryReader { proxy in
                Color(hex: viewModel.nounBackground)
                  .onAppear {
                    self.width = proxy.size.width
                  }
              }
            )
            .frame(
              minWidth: 100,
              idealWidth: self.width,
              maxWidth: .infinity,
              minHeight: 100,
              idealHeight: self.width,
              maxHeight: .infinity,
              alignment: .center
            )
          let text = Array(repeating: "mfer \(viewModel.auction.noun.id)".uppercased(), count: 10).joined(separator: "        ").appending("        ")
          MarqueeText(text: text, alignment: .center, font: UIFont.custom(.bold, size: 14))
            .padding(.top, 5)
            .padding(.bottom, 4)
            .border(width: 2, edges: [.top], color: .componentNounsBlack)
            .background(Color.white)
        }
      },
      content: {
        HStack {
          Group {
            // Displays the winner.
            CompoundLabel({
              ENSText(token: viewModel.auction.noun.owner.id)
                .font(.custom(.medium, relativeTo: .footnote))
            }, icon: Image.holder, caption: "Owner")
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          // Displays Bid Status.
//          CompoundLabel({
//            SafeLabel(viewModel.lastBid, icon: Image.eth) },
//                        icon: Image.currentBid,
//                        caption: viewModel.bidStatus)
//          .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 20)
      })
      .headerStyle(.large)
      .onTapGesture {
        showNounProfile.toggle()
      }
      .fullScreenCover(isPresented: $showNounProfile) {
        NounProfileInfo(viewModel: .init(auction: viewModel.auction, winner: viewModel.auction.noun.owner.id, isMferSale: true))
      }
      .onWidgetOpen {
//        AppCore.shared.analytics.logEvent(withEvent: .openAppFromWidget, parameters: ["noun_id": viewModel.auction.noun.id])
        if !showNounProfile {
          DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
            showNounProfile = true
          }
        }
      }
  }
}
