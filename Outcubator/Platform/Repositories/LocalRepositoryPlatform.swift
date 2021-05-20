//
//  LocalRepository.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

protocol LocalRepository {
    associatedtype T
    func save(entity: T) -> Observable<T?>
    func get() -> Observable<T?>
    func delete() -> Observable<Void>
}

final class DefaultLocalRepository<T:Codable>: LocalRepository {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }
    
    func save(entity: T) -> Observable<T?> {
        return Observable.create {observer in
            let encoder = JSONEncoder()
            do {
                let encoded = try encoder.encode(entity)
                self.defaults.set(encoded, forKey: String(describing: T.self))
                self.defaults.synchronize()
                observer.onNext(entity)
                observer.onCompleted()
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
    
    func get() -> Observable<T?> {
        return UserDefaults.standard.rx
            .observe(Data.self, String(describing: T.self))
            .observe(on: MainScheduler.instance)
            .map { data -> T? in
                guard let data = data else { return nil }
                print(data)
                let decoder = JSONDecoder()
                let obj = try? decoder.decode(T.self, from: data)
                return obj
            }
    }
    
    func delete() -> Observable<Void> {
        return Observable.create {observer in
            self.defaults.removeObject(forKey: String(describing: T.self))
            self.defaults.synchronize()
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
}
