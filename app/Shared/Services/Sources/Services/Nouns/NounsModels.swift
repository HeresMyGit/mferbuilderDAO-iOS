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
    
  public var mferSeed: MferSeed
  
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
    mferSeed: MferSeed? = nil,
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
      self.mferSeed = mferSeed ?? MferSeed(background: seed.background, headphones: seed.headphones, head: seed.head, smoke: seed.smoke, beard: 0, chain: 0, eyes: 0, hatOverHeadphones: 0, hatUnderHeadphones: 0, longHair: 0, mouth: 0, shirt: 0, shortHair: 0, watch: 0)
  }
}

/// The seed used to determine the Noun's traits.
public struct Seed: Equatable, Hashable {
  
  /// The background trait.
  public var background: Int
  
  /// The headphones trait.
  public var headphones: Int
  
  /// The head trait.
  public var head: Int
  
  /// The smoke trait.
  public var smoke: Int
  
  public init(background: Int, headphones: Int, head: Int, smoke: Int) {
    self.background = background
    self.headphones = headphones
    self.head = head
    self.smoke = smoke
  }
  
    public init?(background: String, headphones: String, head: String, smoke: String) {
    guard let backgroundInt = Int(background),
          let headphonesInt = Int(headphones),
          let headInt = Int(head),
          let smokeInt = Int(smoke) else {
            return nil
          }
    
    self.background = backgroundInt
    self.headphones = headphonesInt
    self.head = headInt
    self.smoke = smokeInt
  }
}

public extension Seed {
    static func toMferSeed(_ seed: Seed) -> MferSeed {
        MferSeed(background: seed.background,
                 headphones: seed.headphones,
                 head: seed.head,
                 smoke: seed.smoke,
                 beard: 0,
                 chain: 0,
                 eyes: 0,
                 hatOverHeadphones: 0,
                 hatUnderHeadphones: 0,
                 longHair: 0,
                 mouth: 0,
                 shirt: 0,
                 shortHair: 0,
                 watch: 0)
    }
    
    static func fromMferSeed(_ mferSeed: MferSeed) -> Seed {
        Seed(background: mferSeed.background, headphones: mferSeed.headphones, head: mferSeed.head, smoke: mferSeed.smoke)
    }
}

public extension Seed {
  static let `default` = Seed(background: 0, headphones: 0, head: 0, smoke: 0)
  static let pizza = Seed(background: 0, headphones: 1, head: 1, smoke: 1)
  static let shark = Seed(background: 1, headphones: 2, head: 2, smoke: 2)
}

/// The seed used to determine the mfer's traits.
public struct MferSeed: Equatable, Hashable {
    
    /// The background trait.
    public var background: Int
    
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
                headphones: Int,
                head: Int,
                smoke: Int,
                beard: Int,
                chain: Int,
                eyes: Int,
                hatOverHeadphones: Int,
                hatUnderHeadphones: Int,
                longHair: Int,
                mouth: Int,
                shirt: Int,
                shortHair: Int,
                watch: Int) {
        self.background = background
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
                 headphones: String,
                 head: String,
                 smoke: String,
                 beard: String,
                 chain: String,
                 eyes: String,
                 hatOverHeadphones: String,
                 hatUnderHeadphones: String,
                 longHair: String,
                 mouth: String,
                 shirt: String,
                 shortHair: String,
                 watch: String) {
        guard let backgroundInt = Int(background),
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
}

public extension MferSeed {
  static let `default` = MferSeed(background: 0, headphones: 0, head: 0, smoke: 0, beard: 0, chain: 0, eyes: 0, hatOverHeadphones: 0, hatUnderHeadphones: 0, longHair: 0, mouth: 0, shirt: 0, shortHair: 0, watch: 0)
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
