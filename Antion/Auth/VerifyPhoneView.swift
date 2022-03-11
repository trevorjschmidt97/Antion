//
//  VerifyPhoneView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI

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
            
            NavigationLink(destination: WelcomeScreenView().navigationBarBackButtonHidden(true),
                           isActive: $authViewModel.isShowingWalletScreen) { EmptyView() }
            Button("Submit") {
                authViewModel.otcSubmitButtonPressed()
                focusState = nil
            }
            .font(.title)
            .padding()
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
