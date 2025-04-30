import SwiftUI

struct ShopView: View {
    @State private var pageSelection = 0
    var body: some View {
        ScrollView {
            LazyVStack(alignment:.leading, spacing: 31) {
                Top
                AllProducts
                BestProducts
                NewProducts
            }
        }.padding(.horizontal,16)
    }
    
    private var Top : some View{
        VStack(alignment: .leading){
            Text("Starbucks Online Store")
                .font(.mainTextBold24)
            ScrollView(.horizontal){
                LazyHStack(){
                    Image("shopBanner1")
                    Image("shopBanner2")
                    Image("shopBanner3")
                }
            }
        }
    }
    
    private var AllProducts : some View {
        VStack(alignment: .leading, spacing: 16){
            Text("All Products")
                .font(.mainTextBold24)
            ScrollView(.horizontal){
                LazyHStack(spacing: 17){
                    VStack(){
                        Image("tumblr")
                        Text("텀블러").font(.mainTextRegular13)
                    }
                    VStack(){
                        Image("coffeeitem")
                        Text("커피 용품").font(.mainTextRegular13)
                    }
                    VStack(){
                        Image("giftset")
                        Text("선물세트").font(.mainTextRegular13)
                    }
                    VStack(){
                        Image("hottumblr")
                        Text("보온병").font(.mainTextRegular13)
                    }
                    VStack(){
                        Image("mug")
                        Text("머그/컵").font(.mainTextRegular13)
                    }
                    VStack(){
                        Image("lifestyle")
                        Text("라이프스타일").font(.mainTextRegular13)
                    }
   
                }
            }
        }
    }
    private var BestProducts : some View {
        VStack(alignment: .leading){
            Text("New Products")
                .font(.mainTextBold24)
            let columns = [
                GridItem(.flexible(), spacing: 65),
                GridItem(.flexible(), spacing: 65)
            ]
            let items = [("greenSirenSleeve","그린 사이렌 슬리브 머그 355ml"),
                         ("greenSirenClassic","그린 사이렌 클래식 머그 355ml"),
                         ("sirenMugWood","사이렌 머그 앤 우드 소서"),
                         ("reserveGoldTail","리저브 골드 테일 머그 355ml")]
            ScrollView() {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(items.indices, id: \.self) { i in
                                let item = items[i]
                        VStack {
                            Image(item.0)
                            Text(item.1).font(.mainTextSemiBold14)
                                .frame(width: 160)
                        }
                        .frame(width: 140)
                    }
                }
                .padding()
            }
        }
    }
    
    private var NewProducts : some View {
        VStack(alignment: .leading){
            Text("New Products")
                .font(.mainTextBold24)
            let columns = [
                GridItem(.flexible(), spacing: 65),
                GridItem(.flexible(), spacing: 65)
            ]
            let items = [("greenSirenMug","그린 사이렌 도트 머그 237ml"),
                         ("greenSirenMug","그린 사이렌 도트 머그 237ml"),
                         ("homeCafeMug","홈 카페 미니 머그 세트"),
                         ("homeCafeMug","홈 카페 미니 머그 세트")]
            ScrollView() {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(items.indices, id: \.self) { i in
                                let item = items[i]
                        VStack {
                            Image(item.0)
                            Text(item.1).font(.mainTextSemiBold14)
                                .frame(width: 160)
                        }
                        .frame(width: 140)
                    }
                }
                .padding()
            }

        }
    }

    
}


#Preview {
    ShopView()
}
