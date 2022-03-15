//
//  SignUpView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/18/21.
//

import SwiftUI
import AlertToast
import Combine

struct SignUpView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @FocusState var focusState: String?
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            
            // Phone Number
            HStack {
                Text("phone number")
                    .font(.subheadline)
                Spacer()
            }
                .padding(.horizontal)
                .padding(.top, 110)
            
            TextField("(xxx) xxx-xxxx", text: $authViewModel.phoneNumberInput, prompt: Text("(xxx) xxx-xxxx"))
                .onReceive(Just(authViewModel.phoneNumberInput)) { newValue in
                    var filtered = newValue.filter { "+0123456789".contains($0) }
                    filtered = filtered.replacingOccurrences(of: "^0+", with: "", options: .regularExpression)
                    if filtered != newValue {
                        authViewModel.phoneNumberInput = filtered
                    }
                }
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
            
            
            Button {
                authViewModel.initiatePhoneAuth()
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
            
            // Go to sign In Screen
            NavigationLink {
                SignInView()
            } label: {
                Text("Already have a private key?")
                    .font(.body)
            }
            
            // Emptyview to change to phone verification screen
            NavigationLink(destination: VerifyPhoneView(),
                           isActive: $authViewModel.showPhoneVerificationScreen) { EmptyView() }
        }
            .onAppear {
                authViewModel.onAppear()
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
            .toast(isPresenting: $authViewModel.errorSendingPhoneAuthCode,
                duration: 1.5,
                tapToDismiss: true,
                offsetY: 0.0,
                alert: {
                AlertToast(displayMode: .alert,
                           type: .error(.red),
                            title: "Error Starting Authentication",
                            subTitle: nil,
                            style: nil)
                 },
                onTap: nil,
                completion: nil)
            
        
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .environmentObject(AppViewModel.shared)
    }
}
