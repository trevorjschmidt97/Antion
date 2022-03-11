//
//  SearchViewModel.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/2/22.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class SearchViewModel: ObservableObject {
    
    @Published var searchUsers: [SearchUser] = []
    var lastSearchDoc: DocumentSnapshot?
    var lastKeyword = ""
    
    func onAppear() {
        querySearch(keyword: "")
    }
    
    func querySearch(keyword: String) {
        if lastKeyword != keyword {
            lastSearchDoc = nil
        }
        lastKeyword = keyword
        
//        FirebaseFirestoreService.shared.pullSearchUsers(keyword: keyword, lastDoc: lastSearchDoc) { [weak self] result in
//            guard let self = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let retSuccess):
//                    if self.lastSearchDoc == nil {
//                        self.searchUsers = retSuccess.0
//                    } else {
//                        let retUsers = retSuccess.0
//                        for retUser in retUsers {
//                            self.searchUsers.append(retUser)
//                        }
//                    }
//                    self.lastSearchDoc = retSuccess.1
//                case .failure(let error):
//                    print("Error")
//                    print(error.localizedDescription)
//                }
//            }
//        }
    }
    
}
