////
////  OtherUserSearchView.swift
////  Antion
////
////  Created by Trevor Schmidt on 1/22/22.
////
//
//import SwiftUI
//
//struct OtherUserSearchView: View {
//    
//    var user: Friend
//    
//    var body: some View {
//        HStack {
//            ProfilePicView(username: user.name, profilePicUrl: user.profilePicUrl, size: 50)
//            VStack(alignment: .leading) {
//                Text(user.name)
//                    .fontWeight(.bold)
//                Text("Public Key: ")
//                    .font(.system(.footnote, design: .monospaced))
//                Text("@" + user.publicKey.prefix(22))
//                    .font(.system(.footnote, design: .monospaced))
//                Text(" " + user.publicKey.suffix(22))
//                    .font(.system(.footnote , design: .monospaced))
//            }
//            Spacer()
//            Image(systemName: "chevron.forward")
//        }
//    }
//}
//
////struct SearchUserView_Previews: PreviewProvider {
////    static var previews: some View {
////        OtherUserSearchView()
////    }
////}
