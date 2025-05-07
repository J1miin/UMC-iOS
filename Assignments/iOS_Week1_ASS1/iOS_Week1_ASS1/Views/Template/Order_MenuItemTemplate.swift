import SwiftUI

struct Order_MenuItemTemplate: View {
    let item: MenuItem

    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .background(Circle().fill(Color(.systemGray6)))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 1){
                    Text(item.name)
                        .font(.mainTextSemiBold16)
                        .foregroundColor(.gray06)
                    if item.isNew {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 6, height: 6)
                            .offset(y:-4)
                    }
                }
                Text(item.englishName)
                    .font(.mainTextSemiBold14)
                    .foregroundColor(.gray03)
            }
            Spacer()
        }
    }
}

#Preview {
    Order_MenuItemTemplate(item: MenuItem(
        id: UUID(),
        name: "추천",
        englishName: "Recommend",
        imageName: "recommend",
        category: .drink,
        isNew: true
    ))
}
