//
//  Constants.swift
//  CofeeGo
//
//  Created by Ni VoL on 23.05.2018.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation

typealias DownloadCompleate = () -> ()

let BASE_URL = "http://138.68.79.98"
let LIST_COFFEE = "/api/customers/coffee_nets/"
let LIST_COMMENTS = "/api/customers/comments/?name="

let LIST_COFFEE_URL = "\(BASE_URL)\(LIST_COFFEE)"
let COMMENTS_URL = "\(BASE_URL)\(LIST_COMMENTS)"
let USER_URL = "\(BASE_URL)/api/customers/user/"
let ORDER_URL = "\(BASE_URL)/api/customers/products/?id="
let PRODUCT_TYPES = "\(BASE_URL)/api/customers/product_types/"
let bgrvf = "http://138.68.79.98/api/customers/syrups/?id="
