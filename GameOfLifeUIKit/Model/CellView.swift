//
//  CellView.swift
//  GameOfLifeUIKit
//
//  Created by Mark Poggi on 7/27/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit

class Cell: UIView {

    static let cellChangedColor = Notification.Name("cellChangedColor")

    var isAlive: Bool = false

    init(frame: CGRect, state: Bool = false) {
        super.init(frame: frame)
        setUpCellView()
        self.isAlive = state
        NotificationCenter.default.addObserver(self, selector: #selector(colorDidChange), name: Cell.cellChangedColor, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpCellView() {
        self.backgroundColor = .white
    }

    func makeCellDead() {
        self.isAlive = false
        self.backgroundColor = .white
    }

    func makeCellAlive() {
        self.isAlive = true
        self.backgroundColor = .blue
    }

    @objc func colorDidChange() {
        if isAlive == true { backgroundColor = .white }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isAlive == false {
            makeCellAlive()
        } else {
            makeCellDead()
        }
    }
}
