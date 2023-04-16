// Copyright (C) 2022 Nouns Collective
//
// Originally authored by heresmy.eth
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
import NounsUI
import ZoraAPI

extension ExploreExperience {
  
  /// Displays Settled Auction Feed.
  struct MfersFeed: View {
    @ObservedObject var viewModel: ViewModel
    
    @State private var selectedAuction: Auction?
    
    @StateObject var collection = NFTCollectionLoader(.collectionAddress("0x79fcdef22feed20eddacbb2587640e45491b757f"), removeFirst: false, sort: .transferred, showSales: true)
    
    private let gridLayout = [
      GridItem(.flexible(), spacing: 16),
      GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
      VStack {
        VPageGrid(
          collection.tokens,
          columns: gridLayout,
          isLoading: collection.isLoading,
          shouldLoadMore: collection.nextPageInfo.hasNextPage,
          loadMoreAction: {
            // load next settled auctions batch.
            await collection.loadNextPage()
          }, placeholder: {
            // An activity indicator while loading auctions from the network.
            CardPlaceholder(count: viewModel.isInitiallyLoadingSettledAuctions ? 4 : 2)
            
          }, content: { nft in
            MfersSaleCard(viewModel: .init(auction: viewModel.mferSale(from: nft)))
              .onTapGesture {
                withAnimation(.spring()) {
                  selectedAuction = viewModel.mferSale(from: nft)
                }
              }
              .onWidgetOpen {
                if selectedAuction != nil {
                  selectedAuction = nil
                }
              }
          }
        )
        // Presents more details about the settled auction.
        .fullScreenCover(item: $selectedAuction, onDismiss: {
          selectedAuction = nil
          
        }, content: { auction in
          NounProfileInfo(viewModel: .init(auction: auction, truncateUI: true), truncateUI: true)
        })
        
        if viewModel.failedToLoadSettledAuctions {
          TryAgain(
            message: viewModel.auctions.isEmpty ? R.string.explore.settledErrorEmpty() : R.string.explore.settledErrorLoadMore(),
            buttonText: R.string.shared.tryAgain(),
            retryAction: {
//              viewModel.loadAuctions()
            }
          )
          .padding(.bottom, 20)
        }
      }
      .onAppear {
//        viewModel.loadAuctions()
        Task {
          await viewModel.listenSettledAuctionsChanges()
        }
      }
    }
  }
}
