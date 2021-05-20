//
//  ProfileViewModel.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import Foundation
import RxSwift

fileprivate enum ProfileCells: Int {
    case notifications, personalInformations, security, support, term, logout
    
    static var allCases: [ProfileCells] {
        return [.notifications, .personalInformations, .security, .support, .term, .logout]
    }
    
    var asModel: ProfileModel {
        switch self {
        case .notifications:
            return ProfileModel(text: Constants.Profile.notifications, icon: Images.icNotification)
        case .personalInformations:
            return ProfileModel(text: Constants.Profile.personalInfo, icon: Images.icPersonal)
        case .security:
            return ProfileModel(text: Constants.Profile.security, icon: Images.icSecurity)
        case .support:
            return ProfileModel(text: Constants.Profile.support, icon: Images.icHelpSupport)
        case .term:
            return ProfileModel(text: Constants.Profile.term, icon: Images.icTermsOfUse)
        case .logout:
            return ProfileModel(text: Constants.Profile.logout, icon: Images.icExit)
        }
    }
}

protocol ProfileVMInput {
    var didLoad: Observable<Void> {get}
    var didClickOnIndex: Observable<IndexPath> {get}
}

protocol ProfileVMOutput {
    var name: Observable<String> {get}
    var email: Observable<String> {get}
    var didLogOut: Observable<Void> {get}
    var sections: Observable<[ProfileSectionModel]> {get}
}

protocol ProfileVMInterface {
    func transform(input: ProfileVMInput) -> ProfileVMOutput
}

final class ProfileVM: ProfileVMInterface {
    struct Input: ProfileVMInput {
        var didLoad: Observable<Void>
        var didClickOnIndex: Observable<IndexPath>
    }
    
    struct Output: ProfileVMOutput {
        var name: Observable<String>
        var email: Observable<String>
        var didLogOut: Observable<Void>
        var sections: Observable<[ProfileSectionModel]>
    }
    
    private let user: User
    private let profileUseCases: ProfileUseCases
    private let actions: ProfileActions
    
    init(user: User, actions: ProfileActions, profileUseCases: ProfileUseCases) {
        self.user = user
        self.profileUseCases = profileUseCases
        self.actions = actions
    }
    
    func transform(input: ProfileVMInput) -> ProfileVMOutput {
        let sections = input.didLoad
            .flatMap({Observable.just([ProfileSectionModel(header: "", items: ProfileCells.allCases.map{$0.asModel})])})
            .share()
        
        let name = input.didLoad
            .flatMap({Observable.just(self.user)})
            .map({"\($0.fullName)"})
        let email = input.didLoad
            .flatMap({Observable.just(self.user)})
            .map({"\($0.email)"})
        let showLogoutAlert = input.didClickOnIndex
            .map({ProfileCells(rawValue: $0.row)})
            .filter({$0 == .logout})
            .flatMap({_ in self.showLogoutAlert()})
        
        let didLogOut = showLogoutAlert
            .filter({$0 == 1})
            .flatMap({_ in self.showLogin()})
        return Output(name: name, email: email, didLogOut: didLogOut, sections: sections)
    }
    
    private func showLogin() -> Observable<Void> {
        return self.actions.showLogin()
    }
    
    private func showLogoutAlert() -> Observable<Int> {
        return self.actions.showLogoutAlert()
    }
}

public struct ProfileActions {
    let showLogin: () -> Observable<Void>
    let showLogoutAlert: () -> Observable<Int>
}
