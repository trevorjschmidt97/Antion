//
//  MerkleTree.swift
//  Antion
//
//  Created by Trevor Schmidt on 3/12/22.
//

import Foundation

typealias MerkleTree = [String:Any]

extension MerkleTree {
    func toString(current: MerkleTree? = nil) -> String {
        // If first call
        let current = current ?? self as MerkleTree
        
        var retString = ""
        
        for key in current.keys {
            retString += key + "\n"
            if let leaf = current[key] as? [String] {
                retString += leaf.joined(separator: ", ") + "\n"
            } else if let branch = current[key] as? MerkleTree {
                retString += toString(current: branch)
            }
        }
        
        return retString
    }
}
