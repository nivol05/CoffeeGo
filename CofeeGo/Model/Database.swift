//
//  Database.swift
//  CofeeGo
//
//  Created by NI Vol on 9/27/18.
//  Copyright © 2018 Ni VoL. All rights reserved.
//

import Foundation
import SQLite

class Database{
    
    var database : Connection!
    
    let PRODUCT_TABLE = Table("products")
    let USER_TABLE = Table("user")
    
    let NAME_PRODUCT = Expression<String>("name")
    let IMG_PRODUCT = Expression<String>("img")
    let ID_PRODUCT = Expression<Int>("id")
    let COFFEE_SPOT_PRODUCT = Expression<Int>("coffee_spot")
    let PRODUCT_TYPE_PRODUCT = Expression<Int>("product_type")
    let PRICE_PRODUCT = Expression<Int>("price")
    let L_CUP_PRODUCT = Expression<Int>("l_cup")
    let M_CUP_PRODUCT = Expression<Int>("m_cup")
    let B_CUP_PRODUCT = Expression<Int>("b_cup")
    let ACTIVE_PRODUCT = Expression<Int>("active")
    
    let USER_ID = Expression<Int>("id")
    let USER_FIRST_NAME = Expression<String>("first_name")
    let USER_PASSWORD = Expression<String>("password")
    let USER_USERNAME = Expression<String>("username")
    
    init() {
        do{
            
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("coffeeGo").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
        
        createTableProducts()
    }
    
    func createTableProducts(){
        
        let createTable = self.PRODUCT_TABLE.create{ (table) in
            table.column(self.ID_PRODUCT, primaryKey: true)
            table.column(self.NAME_PRODUCT)
            table.column(self.COFFEE_SPOT_PRODUCT)
            table.column(self.PRODUCT_TYPE_PRODUCT)
            table.column(self.IMG_PRODUCT)
            table.column(self.PRICE_PRODUCT)
            table.column(self.L_CUP_PRODUCT)
            table.column(self.M_CUP_PRODUCT)
            table.column(self.B_CUP_PRODUCT)
            table.column(self.ACTIVE_PRODUCT)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
        
    }
    
    func createTableUser(){
        let createTable = self.USER_TABLE.create{ (table) in
            table.column(self.USER_ID, primaryKey: true)
            table.column(self.USER_FIRST_NAME)
            table.column(self.USER_USERNAME)
            table.column(self.USER_PASSWORD)
        }
        
        do{
            try self.database.run(createTable)
            print("Created table")
        } catch{
            print(error)
            print("NOT CREATED")
        }
    }
    
    func setUser(user: ElementUser){
        let insertUser = self.USER_TABLE.insert(
            self.USER_ID <- user.id,
            self.USER_FIRST_NAME <- user.first_name,
            self.USER_USERNAME <- user.username,
            self.USER_PASSWORD <- user.password
        )
        
        do{
            try self.database.run(insertUser)
            print("Inserted")
        } catch{
            print(error)
            print("Not inserted")
        }
    }
    
    func getUser() -> ElementUser{
        var ret : ElementUser!
        let select = USER_TABLE.select([
            USER_ID,
            USER_FIRST_NAME,
            USER_USERNAME,
            USER_PASSWORD
            ])
        do{
            let users = try self.database.prepare(select)
            for user in users{
                var elem = [String : Any]()
                elem["id"] = user[self.USER_ID]
                elem["first_name"] = user[self.USER_FIRST_NAME]
                elem["username"] = user[self.USER_USERNAME]
                elem["password"] = user[self.USER_PASSWORD]
    
                ret = ElementUser(mas: elem)
            }
        } catch{
            print(error)
        }
        
        return ret
    }
    
    func delUser(){
        let del = self.USER_TABLE.delete()
        do {
            try self.database.run(del)
        } catch {
            print(error)
        }
    }
    
    func setProducts(products : [[String : Any]]){
        
        for x in products{
            
            let insetrProduct = self.PRODUCT_TABLE.insert(
                self.ID_PRODUCT <- x["id"] as! Int,
                self.NAME_PRODUCT <- x["name"] as! String,
                self.COFFEE_SPOT_PRODUCT <- x["coffee_spot"] as! Int,
                self.PRODUCT_TYPE_PRODUCT <- x["product_type"] as! Int,
                self.IMG_PRODUCT <- x["img"] as! String,
                self.PRICE_PRODUCT <- x["price"] as! Int,
                self.L_CUP_PRODUCT <- x["l_cup"] as! Int,
                self.M_CUP_PRODUCT <- x["m_cup"] as! Int,
                self.B_CUP_PRODUCT <- x["b_cup"] as! Int,
                self.ACTIVE_PRODUCT <- x["active"] as! Int
            )
            
            do{
                try self.database.run(insetrProduct)
                print("Inserted")
            } catch{
                print(error)
                print("Not inserted")
            }
        }
    }
    
    func getProducts(type : Int) -> [[String : Any]]{
        
        var manu : [[String : Any]] = [[String : Any]]()
        
        let filter = PRODUCT_TABLE.filter(self.PRODUCT_TYPE_PRODUCT == type)
        do{
            let products = try self.database.prepare(filter)
            for product in products{
                var manuElem = [String : Any]()
                
                manuElem["id"] = product[self.ID_PRODUCT]
                manuElem["name"] = product[self.NAME_PRODUCT]
                manuElem["coffee_spot"] = product[self.COFFEE_SPOT_PRODUCT]
                manuElem["product_type"] = product[self.PRODUCT_TYPE_PRODUCT]
                manuElem["img"] = product[self.IMG_PRODUCT]
                manuElem["price"] = product[self.PRICE_PRODUCT]
                manuElem["l_cup"] = product[self.L_CUP_PRODUCT]
                manuElem["m_cup"] = product[self.M_CUP_PRODUCT]
                manuElem["b_cup"] = product[self.B_CUP_PRODUCT]
                manuElem["active"] = product[self.ACTIVE_PRODUCT] == 1
                
                manu.append(manuElem)
            }
        } catch{
            print(error)
        }
        
        return manu
    }
    
    func deleteProduct(){
        let producrt = self.PRODUCT_TABLE.delete()
        do {
            try self.database.run(producrt)
        } catch {
            print(error)
        }
    }
    
}


