//
//  WelcomeScreenView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/19/21.
//

import SwiftUI
import MobileCoreServices
import AlertToast

struct WelcomeScreenView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var privateKey: String
    var publicKey: String
    @State private var showCopied = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Your Wallet ID is")
                .fontWeight(.bold)
                .padding(.top, 70)
            
            VStack(alignment: .leading) {
                Text(publicKey.prefix(22))
                Text(publicKey.suffix(22))
            }
                .padding()
            
            Text("Your Private Key is")
                .fontWeight(.bold)
            
            HStack {
                VStack {
                    Text(privateKey.prefix(22))
                    Text(privateKey.suffix(22))
                }
                Spacer()
                Button {
                    UIPasteboard.general.string = privateKey
                    showCopied.toggle()
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                } label: {
                    Image(systemName: "doc.on.clipboard")
                }
            }
                .padding()
            
            HStack {
                Spacer()
                Text("KEEP YOUR SECRET KEY SOMEWHERE SAFE")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                    .padding(.top, 40)
                Spacer()
            }
                
            HStack {
                Spacer()
                Button("Continue") {
                    authViewModel.savePrivateKey(privateKey: privateKey)
                }
                .disabled(authViewModel.saveUserLoading || authViewModel.saveSearchUserLoading || authViewModel.count == nil)
                .font(.title)
                Spacer()
            }
            .padding()
            Spacer()
        }
            .padding()
            .navigationTitle("Welcome")
            .toast(isPresenting: $showCopied,
                duration: 1.5,
                tapToDismiss: true,
                offsetY: 0.0,
                alert: {
                AlertToast(displayMode: .alert,
                                    type: .complete(.green),
                                    title: "Private Key Copied",
                                    subTitle: nil,
                                    style: nil)
                 },
                onTap: nil,
                completion: nil)
            .onAppear {
                authViewModel.createNewUser(privateKey: privateKey)
            }
    }
}

//struct WelcomeScreenView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            WelcomeScreenView()
//        }
//    }
//}
