//
//  ReturningPhoneView.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/14/22.
//

import SwiftUI
import AlertToast

struct ReturningPhoneView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var isShowingWalletScreen = false
    @State private var showCopied = false
    
    init() {
        let (sk, pk) = CryptoService.generateKeyPair()
        publicKey = pk
        privateKey = sk
    }
    
    var publicKey: String
    var privateKey: String
    
    @State private var newWallet = false
    
    var body: some View {
        VStack {
            
            if !newWallet {
                Text("You have already created an account")
                
                NavigationLink {
                    SignInView()
                } label: {
                    Text("SIGN IN")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(AppViewModel.shared.accentColor)
                        .cornerRadius(25)
                }
                .padding(.top, 40)
                .padding(.bottom, 40)
                
                Text("OR")
                
                Button {
                    newWallet = true
                } label: {
                    Text("CREATE NEW")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 220, height: 60)
                        .background(AppViewModel.shared.accentColor)
                        .cornerRadius(25)
                }
                .padding(.top, 40)
                .padding(.bottom, 80)
            }
            
            if newWallet {
                Text("Your Wallet ID is")
                    .fontWeight(.bold)
                    .padding(.top, 70)
                
                VStack {
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
                    .font(.title)
                    .disabled(authViewModel.phoneNumberHasBeenUsed == nil)
                    Spacer()
                }
                .padding()
            }
            
            Spacer()
            
            NavigationLink(destination: WelcomeScreenView(privateKey: authViewModel.privateKey, publicKey: authViewModel.publicKey)
                            .navigationBarBackButtonHidden(true),
                           isActive: $isShowingWalletScreen) { EmptyView() }
        }
            .padding()
            .navigationTitle("Welcome Back")
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
    }
}

struct ReturningPersonView_Previews: PreviewProvider {
    static var previews: some View {
        ReturningPhoneView()
    }
}
