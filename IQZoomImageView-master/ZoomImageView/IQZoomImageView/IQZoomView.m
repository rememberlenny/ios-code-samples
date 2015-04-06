//
//  IQZoomView.m
//  HomeZoomView
//
//  Created by Canopus 4 on 14/03/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import "IQZoomView.h"
#import "IQZoomImageView.h"

@implementation IQZoomView

-(void)initialize
{
//    self.clipsToBounds = NO;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
        self.zoomImageView = [[IQZoomImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.zoomImageView];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = CGRectInset(self.bounds, -_extendedTouchSize.width, -_extendedTouchSize.height);
    return (CGRectContainsPoint(bounds, point));
}

-(void)setExtendedTouchSize:(CGSize)extendedTouchSize
{
    _extendedTouchSize = extendedTouchSize;
    [self.zoomImageView setExtendedTouchSize:extendedTouchSize];
}

@end
