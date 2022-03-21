//
//  ProfilePicView.swift
//  Antion
//
//  Created by Trevor Schmidt on 12/23/21.
//

import SwiftUI

struct ProfilePicView: View {
    var username: String
    var profilePicUrl: String
//    = "https://firebasestorage.googleapis.com/v0/b/w8trkr-3356b.appspot.com/o/userProfilePics%2FDcapBesjwuhYBbE3q5mG3gll4iy2.jpg?alt=media&token=7f316ec4-4685-4c7f-a63f-98b9461c101a"
    var size: Double = 90
    
    var body: some View {
        Group {
            if profilePicUrl != "" {
                AsyncImage(url: URL(string: profilePicUrl)) { image in
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
                ZStack {
                    Circle()
                        .fill(.gray)
                        .opacity(50)
                        .overlay(Circle().stroke(.secondary, lineWidth: 2))
                        .frame(width: size, height: size)
                    
                    Text("\(String(username == "Anonymous" ? "?" : username.first ?? Character("?")))")
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: size, height: size)
                }
            }
        }
        .padding(.trailing)
    }
}

//ZStack {
//    Circle()
//        .fill(.gray)
//        .opacity(50)
//        .overlay(Circle().stroke(.secondary, lineWidth: 2))
//        .frame(width: size, height: size)
//
//    Text("\(String(username.first ?? Character(" ")))")
//        .font(.title)
//        .foregroundColor(.white)
//        .frame(width: size, height: size)
//}

struct ProfilePicView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePicView(username: "holyschmiddty", profilePicUrl: "")
    }
}
