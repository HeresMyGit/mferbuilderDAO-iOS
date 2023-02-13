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
import CoreData

/// `Seed Core Data` model object.
@objc(SeedManagedObject)
final class SeedManagedObject: NSManagedObject {
    @NSManaged public var background: Int32
    @NSManaged public var body: Int32
    @NSManaged public var head: Int32
    @NSManaged public var headphones: Int32
    @NSManaged public var smoke: Int32
    @NSManaged public var beard: Int32
    @NSManaged public var chain: Int32
    @NSManaged public var eyes: Int32
    @NSManaged public var hatOverHeadphones: Int32
    @NSManaged public var hatUnderHeadphones: Int32
    @NSManaged public var longHair: Int32
    @NSManaged public var mouth: Int32
    @NSManaged public var shirt: Int32
    @NSManaged public var shortHair: Int32
    @NSManaged public var watch: Int32
    @NSManaged public var noun: NounManagedObject?
}

extension SeedManagedObject: StoredEntity {
  
  static var entityName: String? {
    return "Seed"
  }
  
  static func insert(
    into context: NSManagedObjectContext,
    seed: Seed
  ) throws -> Self {
    let managedObject: Self = try context.insertObject()
    managedObject.background = Int32(seed.background)
    managedObject.body = Int32(seed.body)
    managedObject.head = Int32(seed.head)
    managedObject.headphones = Int32(seed.headphones)
    managedObject.smoke = Int32(seed.smoke)
    managedObject.beard = Int32(seed.beard)
    managedObject.chain = Int32(seed.chain)
    managedObject.eyes = Int32(seed.eyes)
    managedObject.hatOverHeadphones = Int32(seed.hatOverHeadphones)
    managedObject.hatUnderHeadphones = Int32(seed.hatUnderHeadphones)
    managedObject.longHair = Int32(seed.longHair)
    managedObject.mouth = Int32(seed.mouth)
    managedObject.shirt = Int32(seed.shirt)
    managedObject.shortHair = Int32(seed.shortHair)
    managedObject.watch = Int32(seed.watch)
    return managedObject
  }
}

extension SeedManagedObject: CustomModelConvertible {

  var model: Seed {
    Seed(
      background: Int(background),
      body: Int(body),
      headphones: Int(headphones),
      head: Int(head),
      smoke: Int(smoke),
      beard: Int(beard),
      chain: Int(chain),
      eyes: Int(eyes),
      hatOverHeadphones: Int(hatOverHeadphones),
      hatUnderHeadphones: Int(hatUnderHeadphones),
      longHair: Int(longHair),
      mouth: Int(mouth),
      shirt: Int(shirt),
      shortHair: Int(shortHair),
      watch: Int(watch)
    )
  }
}
