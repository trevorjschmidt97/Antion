//
//  WalletHeaderView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletHeaderView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    
    @Binding var settingsButtonSelected: Bool
    @Binding var showCopied: Bool
    
    var appColor = AppViewModel.shared.accentColor
    
    var body: some View {
        HStack {
            ProfilePicView(username: viewModel.user.name, profilePicUrl: viewModel.user.profilePicUrl, size: 80)
            VStack(alignment: .leading) {
                Text(viewModel.user.name)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Text("Public Key:")
                    .font(.system(.caption, design: .monospaced))
                Text("@" + viewModel.user.publicKey.prefix(22))
                    .font(.system(.caption, design: .monospaced))
                Text(" " + viewModel.user.publicKey.suffix(22))
                    .font(.system(.caption, design: .monospaced))
            }
            .padding(.leading, -5)
            
            Spacer()
            
            Button {
                UIPasteboard.general.string = viewModel.user.publicKey
                showCopied.toggle()
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
            } label: {
                Image(systemName: "doc.on.clipboard")
            }
                .foregroundColor(appColor)
            
            if viewModel.walletState == .own {
                Button {
                    settingsButtonSelected.toggle()
                } label: {
                    Image(systemName: "gearshape")
                }
                    .foregroundColor(appColor)
            }

            
        }
        .padding(.horizontal)
    }
}

//struct WalletHeaderView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletHeaderView(publicKey: "", name: "", profilePicUrl: "")
//    }
//}
