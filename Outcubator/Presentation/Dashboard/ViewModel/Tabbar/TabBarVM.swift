//
//  TabBarVM.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import Foundation

protocol TabBarVMInput {
    func showWallet()
    func showScan()
    func showProfile()
}

public class TabBarVM: TabBarVMInput {
    let actions: TabBarListActions
    let user: User
    public init(actions: TabBarListActions, user: User) {
        self.actions = actions
        self.user = user
    }
    
    func showWallet() {
        actions.showWallet(user)
    }
    
    func showScan() {
        actions.showScan()
    }
    
    func showProfile() {
        actions.showProfile()
    }
}


public struct TabBarListActions {
    var showWallet: (User) -> Void
    var showScan: () -> Void
    var showProfile: () -> Void
}
