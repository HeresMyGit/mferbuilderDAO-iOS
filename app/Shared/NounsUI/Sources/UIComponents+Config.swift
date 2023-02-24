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

import SwiftUI

public struct NounsUI {
    
    /// Configures all the UI of the package
    public static func configure() {
        registerFonts()
    }
    
    public static func registerFonts() {
        GTWalsheim.allCases.forEach {
            let type = $0 == .bold ? FontType.open  : .true
            Font.registerFont(
                bundle: .module,
                name: $0.rawValue,
                type: type)
        }
    }
}
