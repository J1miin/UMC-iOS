//
//  BtnTemplate.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/31/25.
//

import SwiftUI

struct BtnTemplate: View {
    let title: String
    let imageName: String
    
    var body: some View {
        Button(action:{
            print(title)
        }){
            VStack {
                Image(imageName)
                    .foregroundColor(.green00)
                Text(title)
                    .font(.mainTextSemiBold16)
                    .foregroundColor(.black)
                Spacer().frame(height: 17)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(radius: 3)
        }
    }
}
