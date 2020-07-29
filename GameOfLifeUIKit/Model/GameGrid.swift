//
//  GameGrid.swift
//  GameOfLifeUIKit
//
//  Created by Mark Poggi on 7/27/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit

class GameGrid {

    // MARK: - Properties
    var gameView = GameViewController()
    var cellArray = [[Cell]]()
    var updatedCellArray = [[Cell]]()
    var cell: Cell!
    var width: CGFloat!
    var height: CGFloat!
    var view: UIView!
    var animationTimer: Timer = Timer()
    var gridSize: Int = 25
    var gameGeneration = 0   {
        didSet {
            NotificationCenter.default.post(name: .genChanged, object: nil, userInfo: ["genChanged": gameGeneration])
        }
    }

    init(width: CGFloat, height: CGFloat, view: UIView) {
        self.width = width
        self.height = height
        self.view = view
        //        self.cellWidth = width / CGFloat(gridSize)
        self.cellArray = buildGrid(width: width, height: height, view: view)
        self.updatedCellArray = buildGrid(width: width, height: height, view: view, isNext: true)
    }

    // MARK: - Methods - Game Logic
    func countCellNeighbors(x: Int, y: Int) -> Int {
        var count = 0

        for i in x-1...x+1 {
            for j in y-1...y+1 {
                if (i == x && j == y) || (i >= gridSize) || (j >= gridSize) || ( i < 0 ) || (j < 0) {
                    continue
                }
                if cellArray[i][j].isAlive {
                    count += 1}
            }
        }
        return count
    }
    
    func calcNextGenGrid(){
        resetGrid(grid: updatedCellArray)

        for x in 0...gridSize-1 {
            for y in 0...gridSize-1 {
                let state = cellArray[x][y].isAlive
                let neighbors = countCellNeighbors(x: x, y: y)

                if state == true {
                    if neighbors == 2 || neighbors == 3 {
                        updatedCellArray[x][y].makeCellAlive()
                    } else {
                        updatedCellArray[x][y].makeCellDead()
                    }
                } else {
                    if neighbors == 3 {
                        updatedCellArray[x][y].makeCellAlive()
                    }
                }
            }
        }
        updateCellState()
    }

    func updateCellState() {
        for x in 0...gridSize-1 {
            for y in 0...gridSize-1 {
                updatedCellArray[x][y].isAlive ? cellArray[x][y].makeCellAlive() : cellArray[x][y].makeCellDead()
            }
        }
    }

    func buildGrid(width: CGFloat, height: CGFloat, view: UIView, isNext: Bool = false) -> [[Cell]] {
        var column = [Cell]()
        var grid = [[Cell]]()

        let width = view.frame.width / CGFloat(gridSize)

        for j in 0...gridSize-1 {
            for i in 0...gridSize-1 {
                let cell = Cell(
                    frame:
                    CGRect(
                        x: CGFloat(i) * width,
                        y: CGFloat(j) * width + 100,
                        width: width,
                        height: width),
                    state: false)

                if !isNext { view.addSubview(cell) }

                column.append(cell)
            }
            grid.append(column)
            column.removeAll()
        }
        return grid
    }

    // MARK: - Reset Game
    func resetGrid(grid: [[Cell]]) {
        for x in 0...gridSize-1 {
            for y in 0...gridSize-1 {
                grid[x][y].makeCellDead()
            }
        }
    }

    func resetGame() {
        animationTimer.invalidate()
        gameGeneration = 0
        resetGrid(grid: cellArray)
        resetGrid(grid: updatedCellArray)
    }

    // MARK: - Methods Preset Shapes
    func blinkerShape() {
        let xrandom = Int.random(in: -10...10)
        let yrandom = Int.random(in: -10...10)
        updatedCellArray[13 + xrandom][13 + yrandom].makeCellAlive()
        updatedCellArray[13 + xrandom][14 + yrandom].makeCellAlive()
        updatedCellArray[13 + xrandom][15 + yrandom].makeCellAlive()
        updateCellState()
    }

    func spaceShipShape() {
        let xrandom = Int.random(in: -8...8)
        let yrandom = Int.random(in: -8...8)
        updatedCellArray[12 + xrandom][13 + yrandom].makeCellAlive()
        updatedCellArray[12 + xrandom][14 + yrandom].makeCellAlive()
        updatedCellArray[13 + xrandom][12 + yrandom].makeCellAlive()
        updatedCellArray[13 + xrandom][13 + yrandom].makeCellAlive()
        updatedCellArray[13 + xrandom][14 + yrandom].makeCellAlive()
        updatedCellArray[13 + xrandom][15 + yrandom].makeCellAlive()
        updatedCellArray[14 + xrandom][15 + yrandom].makeCellAlive()
        updatedCellArray[14 + xrandom][16 + yrandom].makeCellAlive()
        updatedCellArray[15 + xrandom][15 + yrandom].makeCellAlive()
        updatedCellArray[15 + xrandom][14 + yrandom].makeCellAlive()
        updatedCellArray[14 + xrandom][12 + yrandom].makeCellAlive()
        updatedCellArray[14 + xrandom][13 + yrandom].makeCellAlive()

        updateCellState()
    }

    func gliderShape() {
        let xrandom = Int.random(in: -7...8)
        let yrandom = Int.random(in: -7...8)
        updatedCellArray[10 + xrandom][13 + yrandom].makeCellAlive()
        updatedCellArray[10 + xrandom][14 + yrandom].makeCellAlive()
        updatedCellArray[10 + xrandom][15 + yrandom].makeCellAlive()
        updatedCellArray[9 + xrandom][15 + yrandom].makeCellAlive()
        updatedCellArray[8 + xrandom][14 + yrandom].makeCellAlive()

        updateCellState()
    }

    func randomBoard() {
        resetGame()
        for y in 0..<gridSize {
            for x in 0..<gridSize {
                let random = Int.random(in: 0..<4)
                random == 0 ? updatedCellArray[x][y].makeCellAlive() : updatedCellArray[x][y].makeCellDead()
            }
        }
        updateCellState()
    }
    
    // MARK: - Animation Timer Loop
    func playLoop(play: Bool) {
        if play == true {
            animationTimer.invalidate()
            animationTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(0.1), repeats: true, block: { (timer) in
                self.calcNextGenGrid()
                self.gameGeneration += 1
                print(self.gameGeneration)
            })
        } else {
            animationTimer.invalidate()
        }
    }
}

extension Notification.Name {
    static let genChanged = Notification.Name("genChanged")
}
