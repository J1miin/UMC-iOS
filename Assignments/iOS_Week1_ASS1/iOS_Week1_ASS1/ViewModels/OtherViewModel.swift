//
//  OtherViewModel.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/31/25.
//

import Foundation
import SwiftUI

class OtherViewModel: ObservableObject{
    @AppStorage("nickName") private var storedNickname: String = ""
        
    var savedNickname: String {
        return storedNickname.isEmpty ? "(작성한 닉네임)" : storedNickname
    }
    
}
