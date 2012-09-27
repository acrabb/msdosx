//
//  BouncyModel.m
//  Bouncy
//
//  Created by Amir Khodaei on 9/24/12.
//  Copyright (c) 2012 Amir Khodaei. All rights reserved.
//

#import "BouncyModel.h"

const NSInteger kBallSize = 48;


@interface Ball : NSObject {
//    NSInteger _xPosition;
//    NSInteger _yPosition;
//    NSInteger _xVelocity;
//    NSInteger _yVelocity;
}

@property (assign) NSInteger xPosition;
@property (assign) NSInteger yPosition;
@property (assign) NSInteger xVelocity;
@property (assign) NSInteger yVelocity;

-(id)initWithXPosition:(NSInteger)xPos
             yPosition:(NSInteger)yPos
             xVelocity:(NSInteger)xVel
             yVelocity:(NSInteger)yVel;

-(void)updatePositionInBounds:(CGRect)bounds;
-(CGRect)bounds;

@end





@implementation Ball

@synthesize xPosition = _xPosition,
yPosition = _yPosition,
xVelocity = _xVelocity,
yVelocity = _yVelocity;

-(id)initWithXPosition:(NSInteger)xPos
             yPosition:(NSInteger)yPos
             xVelocity:(NSInteger)xVel
             yVelocity:(NSInteger)yVel {
    self = [super init];
    if(self) {
        self.xPosition = xPos;
        self.yPosition = yPos;
        self.xVelocity = xVel;
        self.yVelocity = yVel;
    }
    
    return self;
}

-(void)updatePositionInBounds:(CGRect)bounds

{
    NSInteger leftEdge = bounds.origin.x;
    NSInteger topEdge = bounds.origin.y;
    NSInteger rightEdge = ( bounds.origin.x + bounds.size.width );
    NSInteger bottomEdge = ( bounds.origin.x + bounds.size.height );

    _xPosition += _xVelocity;
    _yPosition += _yVelocity;
    
    // Bounce off the left or right wall
    if ((( _xPosition + kBallSize) > rightEdge) || (_xPosition < leftEdge)) {
        _xVelocity = -(_xVelocity);
        _xPosition += _xVelocity;
    }
    
    // Bounce off the top or bottom wall
    
    if ((( _yPosition + kBallSize) > bottomEdge) || (_yPosition < topEdge)) {
        _yVelocity = -_yVelocity;
        _yPosition += _yVelocity;
    }
}

-(CGRect)bounds {
    
    CGRect boundsRect = CGRectMake(_xPosition,_yPosition,kBallSize,kBallSize);
    return(boundsRect);
}

@end






@implementation BouncyModel

-(id)initWithBounds:(CGRect)rect {
    
    // allocating self, if successfull, initializing its ivars
    self = [super init];
    
    // Q: Why is this necessary?
    if (self) {
        _balls = [[NSMutableArray alloc] init];
        _bounds = rect;
    }
    
    return self;
}

-(void)dealloc
{
    [_balls release];
    [super dealloc];
}



// Return the current number of balls in the model. It is a “getter” for the ViewController

-(NSInteger)numberOfBalls
{
    return _balls.count;
}

// Return the NSRect of the requested ball (whichBall). It’s the same idea as the previous method.

-(CGRect)ballBounds:(NSInteger)whichBall
{
    return [[_balls objectAtIndex:whichBall] bounds];
}

// Run through the balls in the model and call the Ball's -updatePositionInBounds method we just wrote on the last page. (We call this method later on a timer from our ViewController)

-(void)updateBallPositions

{
    for (Ball* b in _balls) {
        [b updatePositionInBounds:_bounds];
    }
    // vv Wrong vv
//    Ball *b;
//    for (int i=0; i < [self numberOfBalls]; i++) {
//        b = [_balls objectAtIndex:i];
//        [b updatePositionInBounds:[self ballBounds:i]];
//    }
    
}

// Allocate, initialize, and store a new Ball in our model.

-(void)createAndAddNewBall

{
    
    Ball* newBall;
    
    int leftEdge = _bounds.origin.x;
    
    int topEdge = _bounds.origin.y;
    
    int rightEdge = ( _bounds.origin.x + _bounds.size.width );
    
    int bottomEdge = ( _bounds.origin.x + _bounds.size.height );
    
    NSInteger xPos = ( random( ) % ( rightEdge - leftEdge - kBallSize ) ) + leftEdge;
    
    NSInteger yPos = ( random( ) % ( bottomEdge - topEdge - kBallSize ) ) + topEdge;
    
    NSInteger xVel = ( ( random( ) % 800 ) - 400 ) / 100;
    
    NSInteger yVel = ( ( random( ) % 800 ) - 400 ) / 100;
    
    newBall = [[Ball alloc] initWithXPosition:xPos
                                    yPosition:yPos
                                    xVelocity:xVel
                                    yVelocity:yVel];
    
    [_balls addObject:newBall];
    [newBall autorelease];
}

// Creates and adds new Balls (above) if the newNumberOfBalls is greater than what already exist, and remove Balls from the model if it is less.

-(void)changeNumberOfBalls:(NSInteger)newNumberOfBalls

{
    NSInteger numBalls = [_balls count];
    while (numBalls < newNumberOfBalls) {
        [self createAndAddNewBall];
        numBalls++;
    }
    while (numBalls > newNumberOfBalls) {
        [_balls removeLastObject];
        numBalls--;
    }
    
}



@end
