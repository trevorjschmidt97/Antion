//
//  SignUpView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @FocusState var focusState: String?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            HStack {
                Text("phone number")
                    .font(.subheadline)
                Spacer()
            }
                .padding(.horizontal)
                .padding(.top, 110)
            
            TextField("(xxx) xxx-xxxx", text: $authViewModel.phoneNumberInput, prompt: Text("(xxx) xxx-xxxx"))
                .font(.body)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .keyboardType(.phonePad)
                .textContentType(.telephoneNumber)
                .submitLabel(.next)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10.0)
                .padding(.horizontal)
                .focused($focusState, equals: "phone")
            
            NavigationLink(destination: VerifyPhoneView(),
                           isActive: $authViewModel.isShowingVerificationScreen) { EmptyView() }
            Button {
                authViewModel.continueButtonPressed()
                focusState = nil
            } label: {
                Text("CONTINUE")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 220, height: 60)
                    .background(AppViewModel.shared.accentColor)
                    .cornerRadius(25)
            }
                .padding(.top, 40)
                .padding(.bottom, 80)
            
            NavigationLink {
                SignInView()
            } label: {
                Text("Already have a private key?")
                    .font(.body)
            }

        }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    authViewModel.requestBiometricUnlock { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let privateKey):
                                AppViewModel.shared.privateKey = privateKey
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Welcome")
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

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AppViewModel.shared)
    }
}
