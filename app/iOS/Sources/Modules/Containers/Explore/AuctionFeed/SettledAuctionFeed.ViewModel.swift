//
//  SettledAuctionFeed.ViewModel.swift
//  Nouns
//
//  Created by Ziad Tamim on 16.12.21.
//

import Foundation
import Services

extension SettledAuctionFeed {
  
  class ViewModel: ObservableObject {
    @Published var auctions = [Auction]()
    @Published var isFetching = false
    
    private let pageLimit = 20
    private var service: OnChainNounsService
    
    init(service: OnChainNounsService = AppCore.shared.onChainNounsService) {
      self.service = service
    }
    
    @MainActor
    func watchNewlyAuctions() async {
      for await auction in service.settledAuctionsDidChange() {
        if !auctions.isEmpty && auctions.first?.id != auction.id {
          auctions.insert(auction, at: 0)
        }
      }
    }
    
    @MainActor
    func loadAuctions() async {
      do {
        isFetching = true
        // load next batch of the settled auctions from the network.
        auctions += try await service.fetchAuctions(
          settled: true,
          limit: pageLimit,
          cursor: auctions.count
        )
        
      } catch { }
      
      isFetching = false
    }
  }
}

extension SettledAuctionCard {
  
  class ViewModel: ObservableObject {
    @Published private(set) var title: String
    @Published private(set) var nounTraits: Seed
    @Published private(set) var nounBackground: String
    @Published private(set) var winnerBid: String
    
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
      
      let bid = EtherFormatter.eth(from: auction.amount)
      winnerBid = bid ?? R.string.shared.notApplicable()
      
      let backgroundIndex = auction.noun.seed.background
      nounBackground = composer.backgroundColors[backgroundIndex]
    }
  }
}
