//
//  ProfilePicView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/23/21.
//

import SwiftUI
import CachedAsyncImage

struct ProfilePicView: View {
    
    var publicKey: String
    var size: Double = 90
    
    var username: String? {
        AppViewModel.shared.name(for: publicKey)
    }
    var profilePicUrll: String? {
        AppViewModel.shared.profilePicUrl(for: publicKey)
    }
    
    var body: some View {
        Group {
            if let profilePicUrll = profilePicUrll {
                CachedAsyncImage(url: URL(string: profilePicUrll)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.secondary, lineWidth: 2))
                } placeholder: {
                    ProgressView()
                        .frame(width: size, height: size)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(.secondary, lineWidth: 2))
                }
            } else {
//                Image(systemName: "person.crop.circle")
//                    .font(.system(size: size))
//                    .frame(width: size, height: size)
//                    .clipShape(Circle())
//                    .overlay(Circle().stroke(.secondary, lineWidth: 2))
                ZStack {
                    Circle()
                        .fill(.gray)
                        .opacity(50)
                        .overlay(Circle().stroke(.secondary, lineWidth: 2))
                        .frame(width: size, height: size)

                    if let username = username {
                        Text("\(String(username == "Anonymous" ? "👽" : username == "Block Reward" ? "A" : username.first ?? Character("?")))")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: size, height: size)
                    } else {
                        Text("💰")
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: size, height: size)
                    }
                }
            }
        }
        .padding(.trailing)
    }
}

//struct ProfilePicView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePicView(username: "holyschmiddty", profilePicUrl: "")
//    }
//}

//    = "https://firebasestorage.googleapis.com/v0/b/w8trkr-3356b.appspot.com/o/userProfilePics%2FDcapBesjwuhYBbE3q5mG3gll4iy2.jpg?alt=media&token=7f316ec4-4685-4c7f-a63f-98b9461c101a"
