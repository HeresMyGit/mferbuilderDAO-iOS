// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Mohammed Ibrahim
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
import SpriteKit
import Services

extension OnboardingView {
  
  final class IntroScene: SKScene, ObservableObject {
    
    /// Indicates the size of the traits building the noun.
    private var traitSize: CGSize { CGSize(width: size.width, height: size.width) }
    
    /// Shark noun
    private let seed: Seed = .shark
    
    private var nounComposer: NounComposer {
      AppCore.shared.nounComposer
    }
    
    private lazy var head: TalkingNoun.Trait? = {
      let headAsset = nounComposer.heads[seed.head].assetImage
      let head = TalkingNoun.Trait(nounTraitName: headAsset)
      return head
    }()
    
    private lazy var accessory: TalkingNoun.Trait? = {
      let accessoryAsset = nounComposer.smokes[seed.smoke].assetImage
      let accessory = TalkingNoun.Trait(nounTraitName: accessoryAsset)
      return accessory
    }()
    
//    private lazy var eyes = TalkingNoun.Eyes(seed: seed, frameSize: traitSize, blinkOnly: false)
    
    private lazy var traitGroupNode: SKSpriteNode = {
      let group = SKSpriteNode()
      group.size = traitSize
      group.position = CGPoint(x: frame.midX, y: traitSize.height / 2)
      
      [accessory, head/*, eyes*/].compactMap { trait in
        trait?.size = traitSize
        return trait
      }
      .forEach(group.addChild)
      
      return group
    }()
    
    override init(size: CGSize) {
      super.init(size: size)
      scaleMode = .fill
      view?.showsFPS = false
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
      setUpInitialState()
    }
    
    private func setUpInitialState() {
      backgroundColor = .clear
      view?.allowsTransparency = true
      view?.backgroundColor = .clear
      
      buildScene()
      
      addChild(traitGroupNode)
    }
    
    private func buildScene() {
      /// Adds a light, smaller secondary marquee in the background to create a "parallax" effect with the main larger foreground marquee text
      for i in 0...1 {
        let background = SKSpriteNode(imageNamed: "nouns-ios-01-marquee")
        background.anchorPoint = .zero
        background.position = CGPoint(x: (size.width * CGFloat(i)) - CGFloat(1 * i), y: 0)
        background.size = size
        addChild(background)
        
        let moveLeft = SKAction.moveBy(x: -size.width, y: 0, duration: 20)
        let moveReset = SKAction.moveBy(x: size.width, y: 0, duration: 0)
        let moveLoop = SKAction.sequence([moveLeft, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)
        
        background.run(moveForever)
      }
    }
  }
}

extension SKSpriteNode {
  
  func aspectFillToSize(fillSize: CGSize) {
    guard let texture = texture else {
      return
    }
    
    self.size = texture.size()
    
    let verticalRatio = fillSize.height / texture.size().height
    let horizontalRatio = fillSize.width / texture.size().width
    
    let scaleRatio = horizontalRatio > verticalRatio ? horizontalRatio : verticalRatio
    self.setScale(scaleRatio)
  }
}
