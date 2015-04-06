//
//  IQZoomView.h
//  HomeZoomView
//
//  Created by Canopus 4 on 14/03/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQZoomImageView.h"

@interface IQZoomView : UIView

@property(nonatomic, assign) CGSize extendedTouchSize;
@property(nonatomic, strong) IBOutlet IQZoomImageView *zoomImageView;

@end
