// Copyright (C) 2022 Nouns Collective
//
// Originally authored by  Ziad Tamim
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

extension Seed: Decodable {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    guard let backgroundInt = Int(try container.decode(String.self, forKey: AnyCodingKey("background"))),
          let bodyInt = Int(try container.decode(String.self, forKey: AnyCodingKey("body"))),
          let headphonesInt = Int(try container.decode(String.self, forKey: AnyCodingKey("headphones"))),
          let headInt = Int(try container.decode(String.self, forKey: AnyCodingKey("head"))),
          let smokeInt = Int(try container.decode(String.self, forKey: AnyCodingKey("smoke"))),
          let beardInt = Int(try container.decode(String.self, forKey: AnyCodingKey("beard"))),
          let chainInt = Int(try container.decode(String.self, forKey: AnyCodingKey("chain"))),
          let eyesInt = Int(try container.decode(String.self, forKey: AnyCodingKey("eyes"))),
          let hatOverHeadphonesInt = Int(try container.decode(String.self, forKey: AnyCodingKey("hatOverHeadphones"))),
          let hatUnderHeadphonesInt = Int(try container.decode(String.self, forKey: AnyCodingKey("hatUnderHeadphones"))),
          let longHairInt = Int(try container.decode(String.self, forKey: AnyCodingKey("longHair"))),
          let mouthInt = Int(try container.decode(String.self, forKey: AnyCodingKey("mouth"))),
          let shirtInt = Int(try container.decode(String.self, forKey: AnyCodingKey("shirt"))),
          let shortHairInt = Int(try container.decode(String.self, forKey: AnyCodingKey("shortHair"))),
          let watchInt = Int(try container.decode(String.self, forKey: AnyCodingKey("watch")))
    else {
      let context = DecodingError.Context(
        codingPath: decoder.codingPath,
        debugDescription: "Encoded payload not convertible to an Integer")
      
      throw DecodingError.dataCorrupted(context)
    }
    
    background = backgroundInt
    body = bodyInt
    headphones = headphonesInt
    head = headInt
    smoke = smokeInt
    beard = beardInt
    chain = chainInt
    eyes = eyesInt
    hatOverHeadphones = hatOverHeadphonesInt
    hatUnderHeadphones = hatUnderHeadphonesInt
    longHair = longHairInt
    mouth = mouthInt
    shirt = shirtInt
    shortHair = shortHairInt
    watch = watchInt
      
  }
}
