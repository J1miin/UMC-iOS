//
//  CircleImageCard.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 4/6/25.
//

import SwiftUI

struct CircleImageCard: View {
    let coffeeItem: CoffeeItem?
    let dessertItem: DessertItem?

    var body: some View {
        VStack(spacing: 10) {
            if let coffee = coffeeItem { // CoffeeItem 처리
                Image(coffee.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(Circle())
                
                Text(coffee.name)
                    .font(.mainTextSemiBold14)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            } else if let dessert = dessertItem { // DessertItem 처리
                Image(dessert.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(Circle())
                
                Text(dessert.name)
                    .font(.mainTextSemiBold14)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

