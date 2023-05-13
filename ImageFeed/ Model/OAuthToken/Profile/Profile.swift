import Foundation

struct Profile: Decodable {
    let userName: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from result: ProfileResult) {
        self.userName = result.username 
        self.name = "\(result.firstName) \(result.lastName)"
        self.loginName = "@\(userName)"
        self.bio = result.bio
    }
}
