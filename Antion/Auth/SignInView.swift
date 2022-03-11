//
//  SignInView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI

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
            
            TextField("", text: $authViewModel.privateKeyInput, prompt: nil)
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
            
            Button("Pull privateKey") {
                authViewModel.pullPrivateKeyButtonPressed()
            }
            
            
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
