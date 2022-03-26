//
//  WalletSendRequestButtonView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletSendRequestButtonView: View {
    
    @Binding var createNewTransaction: Bool
    var backGroundColor = AppViewModel.shared.accentColor
    
    var body: some View {
        Button {
            createNewTransaction.toggle()
        } label: {
            Text("Send/Request Antion")
                .foregroundColor(.white)
                .fontWeight(.bold)
                .padding(12)
                .background(backGroundColor)
                .cornerRadius(30)
                .padding(.top, -15)
                .padding(.bottom)
        }
    }
}

//struct WalletSendRequestButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletSendRequestButtonView()
//    }
//}
