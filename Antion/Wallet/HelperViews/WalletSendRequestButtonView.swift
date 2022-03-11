//
//  WalletSendRequestButtonView.swift
//  Antion
//
//  Created by Trevor Schmidt on 2/28/22.
//

import SwiftUI

struct WalletSendRequestButtonView: View {
    
    var backGroundColor = AppViewModel.shared.accentColor
    
    var body: some View {
        Text("Send/Request Antion")
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding()
            .background(backGroundColor)
            .cornerRadius(30)
            .padding(.top, -10)
            .padding(.bottom)
    }
}

struct WalletSendRequestButtonView_Previews: PreviewProvider {
    static var previews: some View {
        WalletSendRequestButtonView()
    }
}
