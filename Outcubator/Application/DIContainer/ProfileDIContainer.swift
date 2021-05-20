//
//  ProfileDIContainer.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit

final class ProfileDIContainer {
    struct Dependencies {
        let user: User
    }
    
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeProfileUseCase() -> ProfileUseCases {
        return ProfileUseCasesPlatform()
    }
    
    func makeProfileViewModel(user: User, actions: ProfileActions) -> ProfileVM {
        return ProfileVM(user: user, actions: actions, profileUseCases: makeProfileUseCase())
    }
    
    // MARK: - VC
    public func makeProfileVC(actions: ProfileActions) -> ProfileViewController {
        return ProfileViewController.create(with: makeProfileViewModel(user: self.dependencies.user, actions: actions))
    }
}

extension ProfileDIContainer: ProfileFlowCoordinatorDependencies {}
