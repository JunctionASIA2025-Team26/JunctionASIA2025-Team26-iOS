//
//  BaseModel.swift
//  SyncTank-iOS
//
//  Created by keonheehan on 9/6/25.
//

struct BaseModel<T: Decodable>: Decodable {
    let code: Int
    let detail: String
    let data: T
}
