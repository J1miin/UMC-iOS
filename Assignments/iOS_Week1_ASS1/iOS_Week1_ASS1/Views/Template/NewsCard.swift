//
//  NewsCard.swift
//  iOS_Week1_ASS1
//
//  Created by 김지민 on 4/6/25.
//

import SwiftUI

struct NewsCard: View {
    let newsItem: NewsItem
        
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(newsItem.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 160)
            Spacer().frame(height: 16)
            
            Text(newsItem.title)
                .font(.mainTextSemiBold18)
                .foregroundStyle(Color.black02)
                .lineLimit(1)
            Spacer().frame(height: 9)
            Text(newsItem.description)
                .font(.mainTextSemiBold14)
                .foregroundColor(Color.gray03)
                .lineLimit(2)
        }.frame(width: 242)
    }
}
