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

extension Noun: Decodable {

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: AnyCodingKey.self)
    id = try container.decode(String.self, forKey: AnyCodingKey("id"))
    owner = try container.decode(Account.self, forKey: AnyCodingKey("owner"))
    seed = try container.decode(Seed.self, forKey: AnyCodingKey("seed"))
    name = try container.decodeIfPresent(
      String.self,
      forKey: AnyCodingKey("name")
    ) ?? "Untitled"
    createdAt = Date()
    updatedAt = Date()
    isNounderOwned = false
  }
}
