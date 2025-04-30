import SwiftUI

struct ReceiptView: View {
    var body: some View {
        HStack(){
            Image("leftArrow")
            Spacer()
            Text("전자영수증")
            Spacer()
            Image("plus")
        }.padding(.horizontal,13.5)
        Spacer()
    }
}

#Preview {
    ReceiptView()
}
