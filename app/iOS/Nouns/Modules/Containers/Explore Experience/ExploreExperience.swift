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
import ZoraAPI

/// Housing view for exploring on chain nouns, including
/// the current on-goign auction and previously auctioned nouns
struct ExploreExperience: View {
  @StateObject var viewModel = ViewModel()
  
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  
  @State private var isMadhappySheetPresented = false
  @State private var isMferSelected = true
  
  @StateObject var collection = NFTCollectionLoader(.collectionAddress("0x795D300855069F602862c5e23814Bdeeb25DCa6b"), removeFirst: false, perPage: 1)
  @StateObject var highBid = HighBidLoader()
  
  @State private var searchText = ""

  var body: some View {
    NavigationView {
      ScrollView(.vertical, showsIndicators: false) {
        if isMferSelected {
                mfers
            } else {
                mferbuilderDAO
            }
      }
      .disabled(viewModel.isLoadingSettledAuctions)
      .background(Gradient.mferOrange)
      .overlay(.componentMferOrange, edge: .top)
      .ignoresSafeArea(edges: .top)
      .refreshable {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "Refresh")))
        await highBid.load()
        await collection.load()
      }
    }
    .onAppear {
      viewModel.onAppear()
      Task {
        await viewModel.listenLiveAuctionChanges()
      }
    }
    .navigationViewStyle(StackNavigationViewStyle())
    
  }
  
  var mferbuilderDAO: some View {
    VStack(spacing: 16) {
      if let nft = collection.tokens.first, let bid = highBid.highBidder {
        LiveAuctionCard(viewModel: .init(auction: viewModel.auction(from: nft), winner: bid))
      } else if let nft = collection.tokens.first {
        LiveAuctionCard(viewModel: .init(auction: viewModel.auction(from: nft)))
      } else if viewModel.failedToLoadLiveAuction {
        LiveAuctionCardErrorPlaceholder(viewModel: viewModel)
      } else {
        LiveAuctionCardPlaceholder()
      }

      SettledAuctionFeed(viewModel: viewModel)
    }
    .padding(.bottom, tabBarHeight)
    .padding(.bottom, 20) // Extra padding between the bottom of the last noun card and the top of the tab view
    .padding(.horizontal, 20)
    .emptyPlaceholder(when: viewModel.failedToLoadExplore) {
      EmptyErrorView(viewModel: viewModel)
        .padding()
    }
    .softNavigationTitle(R.string.explore.title(), rightAccessory: {
      HStack {
        SoftButton {
          Text(isMferSelected ? "mfers" : "mferbuilderDAO")
            .font(.custom(.bold, relativeTo: .title3))
            .padding()
        } action: {
          isMferSelected.toggle()
        }
      }
    })
    
    .id(AppPage.explore.scrollToTopId)
  }
  
  var mfers: some View {
    MfersFeed(viewModel: viewModel)
    .padding(.bottom, tabBarHeight)
    .padding(.bottom, 20) // Extra padding between the bottom of the last noun card and the top of the tab view
    .padding(.horizontal, 20)
    .emptyPlaceholder(when: viewModel.failedToLoadExplore) {
      EmptyErrorView(viewModel: viewModel)
        .padding()
    }
    .softNavigationTitle(R.string.explore.title(), rightAccessory: {
      HStack {
        SoftButton {
          Text(isMferSelected ? "mfers" : "mferbuilderDAO")
            .font(.custom(.bold, relativeTo: .title3))
            .padding()
        } action: {
          isMferSelected.toggle()
        }
      }
    })
    
    .id(AppPage.explore.scrollToTopId)
  }
}

// Quick and dirty copy of NFTCollector to get the highest bidder.
// I know I know, I should be extending the current ZoraKit graphQL
// schema to include these, but the creators didn't include their setup
// files and I don't want to spend the time to start over and set up
// graphQL from scratch.  mfers do what they want.
@MainActor
public class HighBidLoader: ObservableObject {
  @Published public var highBidder: String = "" { willSet { objectWillChange.send() } }
  @Published public var isLoading: Bool = false
  
    public init() {
    Task(priority: .userInitiated) {
      await load()
    }
  }
  
  public func load() async {
    do {
      isLoading = true
      highBidder = try await AppCore.shared.onChainNounsService.fetchAuctionHighestBidder()
      isLoading = false
    } catch {
      // Errors...
      // these should be able to be called back from the
      // Set and save these in a way on this loader so clients can understand what happened.
      isLoading = false
    }
  }
}
