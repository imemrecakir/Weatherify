//
//  DatabaseManager.swift
//  Weatherify
//
//  Created by Emre Çakır on 3.03.2024.
//

import UIKit
import CoreData

enum DatabaseError: Error {
    case entityNotExist
    case savingError
    case fetchingError
    case deletingError

    var errorMessage: String {
        switch self {
        case .entityNotExist:
            return "Entity is not exist"
        case .savingError:
            return "Datas are not saved"
        case .fetchingError:
            return "Datas are not fetched"
        case .deletingError:
            return "Datas are not deleted"
        }
    }
}

class DatabaseManager {

    static let shared = DatabaseManager()
    
    private init() {}
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }

    private func saveContext(completion: @escaping (Result<Bool?, DatabaseError>) -> Void) {
        if context.hasChanges {
            do {
                try context.save()
                completion(.success(true))
            } catch {
                completion(.failure(.savingError))
            }
        }
    }
    
    func saveObject<T: NSManagedObject>(object: T, completion: @escaping (Result<Bool?, DatabaseError>) -> Void) {
        saveContext(completion: completion)
    }
    
    func fetchAllEntities<T: NSManagedObject>(object: T.Type, entity: Entity, completion: @escaping (Result<[T], DatabaseError>) -> Void) {
        let fetchRequest = NSFetchRequest<T>(entityName: entity.rawValue)
        do {
            let entities: [T] = try context.fetch(fetchRequest)
            completion(.success(entities))
        } catch {
            completion(.failure(.fetchingError))
        }
    }
    
    func fetchEntity<T: NSManagedObject>(object: T.Type, entity: Entity, predicate: NSPredicate, completion: @escaping (Result<[T], DatabaseError>) -> Void) {
        let fetchRequest = NSFetchRequest<T>(entityName: entity.rawValue)
        fetchRequest.predicate = predicate
        
        do {
            let entities = try context.fetch(fetchRequest)
            completion(.success(entities))
        } catch {
            completion(.failure(.fetchingError))
        }
    }
    
    func deleteAllEntities<T: NSManagedObject>(object: T.Type, entity: Entity, completion: @escaping (Result<Bool?, DatabaseError>) -> Void) {
        if let fetchRequest = NSFetchRequest<T>(entityName: entity.rawValue) as? NSFetchRequest<NSFetchRequestResult> {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
                completion(.success(nil))
            } catch {
                completion(.failure(.deletingError))
            }
        } else {
            completion(.failure(.deletingError))
        }
    }

    func deleteObject(object: NSManagedObject, completion: @escaping (Result<Bool?, DatabaseError>) -> Void) {
        context.delete(object)
        saveContext(completion: completion)
    }
}
