//
//  RxCoordinator.swift
//  FaveAssessment
//
//  Created by Muhammad Usman on 19/05/2021.
//

import RxSwift
import Foundation

class RxCoordinator<ResultType>: NSObject {

    public typealias CoordinationResult = ResultType

    public let disposeBag = DisposeBag()
    private let identifier = UUID()
    private var childCoordinators = [UUID: Any]()

    private func store<T>(coordinator: RxCoordinator<T>) {
        childCoordinators[coordinator.identifier] = coordinator
    }

    private func release<T>(coordinator: RxCoordinator<T>) {
        childCoordinators[coordinator.identifier] = nil
    }

    @discardableResult
    open func coordinate<T>(to coordinator: RxCoordinator<T>) -> Observable<T> {
        store(coordinator: coordinator)
        return coordinator.start()
            .do(onNext: { [weak self] _ in
                self?.release(coordinator: coordinator) })
    }

    open func start() -> Observable<ResultType> {
        fatalError("start() method must be implemented")
    }
}
