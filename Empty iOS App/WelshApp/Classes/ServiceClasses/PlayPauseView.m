//
//  PlayPauseView.m
//  CwrsCymraeg
//  
//  Created by Neil Taylor on 22/05/2010.
//  Copyright 2010 Aberystwyth University. All rights reserved.
//

#import "PlayPauseView.h"

@implementation PlayPauseView

#define kEndAngle 1.5
#define kInterval 0.1

float interval = kInterval; 
float endAngle = kEndAngle; 

BOOL isPlaying = NO;

@synthesize timeInSeconds; 
@synthesize timeRemaining; 
@synthesize increment; 
@synthesize timer; 

/**
 * Initialise the view with the specified frame. 
 */
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
       [self setBackgroundColor: [UIColor clearColor]];
    }
    return self;
}

/**
 * Create the float version of an RGB value. The input value should
 * be between 0 and 255. The output value will be between 0.0 and 
 * 1.0. 
 */
- (CGFloat) rgbValue: (NSInteger) value { 
   return value / 255.0; 
}

/**
 * Draw the view. 
 */
- (void) drawInContext: (CGContextRef) context { 
   // Drawing with a white stroke color
	//CGContextSetRGBStrokeColor(context, 0.52, 0.58, 1.0, 1.0);
	// And draw with a blue fill color
   
   // 71, 91, 182 - progress 
   // 35 100 216 - bottom of button 
   // 136 147 169 - background 
   // 148 184 236 - top of button 
   float alpha; 
   if ([self isEnabled]) {
      alpha = 1.0;
   }
   else {
      alpha = 0.6;
   }
   
	// Draw them with a 2.0 stroke width so they are a bit more visible.
	CGContextSetLineWidth(context, 1.0);
   
   CGPoint f = CGPointMake(self.frame.size.width, self.frame.size.height); 
   CGPoint p = CGPointMake(f.x / 2, f.y / 2); 
   
   // draw the background 
   CGContextSetRGBFillColor(context, [self rgbValue: 136], [self rgbValue: 147], [self rgbValue: 169], alpha);
   CGContextSetRGBStrokeColor(context, [self rgbValue: 31], [self rgbValue: 38], [self rgbValue: 58], 0.4);
	CGContextFillEllipseInRect(context, CGRectMake(1.0, 1.0, f.x - 2, f.y - 2));
   CGContextStrokeEllipseInRect(context, CGRectMake(1.0, 1.0, f.x - 2, f.y - 2));
   CGContextStrokePath(context);
   
   CGContextSetRGBFillColor(context, [self rgbValue: 71], [self rgbValue: 91], [self rgbValue: 182], alpha);
	
   // draw the current progress 
   CGContextSetLineWidth(context, 0.0);
   CGContextMoveToPoint(context, p.x, p.y);
	CGContextAddArc(context, p.x, p.y, p.x - 2, M_PI * 1.5, M_PI * endAngle, false);
   CGContextClosePath(context);    
   
	// Fill & stroke the path
	CGContextDrawPath(context, kCGPathFillStroke);
   
   // draw the middle button 
	CGContextSetLineWidth(context, 1.5);
   CGContextSetRGBFillColor(context, [self rgbValue: 35], [self rgbValue: 110], [self rgbValue: 216], alpha);
	CGContextSetRGBStrokeColor(context, [self rgbValue: 24], [self rgbValue: 81], [self rgbValue: 208], alpha);
	
   float width = (self.frame.size.width / 2) - 2.0; 
   float height = (self.frame.size.height / 2) - 2.0; 
   float widthOffset = width / 2; 
   float heightOffset = height / 2; 
   
   CGContextFillEllipseInRect(context, CGRectMake(p.x - widthOffset, p.y - heightOffset, width, height));
   
   CGContextSetRGBFillColor(context, [self rgbValue: 86], [self rgbValue: 144], [self rgbValue: 225], alpha);
	CGContextMoveToPoint(context, p.x, p.y);
	CGContextAddArc(context, p.x, p.y, widthOffset, 0.0, M_PI, true); //86 144 225
   
   CGContextClosePath(context);
   CGContextDrawPath(context, kCGPathFillStroke);
   
   CGContextStrokeEllipseInRect(context, CGRectMake(p.x - widthOffset - 1.0, p.y - heightOffset - 1.0, width + 2, height + 2));
   CGContextStrokePath(context);
   
   CGContextSetRGBFillColor(context, [self rgbValue: 255], [self rgbValue: 255], [self rgbValue: 255], alpha);
	CGContextSetRGBStrokeColor(context, [self rgbValue: 24], [self rgbValue: 81], [self rgbValue: 208], alpha);
   
   if(isPlaying) 
   { 
      CGContextFillRect(context, CGRectMake(p.x - ((widthOffset - 1.0) / 2), p.y - ((heightOffset - 1.0) / 2), widthOffset - 1.0, heightOffset - 1.0));
      CGContextStrokeRect(context, CGRectMake(p.x - ((widthOffset - 1.0) / 2), p.y - ((heightOffset - 1.0) / 2), widthOffset - 1.0, heightOffset - 1.0)); 
      CGContextStrokePath(context);
   }
   else 
   { 
      CGContextSetLineWidth(context, 1.0);
      float offset = (widthOffset - 1.0) / 2;
      CGContextMoveToPoint(context, p.x - offset, p.y - offset - 2.0);
      CGContextAddLineToPoint(context, p.x + offset + 3.0, p.y);
      CGContextAddLineToPoint(context, p.x - offset, p.y + offset + 2.0);
      CGContextAddLineToPoint(context, p.x - offset, p.y - offset - 2.0);
      CGContextClosePath(context); 
      CGContextDrawPath(context, kCGPathFillStroke);
   }
   
   

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {

   [self drawInContext: UIGraphicsGetCurrentContext()];
   
}


- (void) stop { 
   [timer invalidate]; 
   timer = nil; 
   endAngle = kEndAngle; 
   isPlaying = NO; 
   
   [self setNeedsDisplay];
}

/** 
 *
 */ 
- (void) countdown { 
   
   // we keep the clock ticking beyond 0, to allow for the 
   // the angle to reach the top, before cancelling. 
   [self setTimeRemaining: [self timeRemaining] - interval];
   if( timeRemaining < -0.2 ) { 
      [self stop];
   }
   else if( timeRemaining >= -0.2 ) { 
      endAngle += increment;    
   }
   
   [self setNeedsDisplay];
}

- (void) playForTimeInner: (float) seconds { 

   [self setTimeInSeconds: seconds]; 
   [self setTimeRemaining: seconds]; 
   [self setIncrement: ((2.0 / ( seconds / interval )))];
   
   timer = [NSTimer scheduledTimerWithTimeInterval: interval 
                                            target: self 
                                          selector: @selector(countdown) 
                                          userInfo: nil 
                                           repeats: YES];
   isPlaying = YES; 
}

/** 
 * Start the display counting down for the specified number of seconds.
 * If the method is called when it is already playing, the playing 
 * will be stopped. 
 */ 
- (void) playForTime: (float) seconds { 
   
   if ([self isEnabled]) {
      if( isPlaying ) { 
         [self pause];
      }
      else {
         endAngle = kEndAngle;
         [self playForTimeInner: seconds];
      }
   }

}

/**
 *
 */
- (void) pause { 
   [self stop];
   [self setNeedsDisplay];
}


@end
