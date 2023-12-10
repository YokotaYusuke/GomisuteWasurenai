//
//  DustsType.swift
//  GomisuteWasurenai
//
//  Created by yusukeyokota on 2023/12/08.
//

struct DustsData {
    private(set) public var dust_name : String
    private(set) public var dust_type : String
    private(set) public var imageName : String
    
    init(dust_name: String, dust_type: String = "", imageName: String) {
        self.dust_name = dust_name
        self.dust_type = dust_type
        self.imageName = imageName
    }
}
