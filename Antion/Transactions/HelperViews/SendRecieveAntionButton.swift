//
//  SendRecieveButton.swift
//  Antion
//
//  Created by Trevor Schmidt on 1/14/22.
//

import SwiftUI

struct SendRecieveAntionButton: View {
    
    @EnvironmentObject var appViewModel: AppViewModel
    
    var body: some View {
        Text("Send / Request Antion")
            .foregroundColor(.white)
            .font(.headline)
            .fontWeight(.bold)
            .padding()
            .background(appViewModel.accentColor)
            .cornerRadius(30)
            .padding()
    }
}

struct SendRecieveButton_Previews: PreviewProvider {
    static var previews: some View {
        SendRecieveAntionButton()
    }
}
