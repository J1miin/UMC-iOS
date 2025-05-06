//
//  AdView.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 3/31/25.
//

import SwiftUI

struct AdView: View {
//    @Environment(\.dismiss) var dismiss
    @Binding var showAd: Bool
    
    var body: some View {
        VStack{
            AdPopUp
            Spacer().frame(height:36)
        }.padding(.horizontal, 19)
    }
    
    private var AdPopUp : some View{
        VStack{
            Image("promotionImg")
                .resizable()
                .scaledToFit()
                .frame(width: 438, height: 720)
                .ignoresSafeArea()
                
            Group{
                Button(action: {
                    print("자세히 보기")
                }) {
                    Text("자세히 보기")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .frame(height: 58)
                        .background(Color.green01)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .font(.makeMeduim18)
                }
                HStack {
                    Spacer() // Spacer를 넣어 버튼을 오른쪽으로 정렬
                    Button(action: {
                        DispatchQueue.main.async {
                            showAd = false
                        }
                        //dismiss()
                    }) {
                        Text("X 닫기")
                            .foregroundColor(.gray05)
                            .font(.mainTextLight14)
                    }.padding(.vertical,19)
                }
                Spacer().frame(height: 36)
            }
            
        }.frame(height: 920)
        
    }
}

#Preview {
    AdView(showAd: .constant(true))
}
