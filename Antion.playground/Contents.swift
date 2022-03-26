import SwiftUI
import CryptoKit

extension Date {
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    func toLongString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return formatter.string(from: self)
    }
}

extension String {
    func longStringToDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        return formatter.date(from: self) ?? Date()
    }
}

let dateString1 = "2022-03-17 21:02:06.5410"
let dateString2 = "2022-03-28 08:22:43.1234"

let date1 = dateString1.longStringToDate()
let date2 = dateString2.longStringToDate()

let minutesDifference = date2.minutes(from: date1)



print(minutesDifference)



let miningReward = 40000
let index = 2016

let difficulty = 4

let week = Int(floor(Double(index)/2016))
print("week")
print(week)
if week > 0 {
    //grab block[week * 2016]'s difficulty
    //grab block[week*2016]'s timestamp
    //find difference
}

print(floor(Double(index)/2016))

print(floor(Double(index)/100000))
print(Int(Double(miningReward) * pow(0.5, floor(Double(index)/100000))))

//extension String {
//    func slashToDash() -> String {
//        return self.replacingOccurrences(of: "/", with: "-")
//    }
//
//    func dashToSlash() -> String {
//        return self.replacingOccurrences(of: "-", with: "/")
//    }
//}
//
//
//func generateKeyPair() -> (String, String) {
//    let privateKey = Curve25519.Signing.PrivateKey.init()
//    return (privateKey.rawRepresentation.base64EncodedString(), privateKey.publicKey.rawRepresentation.base64EncodedString())
//}
//
//var i = 0
//while true {
//    let (sk, pk) = generateKeyPair()
//    print(sk.slashToDash(), pk.slashToDash(), i)
//
//    i += 1
//    if i == 100 {
//        break
//    }
//
//}
