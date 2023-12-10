//
//  dusts.swift
//  GomisuteWasurenai
//
//  Created by yusukeyokota on 2023/12/08.
//

import RealmSwift

class Dusts: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var dust_name: String = ""
    @Persisted var dust_type: String = ""
    @Persisted var dust_image: String = ""
    @Persisted var dust_create: String = ""
}
