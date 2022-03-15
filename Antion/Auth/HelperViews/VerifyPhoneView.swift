//
//  VerifyPhoneView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI
import AlertToast

struct VerifyPhoneView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @FocusState var focusState: String?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            Text("Check your messages for a six-digit security code and enter it below")
                .padding(.top, 50)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
            
            TextField("", text: $authViewModel.otcInput, prompt: nil)
                .font(.body)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.phonePad)
                .submitLabel(.next)
                .textContentType(.oneTimeCode)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                .padding(.horizontal)
                .focused($focusState, equals: "otc")
            
            Button("Submit") {
                if authViewModel.phoneNumberHasBeenUsed == nil {
                    return
                }
                authViewModel.otcSubmitButtonPressed()
                focusState = nil
            }
            .disabled(authViewModel.phoneNumberHasBeenUsed == nil)
            .font(.title)
            .padding()
            
            
            NavigationLink(destination: WelcomeScreenView(privateKey: authViewModel.privateKey, publicKey: authViewModel.publicKey)
                            .navigationBarBackButtonHidden(true),
                           isActive: $authViewModel.isShowingWalletScreen) { EmptyView() }
            
            NavigationLink(destination: ReturningPhoneView().navigationBarBackButtonHidden(true), isActive: $authViewModel.showReturningPhoneView) {
                EmptyView()
            }
            
        }
            .navigationTitle("Verify")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button {
                            focusState = nil
                        } label: {
                            Image(systemName: "keyboard.chevron.compact.down")
                        }
                    }
                }
            }
            .toast(isPresenting: $authViewModel.errorInOtcSubmission,
                duration: 1.5,
                tapToDismiss: true,
                offsetY: 0.0,
                alert: {
                AlertToast(displayMode: .alert,
                           type: .error(.red),
                            title: "Error Verifying Phone, Start Again",
                            subTitle: nil,
                            style: nil)
                 },
                onTap: nil,
                completion: nil)
            .onAppear {
                authViewModel.checkPhoneNumber()
            }
    }
}

struct VerifyPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VerifyPhoneView()
                .environmentObject(AuthViewModel())
        }
    }
}
