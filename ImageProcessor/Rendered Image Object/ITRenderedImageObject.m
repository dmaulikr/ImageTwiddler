//
//  ITRenderedImageObject.m
//  ImageTwiddler
//
//  Created by Ryan Tempas on 4/16/14.
//  Copyright (c) 2014 Tauer Productions. All rights reserved.
//

#import "ITRenderedImageObject.h"

@implementation ITRenderedImageObject

-(id)initWithImage:(CGImageRef)image calcDuration:(double)duration numberOfThreads:(NSInteger)threads
{
    self = [super init];
    if (self)
    {
        self.image = image;
        self.calculationDuration = duration;
        self.numberOfThreads = threads;
    }
    return self;
}

-(NSString *)calculationDurationText
{
    int maxDigitsAfterDecimal = 4; // here's where you set the dp
    NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
    [nf setMaximumFractionDigits:maxDigitsAfterDecimal];
    [nf setMinimumIntegerDigits:1];
    NSString * trimmed = [nf stringFromNumber:[NSNumber numberWithDouble:_calculationDuration]];
    
    return trimmed;
}

@end
