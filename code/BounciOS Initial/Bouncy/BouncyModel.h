//
//  BouncyModel.h
//  Bouncy
//
// This source code is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
// To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/3.0/
// or send a letter to Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

#import <Foundation/Foundation.h>

@interface BouncyModel : NSObject
{
@private
    NSMutableArray* _balls;
    CGRect _bounds;
    BOOL _wrap;
}
-(id)initWithBounds:(CGRect)rect;
-(NSInteger)numberOfBalls;
-(CGRect)ballBounds:(NSInteger)whichBall;
-(void)updateBallPositions;
-(void)createAndAddNewBall;
-(void)changeNumberOfBalls:(NSInteger)newNumberOfBalls;
-(void)handleCollisions;
-(BOOL)CheckCollisionWith:(NSInteger)futureX andWith:(NSInteger)futureY using:(NSInteger)thisBallIndex;
-(void)wrapping:(BOOL)wrapOn;
-(BOOL)wrapping;
@end
