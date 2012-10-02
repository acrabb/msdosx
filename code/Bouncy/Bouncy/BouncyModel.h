//
//  BouncyModel.h
//  Bouncy
//
//  Created by Amir Khodaei on 9/24/12.
//  Copyright (c) 2012 Amir Khodaei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BouncyModel : NSObject
{
    NSMutableArray* _balls;
    CGRect _bounds;
}

-(id)initWithBounds:(CGRect)rect;


-(NSInteger)numberOfBalls;
-(CGRect)ballBounds:(NSInteger)whichBall;
-(void)updateBallPositions;
-(void)createAndAddNewBall;
-(void)changeNumberOfBalls:(NSInteger)newNumberOfBalls;

-(void)handleCollisions;
-(BOOL)CheckCollisionWith:(NSInteger)futureX andWith:(NSInteger)futureY using:(NSInteger)thisBallIndex;



@end
