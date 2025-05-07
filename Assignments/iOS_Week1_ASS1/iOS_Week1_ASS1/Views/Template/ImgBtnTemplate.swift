//
//  ImgBtnTemplate.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/31/25.
//

import SwiftUI

struct ImgBtnTemplate: View {
    let title : String
    let imgName : String
    
    var body: some View {
        Button(action:{
            print(title)
        }){
            HStack {
                Image(imgName)
                    .resizable()
                    .frame(width:32, height:32)
                Text(title)
                    .font(.mainTextSemiBold16)
                    .foregroundStyle(Color.black02)
                
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

