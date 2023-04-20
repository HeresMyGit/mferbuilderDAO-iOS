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
import SwiftUI

/// Pagination.
public struct Page<T> where T: Decodable {
  
  /// Data retrived from the response.
  public var data: T
  
  /// The cursor of the current page
  public var cursor: Int = 0
  
  /// Whether there is more data to fetch
  public var hasNext: Bool = true
}

/// The Noun
public struct Noun: Equatable, Identifiable, Hashable {
  
  /// The Noun's ERC721 token id
  public let id: String
  
  /// The given Noun's name.
  public var name: String
  
  ///  The owner of the Noun.
  public let owner: Account
  
  /// The seed used to determine the Noun's traits.
  public var seed: Seed
      
  /// The date when the noun was created.
  public let createdAt: Date
  
  /// The date when the noun was updated.
  public var updatedAt: Date
  
  public var isNounderOwned: Bool
  
  public init(
    id: String = UUID().uuidString,
    name: String,
    owner: Account,
    seed: Seed,
    createdAt: Date = .now,
    updatedAt: Date = .now,
    nounderOwned: Bool = false
  ) {
    self.id = id
    self.name = name
    self.owner = owner
    self.seed = seed
    self.createdAt = createdAt
    self.updatedAt = updatedAt
    self.isNounderOwned = nounderOwned
  }
}

public struct Mfer: Decodable {
    // name
    public var name: String
    
    public var description: String
    
    public var image: String
    
    public var properties: [String:String]
    
}

/// The seed used to determine the Noun's traits.
public struct Seed: Equatable, Hashable {
    /// The background trait.
    public var background: Int
    
    /// The body trait.
    public var body: Int
    
    /// The headphones trait.
    public var headphones: Int
    
    /// The head trait.
    public var head: Int
    
    /// The smoke trait.
    public var smoke: Int
    
    /// The beard trait.
    public var beard: Int
    
    /// The chain trait.
    public var chain: Int
    
    /// The eyes trait.
    public var eyes: Int
    
    /// The hatOverHeadphones trait.
    public var hatOverHeadphones: Int
    
    /// The hatUnderHeadphones trait.
    public var hatUnderHeadphones: Int
    
    /// The smlongHairoke trait.
    public var longHair: Int
    
    /// The mouth trait.
    public var mouth: Int
    
    /// The shirt trait.
    public var shirt: Int
    
    /// The shortHair trait.
    public var shortHair: Int
    
    /// The watch trait.
    public var watch: Int
    
    public init(background: Int,
                body: Int = 0,
                headphones: Int,
                head: Int,
                smoke: Int,
                beard: Int = 0,
                chain: Int = 0,
                eyes: Int = 0,
                hatOverHeadphones: Int = 0,
                hatUnderHeadphones: Int = 0,
                longHair: Int = 0,
                mouth: Int = 0,
                shirt: Int = 0,
                shortHair: Int = 0,
                watch: Int = 0) {
        self.background = background
        self.body = body
        self.headphones = headphones
        self.head = head
        self.smoke = smoke
        self.beard = beard
        self.chain = chain
        self.eyes = eyes
        self.hatOverHeadphones = hatOverHeadphones
        self.hatUnderHeadphones = hatUnderHeadphones
        self.longHair = longHair
        self.mouth = mouth
        self.shirt = shirt
        self.shortHair = shortHair
        self.watch = watch
    }
    
    public init?(background: String,
                 body: String = "0",
                 headphones: String,
                 head: String,
                 smoke: String,
                 beard: String = "0",
                 chain: String = "0",
                 eyes: String = "0",
                 hatOverHeadphones: String = "0",
                 hatUnderHeadphones: String = "0",
                 longHair: String = "0",
                 mouth: String = "0",
                 shirt: String = "0",
                 shortHair: String = "0",
                 watch: String = "0") {
        guard let backgroundInt = Int(background),
              let bodyInt = Int(body),
              let headphonesInt = Int(headphones),
              let headInt = Int(head),
              let smokeInt = Int(smoke),
              let beardInt = Int(beard),
              let chainInt = Int(chain),
              let eyesInt = Int(eyes),
              let hatOverHeadphonesInt = Int(hatOverHeadphones),
              let hatUnderHeadphonesInt = Int(hatUnderHeadphones),
              let longHairInt = Int(longHair),
              let mouthInt = Int(mouth),
              let shirtInt = Int(shirt),
              let shortHairInt = Int(shortHair),
              let watchInt = Int(watch) else {
            return nil
        }
        
        self.background = backgroundInt
        self.body = bodyInt
        self.headphones = headphonesInt
        self.head = headInt
        self.smoke = smokeInt
        self.beard = beardInt
        self.chain = chainInt
        self.eyes = eyesInt
        self.hatOverHeadphones = hatOverHeadphonesInt
        self.hatUnderHeadphones = hatUnderHeadphonesInt
        self.longHair = longHairInt
        self.mouth = mouthInt
        self.shirt = shirtInt
        self.shortHair = shortHairInt
        self.watch = watchInt
    }
    
    public init(properties: [String:String]) {
        self.background = 0
        
        let bgName = properties["bg"] ?? ""
        if bgName == "bg-orange" {
            self.background = 0
        } else if bgName == "bg-red" {
            self.background = 1
        } else if bgName == "bg-blue" {
            self.background = 2
        } else if bgName == "bg-green" {
            self.background = 3
        } else if bgName == "bg-yellow" {
            self.background = 4
        } else {
            self.background = 0
        }
        
        self.body = OfflineNounComposer.default().bodies.firstIndex(where: ({ $0.assetImage == properties["body"] })) ?? 0
        self.headphones = OfflineNounComposer.default().headphones.firstIndex(where: ({ $0.assetImage == properties["headphones"] })) ?? 0
        self.head = OfflineNounComposer.default().heads.firstIndex(where: ({ $0.assetImage == properties["head"] })) ?? 0
        self.smoke = OfflineNounComposer.default().smokes.firstIndex(where: ({ $0.assetImage == properties["smoke"] })) ?? 0
        self.beard = OfflineNounComposer.default().beards.firstIndex(where: ({ $0.assetImage == properties["beard"] })) ?? 0
        self.chain = OfflineNounComposer.default().chains.firstIndex(where: ({ $0.assetImage == properties["chain"] })) ?? 0
        self.eyes = OfflineNounComposer.default().eyes.firstIndex(where: ({ $0.assetImage == properties["eyes"] })) ?? 0
        self.hatOverHeadphones = OfflineNounComposer.default().hatOverHeadphones.firstIndex(where: ({ $0.assetImage == properties["hatOverHeadphones"] })) ?? 0
        self.hatUnderHeadphones = OfflineNounComposer.default().hatUnderHeadphones.firstIndex(where: ({ $0.assetImage == properties["hatUnderHeadphones"] })) ?? 0
        self.longHair = OfflineNounComposer.default().longHairs.firstIndex(where: ({ $0.assetImage == properties["longHair"] })) ?? 0
        self.mouth = OfflineNounComposer.default().mouths.firstIndex(where: ({ $0.assetImage == properties["mouth"] })) ?? 0
        self.shirt = OfflineNounComposer.default().shirts.firstIndex(where: ({ $0.assetImage == properties["shirt"] })) ?? 0
        self.shortHair = OfflineNounComposer.default().shortHairs.firstIndex(where: ({ $0.assetImage == properties["shortHair"] })) ?? 0
        self.watch = OfflineNounComposer.default().watches.firstIndex(where: ({ $0.assetImage == properties["watch"] })) ?? 0

    }
    
    public init(mferAttributes: [String:String]) {
        self.background = 0
        
        let bgName = mferAttributes["background"] ?? ""
        if bgName == "orange" {
            self.background = 0
        } else if bgName == "red" {
            self.background = 1
        } else if bgName == "blue" {
            self.background = 2
        } else if bgName == "green" {
            self.background = 3
        } else if bgName == "yellow" {
            self.background = 4
        } else if bgName == "graveyard" {
            self.background = 5
        } else if bgName == "space" {
            self.background = 6
        } else if bgName == "tree" {
            self.background = 7
        } else {
            self.background = 0
        }
        
        self.body = 2
        
        var headName = mferAttributes["type"] ?? ""
        headName = "head-" + (headName.components(separatedBy: " ").first ?? "")
        self.head = OfflineNounComposer.default().heads.firstIndex(where: ({ $0.assetImage == headName })) ?? 0
        
        var headphonesName = mferAttributes["headphones"] ?? ""
        headphonesName = headphonesName.components(separatedBy: " ").reversed().joined(separator: "-")
        self.headphones = OfflineNounComposer.default().headphones.firstIndex(where: ({ $0.assetImage == headphonesName })) ?? 0
        
        var smokeName = mferAttributes["smoke"] ?? ""
        if smokeName == "pipe" {
            smokeName = "smoke-pipe"
        } else {
            smokeName = smokeName.replacingOccurrences(of: "cig ", with: "smoke-")
        }
        self.smoke = OfflineNounComposer.default().smokes.firstIndex(where: ({ $0.assetImage == smokeName })) ?? 0
        
        var beardName = mferAttributes["beard"] ?? ""
        beardName = beardName.replacingOccurrences(of: " ", with: "")
        self.beard = OfflineNounComposer.default().beards.firstIndex(where: ({ $0.assetImage == beardName })) ?? 0
        
        var chainName = mferAttributes["chain"] ?? ""
        chainName = chainName.replacingOccurrences(of: " ", with: "")
        self.chain = OfflineNounComposer.default().chains.firstIndex(where: ({ $0.assetImage == chainName })) ?? 0
        
        var eyesName = mferAttributes["eyes"] ?? ""
        eyesName = eyesName.replacingOccurrences(of: " ", with: "")
        self.eyes = OfflineNounComposer.default().eyes.firstIndex(where: ({ $0.assetImage == eyesName })) ?? 0
        
        var hohName = mferAttributes["hat over headphones"] ?? ""
        hohName = hohName.replacingOccurrences(of: " ", with: "")
        self.hatOverHeadphones = OfflineNounComposer.default().hatOverHeadphones.firstIndex(where: ({ $0.assetImage == hohName })) ?? 0
        
        var huhName = mferAttributes["hat under headphones"] ?? ""
        print("huh: \(huhName)")
        huhName = huhName.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "/", with: "_")
        print("huh: \(huhName)")
        self.hatUnderHeadphones = OfflineNounComposer.default().hatUnderHeadphones.firstIndex(where: ({ $0.assetImage == huhName })) ?? 0
        
        var longHairName = mferAttributes["long hair"] ?? ""
        longHairName = longHairName.replacingOccurrences(of: " ", with: "")
        self.longHair = OfflineNounComposer.default().longHairs.firstIndex(where: ({ $0.assetImage == longHairName })) ?? 0
        
        self.mouth = OfflineNounComposer.default().mouths.firstIndex(where: ({ $0.assetImage == mferAttributes["mouth"] })) ?? 0
        
        var shirtName = mferAttributes["shirt"] ?? ""
        shirtName = shirtName.replacingOccurrences(of: " ", with: "")
        self.shirt = OfflineNounComposer.default().shirts.firstIndex(where: ({ $0.assetImage == shirtName })) ?? 0
        
        var shortHairName = mferAttributes["short hair"] ?? ""
        shortHairName = shortHairName.replacingOccurrences(of: " ", with: "")
        self.shortHair = OfflineNounComposer.default().shortHairs.firstIndex(where: ({ $0.assetImage == shortHairName })) ?? 0

        var watchName = mferAttributes["4:20 watch"] ?? ""
        watchName = watchName.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "/", with: "")
        self.watch = OfflineNounComposer.default().watches.firstIndex(where: ({ $0.assetImage == watchName })) ?? 0

    }
}

public extension Seed {
  static let `default` = Seed(background: 0, headphones: 0, head: 0, smoke: 0)
  static let pizza = Seed(background: 0, headphones: 1, head: 1, smoke: 1)
  static let shark = Seed(background: 1, headphones: 2, head: 2, smoke: 2)
}

/// The owner of the Noun
public struct Account: Equatable, Decodable, Hashable {
  
  /// An Account is any address that holds any
  /// amount of Nouns, the id used is the blockchain address.
  public let id: String
  
  public init(id: String = UUID().uuidString) {
    self.id = id
  }
}

/// Historical votes for the Noun.
public struct Vote: Equatable, Decodable, Identifiable {
  
  /// Delegate ID + Proposal ID
  public let id: String
  
  /// The support value: against, for, or abstain.
  public let supportDetailed: VoteSupportDetailed
  
  /// Proposal that is being voted on.
  public let proposal: Proposal
}

/// Vote support value.
public enum VoteSupportDetailed: Int, Decodable {
  case against
  case `for`
  case abstain
}

/// Status of the proposal
public enum ProposalStatus: String, Decodable {
  case pending = "PENDING"
  case active = "ACTIVE"
  case cancelled = "CANCELLED"
  case vetoed = "VETOED"
  case queued = "QUEUED"
  case executed = "EXECUTED"
}

/// A proposal status that provides more details and logic to match the website's display status
public enum ProposalDetailedStatus: String {
  case pending
  case cancelled
  case vetoed
  case queued
  case executed
  
  case expired
  
  case active
  case defeated
  case succeeded
  
  static func status(from proposal: Proposal) -> ProposalDetailedStatus {
    switch proposal.status {
    case .pending:
      return .pending
    case .active:
      // From https://nouns.wtf/create-proposal, "The voting period will begin after 2 1/3 days and last for 3 days."
      if let createdTimestamp = proposal.createdTimestamp {
        let createdDate = Date(timeIntervalSince1970: createdTimestamp)
        // When voting has ended (approx 2 weeks after the executionETA), active proposals
        // are either classified as succeeding or defeated
        if let votingEndDate = createdDate.dateAfter(hours: 8, days: 5), Date() > votingEndDate {
          return proposal.isDefeated ? .defeated : .succeeded
        }
      }
      
      // If voting is still open, the proposal is simply `active`
      return .active
    case .cancelled:
      return .cancelled
    case .vetoed:
      return .vetoed
    case .queued:
      // Proposals that are queued are considered expired if two weeks after the executionETA has passed
      if let executionETA = proposal.executionETA {
        let executionDate = Date(timeIntervalSince1970: executionETA)
        
        if let expiryDate = executionDate.dateAfter(weeks: 2), Date() > expiryDate {
          return .expired
        }
      }
      return .queued
    case .executed:
      return .executed
    }
  }
}

/// The Proposal.
public struct Proposal: Equatable, Identifiable {
  
  /// Internal proposal ID
  public let id: String
  
  /// Title of the change
  public let title: String?
  
  /// Description of the change.
  public let description: String
  
  /// Status of the proposal.
  public let status: ProposalStatus
  
  /// Votes associated with this proposal
  public let votes: [ProposalVote]
  
  /// The required number of votes for quorum at the time of proposal creation
  public let quorumVotes: Int
  
  /// Once the proposal is queued for execution it will have an ETA of the execution
  public let executionETA: TimeInterval?
  
  /// A timestamp for when the proposal was created
  public let createdTimestamp: TimeInterval?

  /// The amount of votes in favour of this proposal
  public var forVotes: Int {
    votes.filter { $0.support == true }.map { $0.votes }.reduce(0, +)
  }

  /// The amount of votes against this proposal
  public var againstVotes: Int {
    votes.filter { $0.support == false }.map { $0.votes }.reduce(0, +)
  }
  
  /// A boolean value to determine if this proposal is defeated
  public var isDefeated: Bool {
    quorumVotes > forVotes || againstVotes >= forVotes
  }
  
  /// A more accurate user-facing proposal status, in line with how the Nouns website displays proposal status
  /// The `active` status is replaced in favour of a specific succeeded or defeated status
  public var detailedStatus: ProposalDetailedStatus {
    ProposalDetailedStatus.status(from: self)
  }
}

public struct ProposalVote: Equatable, Identifiable {
  
  /// Delegate ID + Proposal ID
  public let id: String
  
  /// Whether the vote is in favour of the proposal
  public let support: Bool
  
  /// Amount of votes in favour or against expressed as a BigInt normalized value for the Nouns ERC721 Token
  public let votes: Int
}

/// The Auction
public struct Auction: Equatable, Decodable, Identifiable {
  
  /// The Noun's ERC721 token id
  public let id: String
  
  /// The Noun
  public let noun: Noun
  
  /// The current highest bid amount
  public let amount: String
  
  /// The time that the auction started
  public let startTime: TimeInterval
  
  /// The time that the auction is scheduled to end
  public let endTime: TimeInterval
  
  /// Whether or not the auction has been settled
  public let settled: Bool
  
  /// The auctions current highest bid
  public let bidder: Account?
      
  /// Whether the auction is over and bidding is stopped.
  public var hasEnded: Bool {
    Date().timeIntervalSince1970 > endTime
  }
    
    public init(id: String, noun: Noun, amount: String, startTime: TimeInterval, endTime: TimeInterval, settled: Bool, bidder: Account?) {
        self.id = id
        self.noun = noun
        self.amount = amount
        self.startTime = startTime
        self.endTime = endTime
        self.settled = settled
        self.bidder = bidder
    }
}

public struct MferAuction: Decodable {
    // id
    public let tokenId: String
    
    // amount
    public let highestBid: MferAuction.Bid
    
    // bidder
    public let highestBidder: String
    
    // startTime
    public let startTime: TimeInterval
    
    // endTime
    public let endTime: TimeInterval
    
    // settled
    public let settled: Bool
    
    
    public struct Bid: Decodable {
        public let type: String
        
        public let hex: String
    }
}

/// The auction's Bid
public struct Bid: Equatable, Decodable, Identifiable {
  
  /// Bid transaction hash
  public let id: String
  
  /// Bid amount
  public let amount: String
  
  /// Timestamp of the bid
  public let blockTimestamp: String
  
  /// The account the bid was made by
  public let bidder: Account
}
