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

import Foundation
import Services

extension SettledAuctionCard {
  
  class ViewModel: ObservableObject {
    
    /// The noun's ID.
    @Published private(set) var title: String
    
    /// The noun's traits.
    @Published private(set) var nounTraits: Seed
    
    /// The noun's background.
    @Published private(set) var nounBackground: String
    
    /// The winning bid on the settled auction.
    @Published private(set) var winnerBid: String
    
    /// The state to display the owner's domain on nounder noun.
    @Published private(set) var showENS = false
    
    /// The nounder token that owns the noun.
    @Published private(set) var nounderToken: String
    
    /// The state of whether or not the noun is owned by nounders
    @Published private(set) var isNounderOwned = false
    
    private let auction: Auction
    private let composer: NounComposer
    
    init(
      auction: Auction,
      composer: NounComposer = AppCore.shared.nounComposer
    ) {
      self.auction = auction
      self.composer = composer
      
      title = R.string.explore.noun(auction.noun.id)
      nounTraits = auction.noun.seed
      
      let bid = EtherFormatter.eth(from: auction.amount, minimumFractionDigits: 2, maximumFractionDigits: 16)
      winnerBid = bid ?? R.string.shared.notApplicable()
      
      let backgroundIndex = auction.noun.seed.background
      nounBackground = composer.backgroundColors[backgroundIndex]
      
      isNounderOwned = auction.noun.isNounderOwned
      showENS = auction.noun.isNounderOwned
      nounderToken = auction.noun.owner.id
    }
  }
}
