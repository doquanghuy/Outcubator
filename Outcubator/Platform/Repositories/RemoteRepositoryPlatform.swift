//
//  RemoteRepository.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import RxSwift
import RealmSwift
import RxRealm

protocol RemoteRepository {
    associatedtype T
    func queryAll() -> Observable<[T]>
    func query(with predicate: NSPredicate,
               sortDescriptors: [NSSortDescriptor]) -> Observable<[T]>
    func save(entity: T) -> Observable<T>
    func delete(entity: T) -> Observable<Void>
}


final class DefaultRemoteRepository<T:RealmRepresentable>: RemoteRepository where T == T.RealmType.DomainType, T.RealmType: Object {
    private let configuration: Realm.Configuration
    private let scheduler: RunLoopThreadScheduler

    private var realm: Realm {
        return try! Realm(configuration: self.configuration)
    }

    init(configuration: Realm.Configuration) {
        self.configuration = configuration
        let name = "RealmPlatform.Repository"
        self.scheduler = RunLoopThreadScheduler(threadName: name)
    }

    func queryAll() -> Observable<[T]> {
        return Observable.deferred {
                    let realm = self.realm
                    let objects = realm.objects(T.RealmType.self)

                    return Observable.array(from: objects)
                            .mapToDomain()
                }
                .subscribe(on: scheduler)
    }

    func query(with predicate: NSPredicate,
                        sortDescriptors: [NSSortDescriptor] = []) -> Observable<[T]> {
        return Observable.create {observer in
            let realm = self.realm
            let objects = realm.objects(T.RealmType.self)
                .filter(predicate)
                .sorted(by: sortDescriptors.map(SortDescriptor.init))
            observer.onNext(objects.mapToDomain())
            observer.onCompleted()
            return Disposables.create()
        }
        .subscribe(on: scheduler)
    }

    func save(entity: T) -> Observable<T> {
        return Observable.create { observer in
            let realm = self.realm
            do {
                try realm.write {
                    realm.add(entity.asRealm())
                    observer.onNext(entity)
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }
        .subscribe(on: scheduler)
    }

    func delete(entity: T) -> Observable<Void> {
        return Observable.create { observer in
            let realm = self.realm
            do {
                try realm.write {
                    realm.delete(entity.asRealm())
                    observer.onNext(())
                    observer.onCompleted()
                }
            } catch {
                observer.onError(error)
            }
            return Disposables.create()
        }.subscribe(on: scheduler)
    }
}
