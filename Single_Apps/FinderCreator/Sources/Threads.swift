//
//  Threads.swift
//  FinderCreator
//
//  Created by Dylan Elliott on 5/4/20.
//

import Foundation

func onMain(work: @escaping () -> Void) {
    DispatchQueue.main.async {
        work()
    }
}

func onBG(work: @escaping () -> Void) {
    DispatchQueue.global().async {
        work()
    }
}
