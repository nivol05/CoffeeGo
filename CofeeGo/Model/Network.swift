//
//  Network.swift
//  CofeeGo
//
//  Created by NI Vol on 10/4/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import Alamofire

var token = ""

let BASE_URL = "http://138.68.79.98"

let REGISTER_USER = "\(BASE_URL)/api/customers/add_new_user/"
let TOKEN_URL = "\(BASE_URL)/api/customers/api-token-auth/"
let FCM_URL = "\(BASE_URL)/api/customers/fcm_devices/"
let COFFEE_NETS_URL = "\(BASE_URL)/api/customers/coffee_nets/"
let PHOTOS_URL = "\(BASE_URL)/api/customers/coffee_net_photos/"
let COFFEE_SPOTS_URL = "\(BASE_URL)/api/customers/coffee_spots/"
let COMMENTS_URL = "\(BASE_URL)/api/customers/comments/"
let FAVORITE_URL = "\(BASE_URL)/api/customers/favorites/"
let USERS_URL = "\(BASE_URL)/api/customers/user/"
let PRODUCTS_URL = "\(BASE_URL)/api/customers/products/"
let PRODUCT_TYPES_URL = "\(BASE_URL)/api/customers/product_types/"
let ORDER_URL = "\(BASE_URL)/api/customers/orders/"
let OREDER_ITEMS_URL = "\(BASE_URL)/api/customers/order_items/"
let SOCIALS_URL = "\(BASE_URL)/api/customers/coffee_net_social/"
let SYRUPS_URL = "\(BASE_URL)/api/customers/syrups/"
let SPECIES_URL = "\(BASE_URL)/api/customers/species/"
let ADDITIONALS_URL = "\(BASE_URL)/api/customers/additionals/"

var header : HTTPHeaders = [
    "Authorization": ""
]

func getToken(username : String, pass : String) -> DataRequest{
    
    let params: [String: Any] = [
        "username": username,
        "password": pass
    ]
    
    return Alamofire.request(TOKEN_URL,
                             method: .post,
                             parameters: params,
                             encoding: URLEncoding(),
                             headers: nil)
}

func registerUser(user : [String: Any]) -> DataRequest{
    return Alamofire.request(REGISTER_USER,
                             method: .post,
                             parameters: user,
                             encoding: URLEncoding(),
                             headers: header)
}

func getCoffeeNets() -> DataRequest{
    return Alamofire.request(COFFEE_NETS_URL,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func postFcmDevice(device : [String: Any]) -> DataRequest{
    return Alamofire.request(FCM_URL,
                             method: .post,
                             parameters: device,
                             encoding: URLEncoding(),
                             headers: header)
}

func getCoffeeSpots() -> DataRequest{
    return Alamofire.request(COFFEE_SPOTS_URL,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getCoffeeSpotsForNet(company : String) -> DataRequest{
    let url = "\(COFFEE_SPOTS_URL)?name=\(company)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getCommentsForNet(company : String) -> DataRequest{
    let url = "\(COMMENTS_URL)?name=\(company)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func deleteCommentById(commentId : String) -> DataRequest{
    let url = "\(COMMENTS_URL)\(commentId)/"
    return Alamofire.request(url,
                             method: .delete,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func postComment(commentRes : [String: Any]) -> DataRequest{
    return Alamofire.request(COMMENTS_URL,
                             method: .post,
                             parameters: commentRes,
                             encoding: URLEncoding(),
                             headers: header)
}

func postFavorite(favoriteRes : [String: Any]) -> DataRequest{
    return Alamofire.request(FAVORITE_URL,
                             method: .post,
                             parameters: favoriteRes,
                             encoding: URLEncoding(),
                             headers: header)
}

func deleteFavoriteById(favoriteID : String) -> DataRequest{
    let url = "\(FAVORITE_URL)\(favoriteID)/"
    return Alamofire.request(url,
                             method: .delete,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func postOrder(orderRes : [String: Any]) -> DataRequest{
    print(header)
    return Alamofire.request(ORDER_URL,
                             method: .post,
                             parameters: orderRes,
                             encoding: URLEncoding(),
                             headers: header)
    
    
}

func postOrderItem(orderItemRes : [String: Any]) -> DataRequest{
    return Alamofire.request(OREDER_ITEMS_URL,
                             method: .post,
                             parameters: orderItemRes,
                             encoding: URLEncoding(),
                             headers: header)
}

func patchOrder(orderId : String, order : [String : Any]) -> DataRequest{
    let url = "\(ORDER_URL)\(orderId)/"
    return Alamofire.request(url,
                             method: .patch,
                             parameters: order,
                             encoding: URLEncoding(),
                             headers: header)
}

func getProductsForSpot(spotId : String) -> DataRequest{
    let url = "\(PRODUCTS_URL)?id=\(spotId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getAllProductTypes() -> DataRequest{
    let url = "\(PRODUCT_TYPES_URL)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getSyrupsForSpot(spotId : String) -> DataRequest{
    let url = "\(SYRUPS_URL)?id=\(spotId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getSpeciesForSpot(spotId : String) -> DataRequest{
    let url = "\(SPECIES_URL)?id=\(spotId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getAdditionalsForSpot(spotId : String) -> DataRequest{
    let url = "\(ADDITIONALS_URL)?id=\(spotId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getAllUsers() -> DataRequest{
    let url = "\(USERS_URL)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getUser(username : String) -> DataRequest{
    let url = "\(USERS_URL)?username=\(username)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getFavoritesForUser(userId : String) -> DataRequest{
    let url = "\(FAVORITE_URL)?id=\(userId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getPhotosForNet(companyId : String) -> DataRequest{
    let url = "\(PHOTOS_URL)?id=\(companyId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getOrdersForUser(userId : String) -> DataRequest{
    let url = "\(ORDER_URL)?id=\(userId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getOneOrder(orderId : String) -> DataRequest{
    let url = "\(ORDER_URL)\(orderId)/"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getOrderItemsForUser(userId : String) -> DataRequest{
    let url = "\(OREDER_ITEMS_URL)?id=\(userId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getUserCommentForNet(userId : String, companyId : String) -> DataRequest{
    let url = "\(COMMENTS_URL)?check_user_id=\(userId)&check_coffee_net_id=\(companyId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getActiveUserOrders(userId : String) -> DataRequest{
    let url = "\(ORDER_URL)?waiting_for_client_id=\(userId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getCompanySocials(companyId : String) -> DataRequest{
    let url = "\(SOCIALS_URL)?coffee_net_id=\(companyId)"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}

func getOneCoffeeSpot(spotId : String) -> DataRequest{
    let url = "\(COFFEE_SPOTS_URL)\(spotId)/"
    return Alamofire.request(url,
                             method: .get,
                             parameters: nil,
                             encoding: URLEncoding(),
                             headers: header)
}
