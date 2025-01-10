//
//  View+Extensions.swift
//  HabitTracker
//
//  Created by Jamerson Macedo on 09/01/25.
//

import Foundation
import SwiftUI
extension View{
    func hSpacing(_ alignment : Alignment) -> some View{
        self.frame(maxWidth: .infinity,alignment: alignment)
    }
    func vSpacing(_ alignment : Alignment) -> some View{
        self.frame(maxHeight: .infinity,alignment: alignment)
    }
    func applyPaddedBackground(_ radius :CGFloat,hPadding : CGFloat = 15,vPadding : CGFloat = 15) -> some View{
        self.padding(.horizontal,hPadding)
            .padding(.vertical,vPadding)
            .background(.background,in: .rect(cornerRadius: radius))
        
    }
    func disableWithOpacity(_ status : Bool) -> some View{
        self.disabled(status)
            .opacity(status ? 0.5 : 1)
    }
    func opacityShadow(_ color:Color, opacity : CGFloat, radius : CGFloat) -> some View{
        self.shadow(color: color.opacity(opacity), radius: radius)
    }
    
}
