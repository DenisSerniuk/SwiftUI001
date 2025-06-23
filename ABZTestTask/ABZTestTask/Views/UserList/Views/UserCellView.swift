//
//  UserCellView.swift
//  ABZTestTask
//
//  Created by Denis Sernuk on 13.06.2025.
//

import SwiftUI

struct UserCellView: View {
    
    private enum Constants {
        static let imageSize: CGSize = CGSize(width: 50, height: 50)
        static let nameLeading: CGFloat = 16
        static let primarySize: CGFloat = 18
        static let secondarySize: CGFloat = 14
        static var roleLeading: CGFloat {
            Constants.imageSize.width + Constants.nameLeading
        }
        static var contactInfoLeading: CGFloat {
            Constants.imageSize.width + Constants.nameLeading
        }
    }
    
    let name: String
    let role: String
    let contactInfo: String
    let phoneInfo: String
    var imagePath: String? = nil
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Group {
                if let imagePath = imagePath {
                    AsyncImage(url: URL(string: imagePath)) { image in
                        customizedImage(image)
                    } placeholder: {
                        customizedImage(Image("NoInternet"))
                    }
                } else {
                    customizedImage(Image("NoInternet"))
                }
            }
            
            VStack(alignment: .leading) {
                Text(name)
                    .lineLimit(3)
                    .font(.system(size: Constants.primarySize))
                    .padding(.bottom, 4)
                
                Text(role)
                    .font(.system(size: Constants.secondarySize))
                    .foregroundStyle(Color.secondaryTextColor)
                    .padding(.bottom, 8)
                Text("\(contactInfo) \n\(phoneInfo)")
                    .font(.system(size: Constants.secondarySize))
                    .padding(.bottom, 24)
                
            }.padding(.leading, 16)
        }.padding(EdgeInsets(top: 0,
                             leading: 16,
                             bottom: 0,
                             trailing: 16))

    }
    
    func customizedImage(_ image: Image) -> some View {
        image.resizable()
            .aspectRatio(contentMode: .fill)
            .clipShape(Circle())
            .frame(width:  Constants.imageSize.width,
                   height:  Constants.imageSize.height)
    }
}

#Preview {
    UserCellView(name: "Seraphina Anastasia Isolde Aurelia Celestina von Hohenzollern",
                 role: "Backend developer",
                 contactInfo: "maximus_wilderman_ronaldo_schuppe",
                 phoneInfo: "+38 (098) 278 76 24")
}
