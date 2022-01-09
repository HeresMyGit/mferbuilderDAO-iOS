//
//  Auction+Decodable.swift
//  
//
//  Created by Ziad Tamim on 05.01.22.
//

import Foundation

extension Auction {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    id = try container.decode(String.self, forKey: AnyCodingKey("id"))
    noun = try container.decode(Noun.self, forKey: AnyCodingKey("noun"))
    amount = try container.decode(String.self, forKey: AnyCodingKey("amount"))
    bidder = try container.decode(Account.self, forKey: AnyCodingKey("bidder"))
    settled = try container.decode(Bool.self, forKey: AnyCodingKey("settled"))
    
    let startTimeAsString = try container.decode(String.self, forKey: AnyCodingKey("startTime"))
    let endTimeAsString = try container.decode(String.self, forKey: AnyCodingKey("endTime"))
    
    startTime = try Self.timeInterval(startTimeAsString, decoder)
    endTime = try Self.timeInterval(endTimeAsString, decoder)
  }
  
  private static func timeInterval(
    _ timeIntervalAsString: String,
    _ decoder: Decoder
  ) throws -> TimeInterval {
    
    guard let timeInterval = TimeInterval(timeIntervalAsString) else {
      let context = DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Encoded payload not convertible to an TimeInterval")
      
      throw DecodingError.dataCorrupted(context)
    }
    
    return timeInterval
  }
}
