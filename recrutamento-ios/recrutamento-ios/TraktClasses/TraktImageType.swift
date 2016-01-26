//
//  TraktImageType.swift
//  movile-test
//
//  Created by Arilson Carmo on 1/25/16.
//  Copyright © 2016 Arilson Carmo. All rights reserved.
//

import Foundation

/*
*  Enum all image types returned from Trakt API.
*/
public enum TraktImageType:String {
    case Banner = "banner"
    , ClearArt = "clearart"
    , FanArt = "fanart"
    , HeadShot = "headshot"
    , Logo = "logo"
    , Poster = "poster"
    , Thumb = "thumb"
    , Avatar = "avatar"
    , Screenshot = "screenshot"
}
