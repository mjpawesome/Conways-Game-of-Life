//
//  CellView.swift
//  GameOfLifeUIKit
//
//  Created by Mark Poggi on 7/27/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit
import AVFoundation

class Cell: UIView {

    // MARK: - Properties
    var isAlive: Bool = false
    var x: Int = 0
    var y: Int = 0
    let borderColor = UIColor.lightGray.cgColor
    let backgroundCellColor = UIColor.black

    init(frame: CGRect, state: Bool = false) {
        super.init(frame: frame)
        setUpCellView()
        self.isAlive = state
    }

    convenience init(frame: CGRect, x: Int, y: Int) {
        self.init(frame: frame)
        self.x = x
        self.y = y
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods
    func setUpCellView() {
        self.backgroundColor = backgroundCellColor
        self.layer.borderWidth = 0.2
        self.layer.borderColor = borderColor
    }

    func makeCellDead() {
        self.isAlive = false
        self.backgroundColor = backgroundCellColor
    }

    func makeCellAlive() {
        self.isAlive = true
        self.backgroundColor = randomColor()
    }

    func randomColor() -> UIColor {
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }

    func cellSound() {
        AudioServicesPlaySystemSound(1104)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isAlive == false {
            cellSound()
            makeCellAlive()
        } else {
            cellSound()
            makeCellDead()
        }
    }
}
