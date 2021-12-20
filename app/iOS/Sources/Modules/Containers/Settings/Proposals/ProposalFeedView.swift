//
//  ProposalFeedView.swift
//  Nouns
//
//  Created by Ziad Tamim on 06.12.21.
//

import SwiftUI
import UIComponents
import Services

/// List all proposals with pagination.
struct ProposalFeedView: View {
  @StateObject var viewModel: ViewModel
  
  @State private var isGovernanceInfoPresented = false
  @Environment(\.dismiss) private var dismiss
  @Environment(\.outlineTabViewHeight) private var tabBarHeight
  private let localize = R.string.proposal.self
  
  var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
      LazyVStack {
        ForEach(viewModel.proposals, id: \.id) {
          ProposalRow(viewModel: .init(proposal: $0))
        }
      }
      .padding(.horizontal, 20)
      .padding(.bottom, tabBarHeight)
      // Extra padding between the bottom of the last noun card and the top of the tab view
      .padding(.bottom, 20)
      .ignoresSafeArea()
      .softNavigationTitle(localize.title(), leftAccessory: {
        SoftButton(
          icon: { Image.back },
          action: { dismiss() })
        
      }, rightAccessory: {
        SoftButton(
          icon: { Image.help },
          action: {
            withAnimation {
              isGovernanceInfoPresented.toggle()
            }
          })
      })
    }
    .background(Gradient.bubbleGum)
    .bottomSheet(isPresented: $isGovernanceInfoPresented) {
      GovernanceInfoCard(isPresented: $isGovernanceInfoPresented)
    }
  }
}
