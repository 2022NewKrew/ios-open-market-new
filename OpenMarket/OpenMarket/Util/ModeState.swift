//
//  ModeProtocol.swift
//  OpenMarket
//
//  Created by kakao on 2022/02/09.
//

import Foundation

protocol ModeState {
    func setupProductInfo()
    func setNavigationTitle()
    func doneAction(input: ProductInput)
    func imageCount() -> Int
    func didSelectItem(index: Int)
}
