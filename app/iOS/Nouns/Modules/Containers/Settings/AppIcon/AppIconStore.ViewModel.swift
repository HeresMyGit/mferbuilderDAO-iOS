// Copyright (C) 2022 Nouns Collective
//
// Originally authored by Krishna Satyanarayana
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
import Services

extension AppIconStore {
  final class ViewModel: ObservableObject {

    func onAppear() {
//      AppCore.shared.analytics.logScreenView(withScreen: AnalyticsEvent.Screen.appIcon)
    }

    func onAppIconChanged(_ icon: AppIcon, error: Error?) {
//      AppCore.shared.analytics.logEvent(withEvent: AnalyticsEvent.Event.setAlternateAppIcon,
//                                        parameters: [
//                                          "icon_name": icon.name,
//                                          "success": error == nil,
//                                          "error": error?.localizedDescription ?? ""
//                                        ])
    }
  }
}
