import UIKit
import Firebase
import FirebaseAuth

class Favorite: NSObject {
    var id: String?
    var toId: String?
    var favoriteTimestamp: NSNumber?
    
    var fromId: String?
    var name: String?
    var profileImageUrl: String?
    
    
//    func favoritePartnerId() -> String? {
//        
//        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
//        
//    }
//    
//    init(dictionary: [String: AnyObject]){
//        
//        id = dictionary["id"] as? String
//        toId = dictionary["toId"] as? String
//        favoriteTimestamp = dictionary["favoriteTimestamp"] as? NSNumber
//        fromId = dictionary["fromId"] as? String
//        name = dictionary["name"] as? String
//        profileImageUrl = dictionary["profileImageUrl"] as? String
//        
//        
//        
//    }
    
}
