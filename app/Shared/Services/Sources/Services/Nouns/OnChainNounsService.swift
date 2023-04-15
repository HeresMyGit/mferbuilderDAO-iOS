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
import Combine
import CoreData
import web3
import BigInt

/// `onChainNounsService` request error.
public enum OnChainNounsRequestError: Error {
  
  /// The response is empty
  case noData
}

/// Service allows interacting with the `OnChain Nouns`.
public protocol OnChainNounsService: AnyObject {
  
  /// Asynchronously fetch the Nouns treasury from the eth network.
  ///
  /// - Returns: The total amount stored of `Ether + staked Ether in Lido`.
  func fetchTreasury() async throws -> String
  
  /// Fetches a single noun given an `id`
  ///
  /// - Parameters:
  ///   - id: The id of the noun to fetch
  ///
  /// - Returns: A single, optional, instance of a `Noun` type or throw an error.
  func fetchNoun(withId id: String) async throws -> Noun?
  
  /// Asynchronously fetches the list of the settled Nouns from the chain.
  ///
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A list of `Noun` type  instance or throw an error.
  func fetchSettledNouns(limit: Int, after cursor: Int) async throws -> Page<[Noun]>
  
  /// Asynchronously fetches the list of auction settled from the chain.
  ///
  /// - Parameters:
  ///   - settled: Whether or not the auction has been settled.
  ///   - includeNounderOwned: Whether or not to include nouns owned by nounders (every 10th noun)
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A list of `Auction` type  instance or throw an error.
  func fetchAuctions(settled: Bool, includeNounderOwned: Bool, limit: Int, cursor: Int, sortDescending: Bool) async throws -> Page<[Auction]>
    
  func fetchMferAuctions(settled: Bool, includeNounderOwned: Bool, limit: Int, cursor: Int, sortDescending: Bool) async throws -> [Auction]
  
  /// An asynchronous sequence that  produce the live auction and
  /// react to its properties changes
  ///
  /// - Returns: An `Auction` instance or throw an error.
  func liveAuctionStateDidChange() -> AsyncThrowingStream<Auction, Error>
  
  /// An asynchronous sequence that produces the last settled auction added.
  ///
  /// - Returns: An array of `Auction` instances or throw an error.
  func settledAuctionsDidChange() -> AsyncThrowingStream<[Auction], Error>
  
  /// Asynchronously fetches the list of Activities of a given Noun from the chain.
  ///
  /// - Parameters:
  ///   - nounID: A settled `Noun` identifier.
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A list of `Activity` type  instance or throw an error.
  func fetchActivity(for nounID: String, limit: Int, after cursor: Int) async throws -> Page<[Vote]>
  
  /// Asynchronously fetches the list of Bids of a given Noun from the chain.
  ///
  /// - Parameters:
  ///   - nounID: A settled `Noun` identifier.
  ///
  /// - Returns: A list of `Bid` type  instance or throw an error.
  func fetchBids(for nounID: String, limit: Int, after cursor: Int) async throws -> Page<[Bid]>
  
  /// Asynchronously fetches the list of proposals for all type status.
  ///
  /// - Parameters:
  ///   - limit: A limit up to the  `n` elements from the list.
  ///   - cursor: A cursor for use in pagination.
  ///
  /// - Returns: A list of `Proposal` type  instance or throw an error.
  func fetchProposals(limit: Int, after cursor: Int) async throws -> Page<[Proposal]>
    
  func fetchMferDetails(for mferId: String) async throws -> Mfer?
    
  func fetchAuctionHighestBidder() async throws -> String
}

/// Concrete implementation of the `onChainNounsService` using `TheGraph` Service.
public class TheGraphOnChainNouns: OnChainNounsService {
  
  private let pageProvider: PageProvider
  
  private let graphQLClient: GraphQL
  
  /// The ethereum client layer provided by `web3swift` package
  private let ethereumClient = EthereumClient(url: CloudConfiguration.Infura.mainnet.url!)
  
  /// NounsDAOExecutor contract address.
  private enum Address {
//    static let ethDAOExecutor = "0x0BC3807Ec262cB779b38D65b38158acC3bfedE10"
      static let ethDAOExecutor = "0x6D538Bab6E961dD9719Bd6f9676293989CA8D714"
    static let stEthDAOExecutor = "0xae7ab96520de3a18e5e111b5eaab095312d7fe84"
  }
  
  public convenience init() {
    self.init(graphQLClient: GraphQLClient())
  }
  
  init(graphQLClient: GraphQL) {
    self.graphQLClient = graphQLClient
    self.pageProvider = PageProvider(graphQLClient: graphQLClient)
  }
  
  private func ethTreasury() async throws -> BigUInt {
    try await withCheckedThrowingContinuation { continuation in
      ethereumClient.eth_getBalance(
        address: EthereumAddress(Address.ethDAOExecutor),
        block: .Latest
      ) { error, balance in
        if let error = error {
          return continuation.resume(throwing: error)
        }
        
        if let balance = balance {
          continuation.resume(returning: balance)
        }
      }
    }
  }
  
  private func stEthTreasury() async throws -> BigUInt {
    try await withCheckedThrowingContinuation { continuation in
      let function = ERC20Functions.balanceOf(contract: EthereumAddress(Address.stEthDAOExecutor), account: EthereumAddress(Address.ethDAOExecutor))
      
      function.call(
        withClient: ethereumClient,
        responseType: ERC20Responses.balanceResponse.self
      ) { error, balanceResponse in
        if let error = error {
          return continuation.resume(throwing: error)
        }
        
        if let balanceResponse = balanceResponse {
          continuation.resume(returning: balanceResponse.value)
        }
      }
    }
  }
  
  public func fetchTreasury() async throws -> String {
    async let eth = ethTreasury()
    async let stEth = stEthTreasury()
    
    // To match the nouns.wtf website, eth and stEth are compared as a
    // 1:1 ratio and as such are added together without conversion.
    // The precise value is slightly different
    let (ethValue, stEthValue) = try await (eth, stEth)
    return String(ethValue + stEthValue)
  }
  
  public func fetchNoun(withId id: String) async throws -> Noun? {
    let query = NounsSubgraph.NounQuery(id: id)
    let noun: Page<[Noun]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    return noun.data.first
  }
  
  public func fetchSettledNouns(limit: Int, after cursor: Int) async throws -> Page<[Noun]> {
    let query = NounsSubgraph.NounsQuery(limit: limit, skip: cursor)
    let page: Page<[Noun]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    return page
  }
  
  public func fetchAuctions(settled: Bool, includeNounderOwned: Bool, limit: Int, cursor: Int, sortDescending: Bool) async throws -> Page<[Auction]> {

    // Deduct the expected number of nounder owned nouns if `includeNounderOwned` is set to true
    let auctionLimit = limit - (includeNounderOwned ? limit / 10 : 0)
    let query = NounsSubgraph.AuctionsQuery(settled: settled, limit: auctionLimit, skip: cursor)
          
    var page: Page<[Auction]> = try await graphQLClient.fetch(
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
      
    // Fetch nounder owned nouns, if requested
//    if includeNounderOwned {
//      page = try await fetchNounderOwnedNouns(within: page)
//    }

//    // Sort page data
//    page.data = page.data.sorted(by: { auctionOne, auctionTwo in
//      guard let auctionOneId = Int(auctionOne.noun.id), let auctionTwoId = Int(auctionTwo.noun.id) else {
//        return false
//      }
//      if sortDescending {
//        return auctionOneId > auctionTwoId
//      }
//      return auctionOneId < auctionTwoId
//    })
      
      var nouns = [Noun]()
      for i in 0...5 {
          let noun = Noun(id: "\(i)", name: "mfer \(i)", owner: Account(id: "1"), seed: Seed.pizza, createdAt: Date.now, updatedAt: Date.now, nounderOwned: true)
          nouns.append(noun)
      }
      
      var auctions = [Auction]()
      for noun in nouns {
          let auction = Auction(id: "1", noun: noun, amount: "0.69", startTime: 0, endTime: 0, settled: true, bidder: Account(id: "1"))
          auctions.append(auction)
      }

    return page
  }
    
    public func fetchMferAuctions(settled: Bool, includeNounderOwned: Bool, limit: Int, cursor: Int, sortDescending: Bool) async throws -> [Auction] {
//        var nouns = [Noun]()
//        for i in 0..<5 {
//            let noun = Noun(id: "\(i)", name: "PLACEHOLDER \(i)", owner: Account(id: "1"), seed: OfflineNounComposer.default().randomSeed(), createdAt: Date.now, updatedAt: Date.now, nounderOwned: false)
//            nouns.append(noun)
//        }
//        var auctions = [Auction]()
//        for i in 0..<nouns.count {
//            let noun = nouns[i]
//            let auction = Auction(id: "\(i)", noun: noun, amount: "690000000000000000", startTime: 0, endTime: 0, settled: true, bidder: Account(id: "1"))
//            auctions.append(auction)
//        }
        var auctions = [Auction]()
        return auctions
    }
  
  /// An implementation to seperately fetch nounder owned nouns, as the GraphQL
  /// endpoint for returning auctions does not return nounder-owned nouns by default
  private func fetchNounderOwnedNouns(within page: Page<[Auction]>) async throws -> Page<[Auction]> {
    
    // Temporary modifiable instance of Page
    var newPage = page
    
    /// `lastNoun` is understood as the latest noun created in this page,
    /// with the highest numerical `nounId`, which would be presented
    /// first in the array as it is fetched sorted, with latest being first
    ///
    /// `firstNoun` is understood as the first noun created in this page,
    /// with the lowest numerical `nounId`, which would be presented
    /// last in the array as it is fetched sorted, with oldest being last
    guard let lastNoun = page.data.first?.noun,
          let firstNoun = page.data.last?.noun,
          let lastNounId = Int(lastNoun.id),
          let firstNounId = Int(firstNoun.id) else {
            return page
          }
    
    /// We add one to the end of the list (lastNounId) in the case of edge cases, where the
    /// lastNounId ends with a "9", such as 29. The following settled auction page would
    /// skip the 10th value and go straight to 31. Adding one makes sure to capture "30".
    ///
    /// Additionally, we subtract one from the start of the list (firstNounId): if the firstNounId is a "1",
    /// "0" is skipped - subtracting one makes sure to include "0".
    let end = (lastNounId + 1) - ((lastNounId + 1) % 10)
    let start = firstNounId - 1
    
    let auctions = try await withThrowingTaskGroup(of: Auction.self, returning: [Auction].self) { [weak self] taskGroup in
      
      for nounId in stride(from: end, through: start, by: -10) {
        taskGroup.addTask { [weak self] in
          guard var noun = try await self?.fetchNoun(withId: String(nounId)) else {
            throw "💥 Couldn't fetch noun id \(nounId)"
          }
          
          /// While every 10th noun does automatically go to nounders, the nounders can choose
          /// to sell/transfer the noun to other people. To match nouns.wtf, we list the owner of every 10th noun
          /// as belonging to "nounders.eth" but that may not always be accurate based on any exchanges of ownership
          /// that happened thereafter.
          noun.isNounderOwned = true
          return Auction(id: noun.id, noun: noun, amount: "N/A", startTime: .zero, endTime: .zero, settled: true, bidder: noun.owner)
        }
      }
      
      return try await taskGroup.reduce(into: [Auction](), { $0 += [$1] })
    }
    
    // Add auctions to existing page
    newPage.data.append(contentsOf: auctions)

    return newPage
  }
  
  public func settledAuctionsDidChange() -> AsyncThrowingStream<[Auction], Error> {
    AsyncThrowingStream { continuation in
//      let listener = ShortPolling { () -> [Auction] in
//        // Fetches the most recent settled auction(s) from the network. This will return an array of two
//        // auctions if either of the last two settled Nouns is owned by a Nounder.
//        let auctionPage = try await self.fetchAuctions(settled: true, includeNounderOwned: true, limit: 1, cursor: 0,
//                                                       sortDescending: false)
//
//        guard auctionPage.data.count > 0 else {
//          throw OnChainNounsRequestError.noData
//        }
//
//        return auctionPage.data
//      }
//
//      listener.setEventHandler = { auctions in
//        continuation.yield(auctions)
//      }
//
//      listener.setErrorHandler = { error in
//        continuation.finish(throwing: error)
//      }
//
//      continuation.onTermination = { @Sendable _ in
//        listener.stopPolling()
//      }
//
//      listener.startPolling()
    }
  }
  
  public func liveAuctionStateDidChange() -> AsyncThrowingStream<Auction, Error> {
    AsyncThrowingStream { [weak self] continuation in
//      guard let self = self else { return }
      
//      let listener = ShortPolling {
//        try await self.fetchLiveAuction()
//      }
//
//      listener.setEventHandler = { auction in
//        continuation.yield(auction)
//      }
//
//      listener.setErrorHandler = { error in
//        continuation.finish(throwing: error)
//      }
//
//      continuation.onTermination = { @Sendable _  in
//        listener.stopPolling()
//      }
//
//      listener.startPolling()
    }
  }
  
  /// # A helper for the short-poll mechanism to listen to the live auction changes. #
  ///
  /// **Note:** Should be deleted once the changes are watched using a websocket.
  private func fetchLiveAuction() async throws -> Auction {
      let url = URL(string: "https://mferbuilderdao-api.vercel.app/api/v1/auction")!
      let data = try await URLSession.shared.data(from: url).0
          
      if let jsonString = String(data: data, encoding: .utf8) {
         print(jsonString)
      }
      let decoder = JSONDecoder()
      do {
          let mferAuction = try decoder.decode(MferAuction.self, from: data)
          let mfer = try await fetchMferDetails(for: mferAuction.tokenId)
          let seed = Seed(properties: mfer?.properties ?? [:])
          
          let hexString = mferAuction.highestBid.hex
          let newString = hexString.dropFirst(2)
          let numberAmount = UInt64(newString, radix: 16) ?? 0
          let bid = "\(numberAmount)"
          
          let noun = Noun(id: mferAuction.tokenId, name: mfer?.name ?? "", owner: Account(id: mferAuction.highestBidder), seed: seed, createdAt: Date(timeIntervalSince1970: mferAuction.startTime), updatedAt: Date(timeIntervalSince1970: mferAuction.endTime), nounderOwned: false)
          let auction = Auction(id: mferAuction.tokenId, noun: noun, amount: bid, startTime: mferAuction.startTime, endTime: mferAuction.endTime, settled: mferAuction.settled, bidder: Account(id: mferAuction.highestBidder))
          return auction
      } catch {
          print(error.localizedDescription)
          throw OnChainNounsRequestError.noData
      }
      

//    let query = NounsSubgraph.LiveAuctionSubscription()
//    let page: Page<[Auction]>? = try await graphQLClient.fetch(
//      query,
//      cachePolicy: .returnCacheDataAndFetch
//    )
//
//    guard let auction = page?.data.first else {
//      throw OnChainNounsRequestError.noData
//    }
//
//
//    return auction
  }
    
    public func fetchAuctionHighestBidder() async throws -> String {
//        let urlString =
//        """
//        https://api.zora.co/graphql?query={nouns{nounsMarkets(where:{collectionAddresses:"0x795D300855069F602862c5e23814Bdeeb25DCa6b"}sort:{sortKey:NONE,sortDirection:DESC}){nodes{highestBidder,tokenId}}}}
//        """
        
//        let url = URL(string: "https://mferbuilderdao-api.vercel.app/api/v1/auction")!
        
        let queryString = "{nouns{nounsMarkets(where:{collectionAddresses:\"0x795D300855069F602862c5e23814Bdeeb25DCa6b\"}sort:{sortKey:NONE,sortDirection:DESC}pagination:{limit:1}){nodes{highestBidder,tokenId}}}}"
        let urlString = "https://api.zora.co/graphql?query=\(queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)"
        
        let url = URL(string: urlString)!
        let data = try await URLSession.shared.data(from: url).0
            
        if let jsonString = String(data: data, encoding: .utf8) {
           print(jsonString)
        }
        let decoder = JSONDecoder()
        do {
            let jsonDict = try decoder.decode([String:[String:[String:[String:[[String:String]]]]]].self, from: data)
            if let data = jsonDict["data"],
               let nouns = data["nouns"],
               let markets = nouns["nounsMarkets"],
               let nodes = markets["nodes"],
               let latestAuction = nodes.first,
               let highestBidder = latestAuction["highestBidder"] {
                return highestBidder
            } else {
                return "N/A"
            }
        } catch {
            print(error.localizedDescription)
            return "N/A"
        }
    }
    
    public func fetchMferDetails(for mferId: String) async throws -> Mfer? {
        let url = URL(string: "https://mferbuilderdao-api.vercel.app/api/v1/token/\(mferId)")!
        let data = try await URLSession.shared.data(from: url).0
        
        if let jsonString = String(data: data, encoding: .utf8) {
           print(jsonString)
        }
        let decoder = JSONDecoder()
        do {
            let mfer = try decoder.decode(Mfer.self, from: data)
            return mfer
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
  
  public func fetchActivity(for nounID: String, limit: Int, after cursor: Int) async throws -> Page<[Vote]> {
    let query = NounsSubgraph.ActivitiesQuery(nounID: nounID, limit: limit, skip: cursor)
    let page = try await pageProvider.page(
      Vote.self,
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    return page
  }
  
  public func fetchProposals(limit: Int, after cursor: Int) async throws -> Page<[Proposal]> {
    let query = NounsSubgraph.ProposalsQuery(limit: limit, skip: cursor)
    let page = try await pageProvider.page(
      Proposal.self,
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    return page
  }
  
  public func fetchBids(for nounID: String, limit: Int, after cursor: Int) async throws -> Page<[Bid]> {
    let query = NounsSubgraph.BidsQuery(nounID: nounID, limit: limit, skip: cursor)
    let page = try await pageProvider.page(
      Bid.self,
      query,
      cachePolicy: .returnCacheDataAndFetch
    )
    
    return page
  }
}
