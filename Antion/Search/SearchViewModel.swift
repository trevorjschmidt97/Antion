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
    
    init() {
        querySearch(keyword: "")
    }
    
    func querySearch(keyword: String) {
        // If it was not a next page query, then the user changed the keyword
        if lastKeyword != keyword {
            lastSearchDoc = nil
            searchUsers = searchUsers.filter{ $0.publicKeyLowercased.contains(keyword.lowercased()) }
        }
        lastKeyword = keyword
        FirebaseFirestoreService.shared.searchUsers(keyword: keyword.lowercased(), lastDoc: lastSearchDoc) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let retObject):
                    withAnimation {
                        self?.searchUsers = retObject.0
                    }
                    self?.lastSearchDoc = retObject.1
                case .failure(let error):
                    if let firestoreError = error as? FirebaseFirestoreService.FirestoreError {
                        if firestoreError == .NoDocuments {
                            print("No More Documents")
                        } else {
                            print(firestoreError)
                        }
                    } else {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    @Published var loadingNextPage = false
    func nextPage() {
        loadingNextPage = true
        FirebaseFirestoreService.shared.searchUsers(keyword: lastKeyword.lowercased(), lastDoc: lastSearchDoc) { [weak self] result in
            DispatchQueue.main.async {
                self?.loadingNextPage = false
                switch result {
                case .success((let retSearchUsers, let retLastDoc)):
                    for searchUser in retSearchUsers {
                        self?.searchUsers.append(searchUser)
                    }
                    self?.lastSearchDoc = retLastDoc
                case .failure(let error):
                    if let firebaseError = error as? FirebaseFirestoreService.FirestoreError {
                        if firebaseError == .NoDocuments {
                            print("No more documents")
                        }
                    } else {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
}
