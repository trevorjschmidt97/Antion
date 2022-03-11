//
//  WalletHeaderView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletHeaderView: View {
    
    var publicKey: String
    var name: String
    var profilePicUrl: String
    
    @Binding var settingsButtonSelected: Bool
    
    var appColor = AppViewModel.shared.accentColor
    
    var body: some View {
        HStack {
            ProfilePicView(username: name, profilePicUrl: profilePicUrl, size: 80)
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("Public Key:")
                    .font(.system(.caption, design: .monospaced))
                Text("@" + publicKey.prefix(22))
                    .font(.system(.caption, design: .monospaced))
                Text(" " + publicKey.suffix(22))
                    .font(.system(.caption, design: .monospaced))
            }
            .padding(.leading, -5)
            
            Spacer()
            Image(systemName: "doc.on.doc")
                .foregroundColor(appColor)
            Button {
                settingsButtonSelected.toggle()
            } label: {
                Image(systemName: "gearshape")
            }
                .foregroundColor(appColor)

            
        }
        .padding(.horizontal)
    }
}

//struct WalletHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletHeaderView(publicKey: "", name: "", profilePicUrl: "")
//    }
//}
