//
//  ViewController.swift
//  Platzzel
//
//  Created by Jonathan Macalupú on 5/03/18.
//  Copyright © 2018 Jonathan Macalupú. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contadorLabel: UILabel!
    @IBOutlet weak var board: UIView!
    var tileWidth : CGFloat = 0
    var tileCenterX : CGFloat = 0
    var tileCenterY : CGFloat = 0
    var contador : Int = 0
    
    var tileArray : NSMutableArray = []
    var tileCenterArray : NSMutableArray = []
    var tileEmptyCenter : CGPoint = CGPoint(x: 0, y: 0)
    
        
    func contadorMasUno(contador: Int) {
        self.contador = contador
        contadorLabel.text = "Movimiento \(self.contador)"
    }
    
    
    @IBAction func btnRandom(_ sender: Any) {
        randomTiles()
     contadorMasUno(contador: 0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        makeTiles()
        randomTiles()
    }
    
    func makeTiles() {
        self.tileArray = []
        self.tileCenterArray = []
        let boardWidth = self.board.frame.width
        self.tileWidth = boardWidth / 4
        self.tileCenterY = self.tileWidth / 2
        var tileNumber : Int = 1
        
        for _ in 0..<4 {
            self.tileCenterX = self.tileWidth / 2
            
            for _ in 0..<4 {
                let tileFrame : CGRect = CGRect(x: 0, y: 0, width: self.tileWidth - 2 , height: self.tileWidth - 2)
                let tile : CustomLabel = CustomLabel(frame: tileFrame)
                var currentCenter : CGPoint = CGPoint(x: self.tileCenterX, y: self.tileCenterY)
                tile.center = currentCenter
                
                tile.originCenter = currentCenter
                
//                tile.text = String(tileNumber)
                if tileNumber <= 16 {
                    tile.backgroundColor = UIColor(patternImage: UIImage(named: "\(tileNumber).jpg")!)
                } else {
                  tile.backgroundColor = UIColor.gray
                }
                tile.textAlignment = NSTextAlignment.center
                tile.isUserInteractionEnabled = true
                self.tileCenterArray.add(currentCenter) //agrega al tileCenterArray la posición del currentCenter
                
//                tile.backgroundColor = UIColor.red
                self.board.addSubview(tile)
                tileNumber = tileNumber + 1
                
                self.tileArray.add(tile) //agrega al tileArray cada vista
                self.tileCenterX = self.tileCenterX + self.tileWidth
            }
            
            self.tileCenterY = self.tileCenterY + self.tileWidth
            
        }

        let lastTile : CustomLabel = self.tileArray.lastObject as! CustomLabel
        lastTile.removeFromSuperview() //eliminamos el último label de la vista
        self.tileArray.removeObject(at: 15) //eliminamos el último label del array
        

    }
    
    func randomTiles() {
        let tempTileCenterArray : NSMutableArray = self.tileCenterArray.mutableCopy() as! NSMutableArray
        for anyTile in self.tileArray {
            let randomIndex : Int = Int(arc4random()) % tempTileCenterArray.count
            let randomCenter : CGPoint = tempTileCenterArray[randomIndex] as! CGPoint
            (anyTile as! CustomLabel).center = randomCenter
            
            tempTileCenterArray.removeObject(at: randomIndex) //Elimina el objeto colocado, haciendo que no se repita nuevamente.
        }
        
        self.tileEmptyCenter = tempTileCenterArray[0] as! CGPoint
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentTouch : UITouch = touches.first!
        if (self.tileArray.contains(currentTouch.view as Any)) {
            //currentTouch.view?.alpha = 0
            let touchLabel : CustomLabel = currentTouch.view as! CustomLabel
            let xDif: CGFloat = touchLabel.center.x - self.tileEmptyCenter.x
            let yDif: CGFloat = touchLabel.center.y - self.tileEmptyCenter.y
            let distance : CGFloat = sqrt(pow(xDif,2) + pow(yDif,2))
            
            if distance == self.tileWidth {
                let tempCenter : CGPoint = touchLabel.center
                UIView.beginAnimations(nil, context: nil) //inicio de la animacion
                UIView.setAnimationDuration(0.2) //duracion de la animacion
                touchLabel.center = self.tileEmptyCenter
                
                UIView.commitAnimations() //fin de la animación
                self.tileEmptyCenter = tempCenter
                
                contadorMasUno(contador: self.contador + 1)
            }
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

class CustomLabel : UILabel {
    var originCenter : CGPoint = CGPoint(x: 0, y: 0)
}
