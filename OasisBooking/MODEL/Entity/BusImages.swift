//
//  BusImages.swift
//  OasisBooking
//
//  Created by Anuj Garg on 21/03/20.
//  Copyright © 2020 OasisBooking. All rights reserved.
//

import Foundation

public class  BusImage : NSObject {
    var id : String?
    var object_id : String?
    var title : String?
    var name : String?
    var path : String?
    var type : String?
    var status : String?
    var created_at : String?
    var updated_at : String?
}

extension  BusImage {
    public func allBusImage (busImageList : NSArray)-> [BusImage]{
        var busImage = [BusImage]()
        for dict in busImageList {
            let busImageListTmp = BusImage()
            let id = String((dict as? NSDictionary)?.value(forKey: "id") as! Int)
            busImageListTmp.id = id
            busImageListTmp.object_id      = (dict as? NSDictionary)?.value(forKey: "object_id") as? String
            busImageListTmp.title          = (dict as? NSDictionary)?.value(forKey: "title") as? String
            busImageListTmp.name           = (dict as? NSDictionary)?.value(forKey: "name") as? String
            busImageListTmp.path           = (dict as? NSDictionary)?.value(forKey: "path") as? String
            busImageListTmp.type           = (dict as? NSDictionary)?.value(forKey: "type") as? String
            busImageListTmp.status         = (dict as? NSDictionary)?.value(forKey: "status") as? String
            busImageListTmp.created_at     = (dict as? NSDictionary)?.value(forKey: "created_at") as? String
            busImageListTmp.updated_at     = (dict as? NSDictionary)?.value(forKey: "updated_at") as? String
            busImage.append(busImageListTmp)
        }
     return busImage
    }
}
