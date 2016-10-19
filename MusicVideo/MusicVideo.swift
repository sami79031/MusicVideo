//
// MusicVideo.swift
// MusicVideo
//
import Foundation
class Videos {
    
    // Data encapsulation
    var vRank = 0
    fileprivate(set) var vName:String?
    fileprivate(set) var vRights:String?
    fileprivate(set) var vPrice:String?
    fileprivate(set) var vImageUrl:String?
    fileprivate(set) var vArtist:String?
    fileprivate(set) var vVideoUrl:String?
    fileprivate(set) var vImid:String?
    fileprivate(set) var vGenre:String?
    fileprivate(set) var vLinkToiTunes:String?
    fileprivate(set) var vReleaseDte:String?
    
    var vImageData:Data?
    
    //Make a getter
    
//    var vName: String {
//        return _vName
//    }
    
    
    
    
    init(data: JSONDictionary) {
        
        //If we do not initialize all properties we will get error message
        //Return from initializer without initializing all stored properties
        
        
        
        // Video name
        if let name = data["im:name"] as? JSONDictionary,
            let vName = name["label"] as? String {
                self.vName = vName
        }
        
        
        // The Studio Name
        if let rights = data["rights"] as? JSONDictionary,
            let vRights = rights["label"] as? String {
                self.vRights = vRights
        }
        
        
        // Price of Video
        
        if let price = data["im:price"] as? JSONDictionary,
            let vPrice = price["label"] as? String {
                self.vPrice = vPrice
        }
        
        // The Video Image
        if let img = data["im:image"] as? JSONArray,
            let image = img[2] as? JSONDictionary,
            let immage = image["label"] as? String {
                vImageUrl = immage.replacingOccurrences(of: "100x100", with: "600x600")
        }
        
        
        // The Artist Name
        if let artist = data["im:artist"] as? JSONDictionary,
            let vArtist = artist["label"] as? String {
                self.vArtist = vArtist
        }
        
        
        
        //Video Url
        if let video = data["link"] as? JSONArray,
            let vUrl = video[1] as? JSONDictionary,
            let vHref = vUrl["attributes"] as? JSONDictionary,
            let vVideoUrl = vHref["href"] as? String {
                self.vVideoUrl = vVideoUrl
        }
        
        
        
        
        // The Artist ID for iTunes Search API
        if let imid = data["id"] as? JSONDictionary,
            let vid = imid["attributes"] as? JSONDictionary,
            let vImid = vid["im:id"] as? String {
                self.vImid = vImid
        }
        
        
        // The Genre
        if let genre = data["category"] as? JSONDictionary,
            let rel2 = genre["attributes"] as? JSONDictionary,
            let vGenre = rel2["term"] as? String {
                self.vGenre = vGenre
        }
        
        
        // Video Link to iTunes
        if let release2 = data["id"] as? JSONDictionary,
            let vLinkToiTunes = release2["label"] as? String {
                self.vLinkToiTunes = vLinkToiTunes
        }
        
        
        
        // The Release Date
        if let release2 = data["im:releaseDate"] as? JSONDictionary,
            let rel2 = release2["attributes"] as? JSONDictionary,
            let vReleaseDte = rel2["label"] as? String {
                self.vReleaseDte = vReleaseDte
        }
        
        
    }
    
}
