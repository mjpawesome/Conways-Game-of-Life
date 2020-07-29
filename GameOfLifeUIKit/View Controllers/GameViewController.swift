//
//  GameViewController.swift
//  GameOfLifeUIKit
//
//  Created by Mark Poggi on 7/27/20.
//  Copyright © 2020 Mark Poggi. All rights reserved.
//

import UIKit
import AVFoundation

class GameViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var gliderButton: UIButton!
    @IBOutlet weak var blinkerButton: UIButton!
    @IBOutlet weak var shipButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    @IBOutlet weak var genLabel: UILabel!

    // MARK: - Properties
    var gameGrid: GameGrid!
    var isPlaying: Bool = false
    lazy var buttons: [UIButton] = [self.randomButton, self.gliderButton, self.blinkerButton, self.shipButton, self.resetButton]

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        gameGrid = GameGrid(width: self.view.frame.width, height: self.view.frame.height, view: self.view)
        self.navigationItem.title = "Conway's Game of Life"
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: .genChanged, object: nil)
           }

    @objc func updateLabel(_ notification: NSNotification ) {
        if let dict = notification.userInfo {
            if let id = dict["genChanged"] as? Int {
                self.genLabel.text = "\(id) Generations"
            }
        }
    }

    // MARK: - Methods
    func toggleButtonAccess() {
        for button in self.buttons {
            button.isEnabled.toggle()
          }
    }
    
    // MARK: - Actions
    @IBAction func playButton(_ sender: UIButton!) {
        if isPlaying == false {
            sender.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            isPlaying = true
            AudioServicesPlaySystemSound(1104)
            toggleButtonAccess()
            gameGrid.playLoop(play: true)
        } else {
            sender.setImage(UIImage(systemName: "play.fill"), for: .normal)
            isPlaying = false
            AudioServicesPlaySystemSound(1104)
            toggleButtonAccess()
            gameGrid.playLoop(play: false)
        }
    }
    
    @IBAction func AboutButton(_ sender: Any) {
        self.performSegue(withIdentifier: "aboutSegue", sender: self)
    }
    
    @IBAction func RandomButton(_ sender: Any) {
        AudioServicesPlaySystemSound(1104)
        gameGrid.randomBoard()
        
    }
    
    @IBAction func GliderButton(_ sender: Any) {
        AudioServicesPlaySystemSound(1104)
        gameGrid.gliderShape()  
    }
    
    @IBAction func BlinkerButton(_ sender: Any) {
        AudioServicesPlaySystemSound(1104)
        gameGrid.blinkerShape()
    }
    
    @IBAction func ToadButton(_ sender: Any) {
        AudioServicesPlaySystemSound(1104)
        gameGrid.spaceShipShape()
    }
    
    @IBAction func ResetButton(_ sender: Any) {
        AudioServicesPlaySystemSound(1104)
        gameGrid.resetGame()
    }
}
