//
//  Fraction.m
//  FractionCalculator
//
//  Created by Kevin Jorgensen on 7/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Fraction.h"


int GCD(int a, int b)
{
    int tmp;
    while ( a != 0 )
    {
        tmp = a;
        a = b % a;
        b = tmp;
    }
    return b;
}

@implementation Fraction


- (id) initWithNumerator: (int) numer andDenominator: (int) denom
{
    self = [super init];
    
    if (self)
    {
        numerator = numer;
        denominator = denom;
    }
    
    return self;
}


- (NSString*) description
{
    return [NSString stringWithFormat: @"%d/%d", numerator, denominator];
}


- (int) numerator
{
    return numerator;
}


- (int) denominator
{
    return denominator;
}


- (Fraction *) add: (Fraction *) otherFraction
{
    if(otherFraction == nil)
        return nil;
    
    int n = [self numerator];
    int d = [self denominator];
    
    int otherN = [otherFraction numerator];
    int otherD = [otherFraction denominator];
    
    int newN = (n * otherD + d * otherN);
    int newD = d * otherD;
    
    Fraction *retVal = [[Fraction alloc] initWithNumerator:newN
                                            andDenominator:newD];
    
    [retVal reduce];
    
    return retVal;
    
}


- (Fraction *) subtract: (Fraction *) otherFraction
{
    // (a/b) - (c/d) = (a*d - b*c)/(b*d)
    
    if(otherFraction == nil)
        return nil;

    int oNum = [otherFraction numerator];
    int oDenom = [otherFraction denominator];
    
    int newNum = [self numerator] * oDenom - [self denominator] * oNum;
    int newDenom = denominator * oDenom;
    
    Fraction *retVal = [[Fraction alloc] initWithNumerator:newNum
                                            andDenominator:newDenom];
    
    [retVal reduce];
    
    return retVal;
}


- (Fraction *) multiply: (Fraction *) otherFraction
{    
    int newNum = [self numerator] * [otherFraction numerator];
    int newDenom = [self denominator] * [otherFraction denominator];

    Fraction *retVal = [[Fraction alloc] initWithNumerator:newNum andDenominator:newDenom];
    
    [retVal reduce];
                              
    return retVal;
}


- (Fraction *) divide: (Fraction *) otherFraction
{
    Fraction *retVal = [self multiply:[otherFraction inverse]];
    return retVal;
}


- (void) reduce
{
    
}


- (Fraction *) inverse
{
    return nil;
}


@end
