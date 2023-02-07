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

/// The Noun's trait.
public struct Trait: Equatable, Hashable {
  
  /// `RLE` data compression of the Noun's trait.
  public let rleData: String
  
  /// Asset image of the Noun's trait stored locally.
  public let assetImage: String
  
  /// Textures to animate different parts of the traits.
  public let textures: [String: [String]]
}

/// This provider class allows interacting with local Nouns' placed in disk.
public protocol NounComposer {
  
  /// The color palette used to draw Noun's background.
  var backgroundColors: [String] { get }
  
  /// The color palette used to draw Noun's parts.
  var palette: [String] { get }
  
  /// Array containing all the accessories mapped from the RLE data.
  /// to the shapes to draw Noun's parts.
  var smokes: [Trait] { get }
  
  /// Array containing all the heads mapped from the RLE data
  /// to the shapes to draw Noun's parts.
  var heads: [Trait] { get }
  
  /// Array containing all the glasses mapped from the RLE data
  /// to the shapes to draw Noun's parts.
  var headphones: [Trait] { get }
    
  var beards: [Trait] { get }
  var chains: [Trait] { get }
  var eyes: [Trait] { get }
  var hatOverHeadphones: [Trait] { get }
  var hatUnderHeadphones: [Trait] { get }
  var longHairs: [Trait] { get }
  var mouths: [Trait] { get }
  var shirts: [Trait] { get }
  var shortHairs: [Trait] { get }
  var watches: [Trait] { get }
    
    
    
    
  
  /// Generates a random seed, given the number of each trait type
  func randomSeed() -> Seed
    
    /// Generates a random seed, given the number of each trait type
    func randomMferSeed() -> MferSeed

  /// Generates a new random seed, with no trait values in common with the `previous` seed
  func newRandomSeed(previous seed: Seed) -> Seed
    
    /// Generates a new random mferseed, with no trait values in common with the `previous` mferseed
    func newRandomMferSeed(previous seed: MferSeed) -> MferSeed
  
}

/// A Flavour of the NounComposer to load local Nouns' trait.
public class OfflineNounComposer: NounComposer {
  
  /// The background list of colors.
  public lazy var backgroundColors = layer.bgcolors
  
  /// The color palette used to draw `Nouns` with `RLE` data.
  public lazy var palette = layer.palette
  
  /// The smoke list of traits.
  public lazy var smokes = layer.images["smoke"] ?? []
  
  /// The head list of traits.
  public lazy var heads = layer.images["heads"] ?? []
  
  /// The headphones list of traits.
  public lazy var headphones = layer.images["headphones"] ?? []
    
  public lazy var beards = layer.images["beard"] ?? []
  public lazy var chains = layer.images["chain"] ?? []
  public lazy var eyes = layer.images["eyes"] ?? []
  public lazy var hatOverHeadphones = layer.images["hatOverHeadphones"] ?? []
  public lazy var hatUnderHeadphones = layer.images["hatUnderHeadphones"] ?? []
  public lazy var longHairs = layer.images["longHair"] ?? []
  public lazy var mouths = layer.images["mouth"] ?? []
  public lazy var shirts = layer.images["shirt"] ?? []
  public lazy var shortHairs = layer.images["shortHair"] ?? []
  public lazy var watches = layer.images["watch"] ?? []
    
  /// Decodes offline Noun's traits.
  private struct Layer: Decodable {
    let palette: [String]
    let bgcolors: [String]
    let images: [String: [Trait]]
  }
  
  private let layer: Layer
  
  init(encodedLayersURL: URL) throws {
    let data = try Data(contentsOf: encodedLayersURL)
    layer = try JSONDecoder().decode(Layer.self, from: data)
  }
  
  /// Creates and returns an `NounComposer` object from an existing set of Nouns' traits.
  /// - Returns: A new NounComposer object.
  public static func `default`() -> NounComposer {
    do {
      guard let url = Bundle.module.url(
        forResource: "mfbldr-traits-layers_v1",
        withExtension: "json"
      ) else {
        throw URLError(.badURL)
      }
      
      return try OfflineNounComposer(encodedLayersURL: url)
      
    } catch {
      fatalError("💥 Failed to create the offline nouns composer \(error)")
    }
  }
    
    /// Creates and returns an `NounComposer` object from an existing set of mfers' traits.
    /// - Returns: A new NounComposer object.
    public static func `mferComposer`() -> NounComposer {
      do {
        guard let url = Bundle.module.url(
          forResource: "mfer-traits-layers_v1",
          withExtension: "json"
        ) else {
          throw URLError(.badURL)
        }
        
        return try OfflineNounComposer(encodedLayersURL: url)
        
      } catch {
        fatalError("💥 Failed to create the offline nouns composer \(error)")
      }
    }
  
  /// Generates a random seed, given the number of each trait type
  public func randomSeed() -> Seed {
    guard let background = backgroundColors.randomIndex(),
          let smoke = smokes.randomIndex(),
          let head = heads.randomIndex(),
          let headphones = headphones.randomIndex() else {
            return Seed(background: 0, headphones: 0, head: 0, smoke: 0)
          }
    
    return Seed(background: background, headphones: headphones, head: head, smoke: smoke)
  }
    
    /// Generates a random mfer seed, given the number of each trait type
    public func randomMferSeed() -> MferSeed {
      guard let background = backgroundColors.randomIndex(),
            let smoke = smokes.randomIndex(),
            let head = heads.randomIndex(),
            let headphones = headphones.randomIndex(),
            let beard = beards.randomIndex(),
            let chain = chains.randomIndex(),
            let eyes = eyes.randomIndex(),
            let hatOverHeadphones = hatOverHeadphones.randomIndex(),
            let hatUnderHeadphones = hatUnderHeadphones.randomIndex(),
            let longHair = longHairs.randomIndex(),
            let mouth = mouths.randomIndex(),
            let shirt = shirts.randomIndex(),
            let shortHair = shortHairs.randomIndex(),
            let watch = watches.randomIndex() else {
              return MferSeed(background: 0, headphones: 0, head: 0, smoke: 0, beard: 0, chain: 0, eyes: 0, hatOverHeadphones: 0, hatUnderHeadphones: 0, longHair: 0, mouth: 0, shirt: 0, shortHair: 0, watch: 0)
            }
      
      return MferSeed(background: background, headphones: headphones, head: head, smoke: smoke, beard: beard, chain: chain, eyes: eyes, hatOverHeadphones: hatOverHeadphones, hatUnderHeadphones: hatUnderHeadphones, longHair: longHair, mouth: mouth, shirt: shirt, shortHair: shortHair, watch: watch)
    }

  public func newRandomSeed(previous seed: Seed) -> Seed {
    var result: Seed
    repeat {
      result = randomSeed()
    } while result.background == seed.background
    || result.smoke == seed.smoke
    || result.head == seed.head
    || result.headphones == seed.headphones

    return result
  }
    
    public func newRandomMferSeed(previous seed: MferSeed) -> MferSeed {
      var result: MferSeed
      repeat {
        result = randomMferSeed()
      } while result.background == seed.background
      || result.smoke == seed.smoke
      || result.head == seed.head
      || result.headphones == seed.headphones
      || result.beard == seed.beard
      || result.chain == seed.chain
      || result.eyes == seed.eyes
      || result.hatOverHeadphones == seed.hatOverHeadphones
      || result.hatUnderHeadphones == seed.hatUnderHeadphones
      || result.longHair == seed.longHair
      || result.mouth == seed.mouth
      || result.shirt == seed.shirt
      || result.shortHair == seed.shortHair
      || result.watch == seed.watch

      return result
    }
}

extension Trait: Decodable {
  
  private enum CodingKeys: String, CodingKey {
    case assetImage = "filename"
    case rleData = "data"
    case textures
  }
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    rleData = try container.decode(String.self, forKey: .rleData)
    assetImage = try container.decode(String.self, forKey: .assetImage)
    textures = try container.decode([String: [String]].self, forKey: .textures)
  }
}

fileprivate extension Array {
  
  func randomIndex() -> Int? {
    guard self.count > 0 else { return nil }
    
    let minIndex = 0
    let maxIndex = self.count - 1
    
    return Int.random(in: minIndex...maxIndex)
  }
}
