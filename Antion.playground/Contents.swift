import SwiftUI
import CryptoKit

extension String {
    func slashToDash() -> String {
        return self.replacingOccurrences(of: "/", with: "-")
    }
    
    func dashToSlash() -> String {
        return self.replacingOccurrences(of: "-", with: "/")
    }
}


func generateKeyPair() -> (String, String) {
    let privateKey = Curve25519.Signing.PrivateKey.init()
    return (privateKey.rawRepresentation.base64EncodedString(), privateKey.publicKey.rawRepresentation.base64EncodedString())
}

var i = 0
while true {
    let (sk, pk) = generateKeyPair()
    print(sk.slashToDash(), pk.slashToDash(), i)
    
    i += 1
    if i == 100 {
        break
    }

}
