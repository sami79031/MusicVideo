//
// MusicVideo.swift
// MusicVideo
//
import Foundation
class Videos {
    
    // Data encapsulation
    var vRank = 0
    private(set) var vName:String?
    private(set) var vRights:String?
    private(set) var vPrice:String?
    private(set) var vImageUrl:String?
    private(set) var vArtist:String?
    private(set) var vVideoUrl:String?
    private(set) var vImid:String?
    private(set) var vGenre:String?
    private(set) var vLinkToiTunes:String?
    private(set) var vReleaseDte:String?
    
    var vImageData:NSData?
    
    //Make a getter
    
//    var vName: String {
//        return _vName
//    }
    
    
    
    
    init(data: JSONDictionary) {
        
        //If we do not initialize all properties we will get error message
        //Return from initializer without initializing all stored properties
        
        
        
        // Video name
        if let name = data["im:name"] as? JSONDictionary,
            vName = name["label"] as? String {
                self.vName = vName
        }
        
        
        // The Studio Name
        if let rights = data["rights"] as? JSONDictionary,
            vRights = rights["label"] as? String {
                self.vRights = vRights
        }
        
        
        // Price of Video
        
        if let price = data["im:price"] as? JSONDictionary,
            vPrice = price["label"] as? String {
                self.vPrice = vPrice
        }
        
        // The Video Image
        if let img = data["im:image"] as? JSONArray,
            image = img[2] as? JSONDictionary,
            immage = image["label"] as? String {
                vImageUrl = immage.stringByReplacingOccurrencesOfString("100x100", withString: "600x600")
        }
        
        
        // The Artist Name
        if let artist = data["im:artist"] as? JSONDictionary,
            vArtist = artist["label"] as? String {
                self.vArtist = vArtist
        }
        
        
        
        //Video Url
        if let video = data["link"] as? JSONArray,
            vUrl = video[1] as? JSONDictionary,
            vHref = vUrl["attributes"] as? JSONDictionary,
            vVideoUrl = vHref["href"] as? String {
                self.vVideoUrl = vVideoUrl
        }
        
        
        
        
        // The Artist ID for iTunes Search API
        if let imid = data["id"] as? JSONDictionary,
            vid = imid["attributes"] as? JSONDictionary,
            vImid = vid["im:id"] as? String {
                self.vImid = vImid
        }
        
        
        // The Genre
        if let genre = data["category"] as? JSONDictionary,
            rel2 = genre["attributes"] as? JSONDictionary,
            vGenre = rel2["term"] as? String {
                self.vGenre = vGenre
        }
        
        
        // Video Link to iTunes
        if let release2 = data["id"] as? JSONDictionary,
            vLinkToiTunes = release2["label"] as? String {
                self.vLinkToiTunes = vLinkToiTunes
        }
        
        
        
        // The Release Date
        if let release2 = data["im:releaseDate"] as? JSONDictionary,
            rel2 = release2["attributes"] as? JSONDictionary,
            vReleaseDte = rel2["label"] as? String {
                self.vReleaseDte = vReleaseDte
        }
        
        
    }
    
}