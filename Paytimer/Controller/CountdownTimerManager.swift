//
//  CountdownTimerManager.swift
//  Paytimer
//
//  Created by Hu on 2025/1/17.
//

import Foundation
import Combine

class CountdownTimerManager: ObservableObject {
    @Published var currentTime = Date()
    private var cancellable: AnyCancellable?

    init() {
        cancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] time in
                self?.currentTime = time
            }
    }

    deinit {
        cancellable?.cancel()
    }
}
