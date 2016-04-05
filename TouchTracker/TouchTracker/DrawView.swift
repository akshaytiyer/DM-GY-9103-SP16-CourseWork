//
//  DrawView.swift
//  TouchTracker
//
//  Created by Akshay Iyer on 3/27/16.
//  Copyright © 2016 akshaytiyer. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var currentLines = [NSValue:Line]()
    var finishedLine = [Line]()
    
    
    //Current Ellipses Directory
    var currentEllipsesDirectory = [[NSValue:NSValue]]()
    var currentEllipses = [Line]()
    var finishedEllipses = [Line]()
    
    
    
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
