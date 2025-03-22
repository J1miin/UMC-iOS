//
//  Fonts.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/22/25.
//

import Foundation
import SwiftUI

extension Font {
    enum Pretend {
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        
        var value: String {
            switch self {
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static var mainTextBold20: Font {
        return .pretend(type: .bold, size: 20)
    }
    static var mainTextBold24: Font {
        return .pretend(type: .bold, size: 24)
    }
    static var mainTextSemiBold24: Font {
        return .pretend(type: .semibold, size: 24)
    }
    static var mainTextSemiBold18: Font {
        return .pretend(type: .semibold, size: 18)
    }
    static var mainTextSemiBold16: Font {
        return .pretend(type: .semibold, size: 16)
    }
    static var mainTextSemiBold14: Font {
        return .pretend(type: .semibold, size: 14)
    }
    static var mainTextMedium16: Font {
        return .pretend(type: .medium, size: 16)
    }
    static var mainTextRegular18: Font {
        return .pretend(type: .regular, size: 18)
    }
    static var mainTextRegular13: Font {
        return .pretend(type: .regular, size: 13)
    }
    static var mainTextRegular12: Font {
        return .pretend(type: .regular, size: 12)
    }
    static var mainTextRegular09: Font {
        return .pretend(type: .regular, size: 09)
    }
    static var mainTextLight14: Font {
        return .pretend(type: .light, size: 14)
    }
    static var mainTextExtraBold24: Font {
        return .pretend(type: .extraBold, size: 24)
    }
    static var mainTextExtraBold38: Font {
        return .pretend(type: .extraBold, size: 38)
    }
    static var mainTextExtraBold13: Font {
        return .pretend(type: .extraBold, size: 13)
    }
    
    //Button Text
    static var makeMeduim18: Font {
        return .pretend(type: .medium, size: 18)
    }
    
    
    
    /* 여기에 더 추가해주세요 */
    
}
