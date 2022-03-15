//
//  SignInView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI
import AlertToast

struct SignInView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @FocusState var focusState: String?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            HStack {
                Text("private key:")
                    .font(.subheadline)
                Spacer()
            }
                .padding(.horizontal)
                .padding(.top, 110)
                .frame(maxWidth: 600)
            
            TextField("", text: $authViewModel.signInPrivateKeyInput, prompt: nil)
                .font(.body)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.asciiCapable)
                .submitLabel(.next)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                .padding(.horizontal)
                .frame(maxWidth: 600)
                .focused($focusState, equals: "privateKey")

            Button {
                authViewModel.signInButtonPressed()
                focusState = nil
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
                .padding(.bottom, 80)
            
        }
            .navigationTitle("Sign In")
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
            .toast(isPresenting: $authViewModel.showInvalidPrivateKey,
                duration: 1.5,
                tapToDismiss: true,
                offsetY: 0.0,
                alert: {
                AlertToast(displayMode: .alert,
                           type: .error(.red),
                            title: "Invalid Private Key",
                            subTitle: nil,
                            style: nil)
                 },
                onTap: nil,
                completion: nil)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SignInView()
                .environmentObject(AuthViewModel())
        }
    }
}
