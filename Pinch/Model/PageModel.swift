//
//  PageModel.swift
//  Pinch
//
//  Created by Jigar Oza on 26/08/24.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailImageName: String {
        return "thumb-" + imageName
    }
}
