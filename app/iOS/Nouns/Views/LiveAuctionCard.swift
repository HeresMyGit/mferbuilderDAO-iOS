//
//  LiveAuctionCard.swift
//  Nouns
//
//  Created by Ziad Tamim on 04.11.21.
//

import SwiftUI
import UIComponents
import Services

/// <#Description#>
/// - Parameters:
///   - state: <#state description#>
///   - action: <#action description#>
/// - Returns: <#description#>
func liveAuctionReducer(state: LiveAuctionState, action: LiveAuctionAction) -> LiveAuctionState {
  fatalError("\(#function) must be implemented.")
}

/// <#Description#>
struct LiveAuctionState {
  var auction: Auction
}

/// <#Description#>
enum LiveAuctionAction {
  case listen
  case sink(Auction)
  case failure(Error)
}

/// <#Description#>
struct LiveAuctionCard: View {
  
  let noun: String
  
  var body: some View {
    StandardCard(media: {
      Image("placeholder")
        .resizable()
        .aspectRatio(nil, contentMode: .fit)
    }, label: {
      HStack(alignment: .bottom) {
          VStack(alignment: .leading, spacing: 4) {
              Text(noun)
                  .font(.title2)
                  .fontWeight(.semibold)
              
              Text("Oct 5 2011")
                  .font(.caption)
          }
          
          Spacer()
          
          VStack(alignment: .leading, spacing: 4) {
              Text("269.69")
                  .fontWeight(.medium)
              
              Text("Current Bid")
                  .font(.caption)
          }
        
        Spacer()
        
        VStack(alignment: .leading, spacing: 4) {
            Text("00:08:03")
                .font(.caption)
                .contained(color: Color.componentRaspberry)

            Text("Remaining")
                .font(.caption)
        }
      }
    }, roundedCorners: [.bottomLeft, .bottomRight])
  }
}

struct LiveAuctionCardPreview: PreviewProvider {
  static var previews: some View {
    LiveAuctionCard(noun: "Noun 64")
  }
}
