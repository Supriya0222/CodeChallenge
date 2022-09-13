//
//  DBManager.swift
//  CodeChallenge
//
//  Created by Supriya Rajkoomar on 13/09/2022.
//

import Foundation
import CoreData

class DBManager: NSObject {
    
    public var databaseName: String = "ItemModel"
    public static let shared : DBManager = DBManager(WithDatabaseName: "ItemModel")
    
    init(WithDatabaseName name: String){
        super.init()
        self.databaseName = name
        
    }
    
    lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer.init(name: self.databaseName)
        
        container.loadPersistentStores(completionHandler: { (storeDes, error) in
            if let error = error as? NSError{
                print(error)
            }
        })
        return container

    }()
    
    
    lazy var mainContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    
    public func findAllEntities(name: String?, context: NSManagedObjectContext?) -> [NSManagedObject]{
        if let name = name, let context = context{
            let entityRequest = NSFetchRequest<NSFetchRequestResult>(entityName: name)
            
            do {
                if let fetchedEntities = try context.fetch(entityRequest) as? [NSManagedObject]{
                    return fetchedEntities
                }
            } catch {
                return []
            }
        }
        
        return []
    }
    
    
    func fetchAllItems() -> [Item]{
        if let items = findAllEntities(name: "Item", context: mainContext) as? [Item]{
            return items
        }
        
        return []
    }
    
    
    func getItemWith(Title title: String) -> Item?{
        if let item = fetchAllItems().filter({ (anItem) -> Bool in
            if let anItemTitle = anItem.title , anItemTitle == title {
                return true
            }
            return false
        }).last{
            return item
        }else{
            return NSEntityDescription.insertNewObject(forEntityName: "Item", into: mainContext) as? Item
        }
    
    }
    
    
    func parseResponse(Reponse response :[[String:AnyObject]]) -> [Item]{
        var allItems :[Item] = []
        
        response.forEach { (aresponse) in
            if let parseItem = parseDictionary(WithItemDictionary: aresponse){
                allItems.append(parseItem)
            }
        }
        return allItems
    }
    
    
    func parseDictionary(WithItemDictionary itemDictionary :[String:AnyObject]) -> Item?{
        
        if let data = itemDictionary["data"] as? [AnyObject]{
            var cachedItem: Item?
            
            data.forEach { newData in
                
                if let nasaId = newData["nasa_id"] as? String{
                    cachedItem = getItemWith(Title: nasaId)
                    
                    if let title = newData["title"] as? String {
                        cachedItem?.title = title
                    }
                    
                    if let photographer = newData["photographer"] as? String {
                        cachedItem?.photographer = photographer
                    }
                    if let desc = newData["description"] as? String {
                        cachedItem?.descriptionDisplay = desc
                    }
                    if let dateCreated = newData["dateCreated"] as? String {
                        cachedItem?.dateCreated = dateCreated
                    }
                }
                
                if let links = itemDictionary["links"] as? [AnyObject]{
                    links.forEach { linkDetail in
                        if let href = linkDetail["href"] as? String{
                            cachedItem?.imageUrl = href
                        }
                    }
                }
                
            }
            
            return cachedItem

        }
        
        return nil

    }

}


