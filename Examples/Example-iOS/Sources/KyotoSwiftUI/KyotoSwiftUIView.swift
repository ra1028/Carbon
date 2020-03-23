import SwiftUI

struct KyotoSwiftUIView: View {
    var body: some View {
        List {
            KyotoTop()
//                .referenceSize {
//                    CGSize(width: $0.width - 100, height: 200)
//            }
//                .sizeFitting(nil)
//                .fixedSize(horizontal: false, vertical: true)

            Header("PHOTOS")

            VStack {
                HStack {
                    KyotoImage(title: "Fushimi Inari-taisha", image: #imageLiteral(resourceName: "KyotoFushimiInari"))
                    KyotoImage(title: "Arashiyama", image: #imageLiteral(resourceName: "KyotoArashiyama"))
                }

                HStack {
                    KyotoImage(title: "Byōdō-in", image: #imageLiteral(resourceName: "KyotoByōdōIn"))
                    KyotoImage(title: "Gion", image: #imageLiteral(resourceName: "KyotoGion"))
                }

                HStack {
                    KyotoImage(title: "Kiyomizu-dera", image: #imageLiteral(resourceName: "KyotoKiyomizuDera"))
                    Color.clear
                }
            }
            .padding(.horizontal, 16)

            KyotoLicense {
                let url = URL(string: "https://unsplash.com/")!
                UIApplication.shared.open(url)
            }
        }
        .navigationBarTitle("Kyoto")
    }
}

struct KyotoSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        KyotoSwiftUIView()
    }
}
