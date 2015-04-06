//
//  IQShadowImageView.m
//  HomeZoomView
//
//  Created by Canopus 4 on 14/03/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import "IQShadowImageView.h"

@implementation IQShadowImageView
{
    UIImageView *imageView;
    UIImageView *shadowedImageView;
}

-(void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    shadowedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    shadowedImageView.layer.shouldRasterize = YES;
    shadowedImageView.layer.rasterizationScale = 0.5;
    shadowedImageView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    shadowedImageView.layer.shadowRadius = 10.0f;
    shadowedImageView.layer.shadowOpacity = 1.0f;
    [self addSubview:shadowedImageView];
    
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
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
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    shadowedImageView.frame = self.bounds;
    imageView.frame = self.bounds;
}

-(void)setContentMode:(UIViewContentMode)contentMode
{
    [super setContentMode:contentMode];
    
    shadowedImageView.contentMode = contentMode;
    imageView.contentMode = contentMode;
}

-(void)setImage:(UIImage*)image
{
    shadowedImageView.image = image;
    imageView.image = image;
}

@end
