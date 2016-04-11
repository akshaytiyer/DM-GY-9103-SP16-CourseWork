//
//  DrawView.swift
//  TouchTracker
//
//  Created by Akshay Iyer on 3/27/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
    
    var currentLines = [NSValue:Line]()
    var finishedLine = [Line]()
    var moveRecogniser: UIPanGestureRecognizer!
    var selectedLineIndex: Int?
    {
        didSet {
            if selectedLineIndex == nil {
                let menu = UIMenuController.sharedMenuController()
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    
    
    //Current Ellipses Directory
    var currentEllipsesDirectory = [[NSValue:NSValue]]()
    var currentEllipses = [Line]()
    var finishedEllipses = [Line]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let doubleTapRecogniser = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecogniser.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapRecogniser)
        doubleTapRecogniser.delaysTouchesBegan = true
        
        let tapRecogniser = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecogniser.delaysTouchesBegan = true
        tapRecogniser.requireGestureRecognizerToFail(doubleTapRecogniser)
        addGestureRecognizer(tapRecogniser)
        
        let longPressRecogniser = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecogniser)
        
        moveRecogniser = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
        moveRecogniser.cancelsTouchesInView = false
        moveRecogniser.delegate = self
        moveRecogniser.cancelsTouchesInView = false
        addGestureRecognizer(moveRecogniser)
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func moveLine(gestureRecogniser: UIPanGestureRecognizer)
    {
        print("Recognized a Pan")
        
        //If a Line is Selected
        if let index = selectedLineIndex {
            //When a pan recogniser changes its position
            if gestureRecogniser.state == .Changed {
                //How far has the pan moved
                let translation = gestureRecogniser.translationInView(self)
                
                //Add the translation to the current beginning and end points of the line
                //Make sure there are no copy and paster typos!
                finishedLine[index].begin.x += translation.x
                finishedLine[index].begin.y += translation.y
                finishedLine[index].end.x += translation.x
                finishedLine[index].end.y += translation.y
                
                gestureRecogniser.setTranslation(CGPoint.zero, inView: self)
                
                //Redraw the screen
                setNeedsDisplay()
            }
        }
        else {
            //If no line is selected then do not do anything
        }
    }
    
    func longPress(gestureRecogniser: UIGestureRecognizer)
    {
        print("Recognised a Long Press")
        
        if gestureRecogniser.state == .Began {
            let point = gestureRecogniser.locationInView(self)
            selectedLineIndex = indexOfLineAtPoint(point)
            
            if selectedLineIndex != nil {
                currentLines.removeAll(keepCapacity: false)
            }
        }
        else if gestureRecogniser.state == .Ended {
            selectedLineIndex = nil
        }
        setNeedsDisplay()
    }
    
    func tap(gestureRecogniser: UIGestureRecognizer)
    {
        print("Recognised tap")
        let point = gestureRecogniser.locationInView(self)
        selectedLineIndex = indexOfLineAtPoint(point)
        
        //Grab a menu controller
        let menu = UIMenuController.sharedMenuController()
        
        if selectedLineIndex != nil {
            
            //Make drawView the target of menu item action messages
            becomeFirstResponder()
            
            //Create a new item "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
            menu.menuItems = [deleteItem]
            
            //Tell the menu where it should come from and then show it
            menu.setTargetRect(CGRect(x: point.x, y: point.y, width: 2, height: 2), inView: self)
            menu.setMenuVisible(true, animated: true)
        }
        else {
            //Hide the menu if no line is selected
            menu.setMenuVisible(false, animated: true)
        }
        
        setNeedsDisplay()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    func deleteLine(sender: AnyObject) {
        //Remove the selected line from the list of finished lines
        if let index = selectedLineIndex {
            finishedLine.removeAtIndex(index)
            selectedLineIndex = nil
            
            //redraw everything
            setNeedsDisplay()
        }
    }
    
    
    func doubleTap(gestureRecogniser: UIGestureRecognizer)
    {
        print("Recognise a double tap")
        selectedLineIndex = nil
        currentLines.removeAll(keepCapacity: false)
        finishedLine.removeAll(keepCapacity: false)
        setNeedsDisplay()
    }
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.blackColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.redColor() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    //Function to draw a line
    func strokeLine(line: Line)
    {
        let path = UIBezierPath()
        path.lineWidth = 10
        path.lineCapStyle = CGLineCap.Round
        path.moveToPoint(line.begin)
        path.addLineToPoint(line.end)
        path.stroke()
    }
    
    //Function to draw an ellipse
    func strokeEllipse(line: Line)
    {
        let rect = rectFromLine(line)
        
        let path = UIBezierPath(ovalInRect: rect)
        path.lineWidth = 10
        path.stroke()
    }
    
    // Helper function, return a rect from a line (end points of line are bounding box)
    func rectFromLine(line: Line) -> CGRect {
        
        let xMin = min(line.begin.x, line.end.x)
        let xMax = max(line.begin.x, line.end.x)
        let yMin = min(line.begin.y, line.end.y)
        let yMax = max(line.begin.y, line.end.y)
        let width = xMax - xMin
        let height = yMax - yMin
        
        return CGRect(x: xMin, y: yMin, width: width, height: height)
    }
    
    override func drawRect(rect: CGRect) {
        //Draw finished lines in the block
        finishedLineColor.setStroke()
        
        //Finished
        for line in finishedLine {
            // Get angle between the two points
            let deltaX = line.end.x - line.begin.x
            let deltaY = line.end.y - line.begin.y
            
            // Calculate the angle, and create a shade of grey from that angle
            let angleInDegrees = atan2(deltaY, deltaX) * 180 / CGFloat(M_PI)
            let color = UIColor(white: angleInDegrees / 360.0, alpha: 0.5)
            color.setStroke()
            
            // Draw the line
            strokeLine(line)
        }
        
        for circle in finishedEllipses {
            strokeEllipse(circle)
        }
        //Finished End
        
        //In Progress
        currentLineColor.setStroke()
        for(_, line) in currentLines {
            strokeLine(line)
        }
        
        for circle in currentEllipses {
            strokeEllipse(circle)
        }
        //In Progress End
        
        if let index = selectedLineIndex {
            UIColor.greenColor().setStroke()
            let selectedLine = finishedLine[index]
            strokeLine(selectedLine)
        }
    }
    
    func indexOfLineAtPoint(point: CGPoint) -> Int? {
        //Find a line close to the point
        for(index, line) in finishedLine.enumerate() {
            let begin = line.begin
            let end = line.end
            
            //Check a few points on the line
            for t in CGFloat(0).stride(to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                
                //If the tapped point is withing 20 points, let's return the line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
            
        }
        //if nothing is close to the tapped point, then we did not select a line
        return nil
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Lets put a log statement to see the order of events
        print(#function)
        
        if touches.count == 2 {            
            // get the touches
            let arrayOfTouches = Array(touches)
            let touchA = arrayOfTouches.first
            let touchB = arrayOfTouches.last
            
            // get the location, create a line and append currentEllipses with line
            let pointA = touchA?.locationInView(self)
            let pointB = touchB?.locationInView(self)
            let line = Line(begin: pointA!, end: pointB!)
            currentEllipses.append(line)
            
            // create NSValue for tracking touches during lifetime
            let valA = NSValue(nonretainedObject: touchA)
            let valB = NSValue(nonretainedObject: touchB)
            currentEllipsesDirectory.append([valA:valB])
        }
        else
        {
        for touch in touches {
            let location = touch.locationInView(self)
            let newLine = Line(begin: location, end: location)
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            
            if let value = valueForCurrentEllipseRefValue(key) {
                //Touch is part of a ellipse
                //Get touch that matches value
                var matchTouch: UITouch?
                for anotherTouch in touches {
                    
                    //Test for match, assign matchTouch
                    let val = NSValue(nonretainedObject: anotherTouch)
                    if val == value {
                        matchTouch = anotherTouch
                    }
                }
                // test for non nil matchtouch
                if matchTouch != nil {
                    //now have two touches that are part of an ellipse
                    if let index = indexOfTouchValue(key) {
                        
                        //Create a line using two touches
                        let begin = touch.locationInView(self)
                        let end = matchTouch?.locationInView(self)
                        let updateLine = Line(begin: begin, end: end!
                        )
                        
                        //update currentEllipses by eemoving existing and inserting updateLine
                        currentEllipses.removeAtIndex(index)
                        currentEllipses.insert(updateLine, atIndex: index)
                    }
                }
            }
            else {
                
                //Touch is part of a line
                currentLines[key]?.end = touch.locationInView(self)
            }
        }
        
        //Update Display
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //Lets put a log statement to see the order of events
        print(#function)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            
            if let index = indexOfTouchValue(key)
            {
            //Is part of ellipse, remove currentEllipseRed
            currentEllipsesDirectory.removeAtIndex(index)
            
            //Append finishedEllipses with currentEllipses
            let updateLine = currentEllipses.removeAtIndex(index)
            finishedEllipses.append(updateLine)
            }
            else
            {
            if var line = currentLines[key] {
                line.end = touch.locationInView(self)
                
                finishedLine.append(line)
                currentLines.removeValueForKey(key)
            }
        }
     }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        //Lets put a log statement to see the order of events
        print(#function)
        currentEllipses.removeAll()
        currentEllipsesDirectory.removeAll()
        currentLines.removeAll()
        
        // Update Display
        setNeedsDisplay()
    }
    
    
    func indexOfTouchValue(valRef: NSValue) -> Int? {
        
        // iterate
        for (index, value) in currentEllipsesDirectory.enumerate() {
            
            // get the key
            let key = Array(value.keys)[0] as NSValue
            
            // test if key == valRef. Exists, return index
            if key == valRef {
                return index
            }
            
            // test if value = valRef. Exists, return index
            if value[key] == valRef {
                return index
            }
        }
        
        // doesn't exists, return nil
        return nil
    }
    
    func valueForCurrentEllipseRefValue(valRef: NSValue) -> NSValue? {
        
        // test for exists
        if let index = indexOfTouchValue(valRef) {
            
            // get the key
            let dict = currentEllipsesDirectory[index]
            let key = Array(dict.keys)[0] as NSValue
            
            // test if key, then return value
            if key == valRef {
                return dict[key]! as NSValue
            }
            
            // return value
            return key
        }
        
        // doesn't exists, return nil
        return nil
    }
    
}
