//
//  RequestedFriendView.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/20/22.
//

import SwiftUI

struct RequestedFriendView: View {
    
    @ObservedObject var viewModel: WalletViewModel
    var requestedFriend: RequestedFriend
    
    @State private var showSheet = false
    
    var body: some View {
        HStack {
            ProfilePicView(username: requestedFriend.friend.name, profilePicUrl: requestedFriend.friend.profilePicUrl, size: 50)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(requestedFriend.friend.name)
                            .fontWeight(.bold)
                        Text(" Public Key: ")
                            .font(.system(.footnote, design: .monospaced))
                        Text(" @" + requestedFriend.friend.publicKey.prefix(22))
                            .font(.system(.footnote, design: .monospaced))
                        Text("  " + requestedFriend.friend.publicKey.suffix(22))
                            .font(.system(.footnote , design: .monospaced))
                        
                    }
                    .padding(.leading, -10)
                    Spacer()
                    Image(systemName: "chevron.forward")
                }
                
                HStack {
                    if requestedFriend.requestState == .fromSelf {
                        selfRequestedButtons()
                    } else {
                        otherRequestedButtons()
                    }
                }
                .padding(.trailing)
            }
        }
        .padding(.horizontal)
        .onTapGesture {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            NavigationView {
                WalletView(publicKey: requestedFriend.friend.publicKey, name: requestedFriend.friend.name, profilePicUrl: requestedFriend.friend.profilePicUrl)
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading) {
                            Button("Done") {
                                showSheet.toggle()
                            }
                        }
                    }
            }
        }
        Divider()
    }
    
    @ViewBuilder
    func selfRequestedButtons() -> some View {
        Button {
            print("Cancel friend request")
        } label: {
            HStack {
                Spacer()
                Text("Cancel")
                    .fontWeight(.bold)
                Spacer()
            }
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .background(AppViewModel.shared.accentColor)
                .cornerRadius(20)
                .padding(.horizontal, 1)
        }
        
        
//        HStack {
//            Spacer()
//            Text("Remind")
//                .fontWeight(.bold)
//            Spacer()
//        }
//            .foregroundColor(.white)
//            .padding(.vertical, 4)
//            .background(AppViewModel.shared.accentColor)
//            .cornerRadius(20)
//            .padding(.horizontal, 1)
    }
    @ViewBuilder
    func otherRequestedButtons() -> some View {
        
        Button {
            print("Reject friend request")
        } label: {
            HStack {
                Spacer()
                Text("Reject")
                    .fontWeight(.bold)
                Spacer()
            }
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .background(AppViewModel.shared.accentColor)
                .cornerRadius(20)
                .padding(.horizontal, 1)
        }
        
        
        
        Button {
            print("Accept friend request")
        } label: {
            HStack {
                Spacer()
                Text("Accept")
                    .fontWeight(.bold)
                Spacer()
            }
                .foregroundColor(.white)
                .padding(.vertical, 4)
                .background(AppViewModel.shared.accentColor)
                .cornerRadius(20)
                .padding(.horizontal, 1)
        }

        
    }
}

//struct RequestedFriendView_Previews: PreviewProvider {
//    static var previews: some View {
//        RequestedFriendView()
//    }
//}
