//
//  ITDetailImageCell.m
//  ImageTwiddler
//
//  Created by Ryan Tempas on 4/20/14.
//  Copyright (c) 2014 Tauer Productions. All rights reserved.
//

#import "ITDetailImageCell.h"

@implementation ITDetailImageCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    
    return self;
}

-(void) awakeFromNib
{
    self.imageSizeLabel.layer.cornerRadius = self.imageSizeLabel.frame.size.height/2;
    self.imageSizeLabel.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
