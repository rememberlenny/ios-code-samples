//
//  ViewController.m
//  HomeZoomView
//
//  Created by Canopus 4 on 14/03/14.
//  Copyright (c) 2014 Iftekhar. All rights reserved.
//

#import "ViewController.h"
#import "IQZoomView.h"

@interface ViewController ()
{
    IBOutlet IQZoomView *zoomImageView;
    NSArray *images;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    zoomImageView.extendedTouchSize = CGSizeMake(200, 200);
//    [baseView setClipsToBounds:NO];
//    [baseView.layer setMasksToBounds:NO];

    images = [[NSArray alloc] initWithObjects:
              [UIImage imageNamed:@"image1.jpg"],
              [UIImage imageNamed:@"image2.jpg"],
              [UIImage imageNamed:@"image3.jpg"],
              [UIImage imageNamed:@"image4.jpg"],
              [UIImage imageNamed:@"image5.jpg"],
              [UIImage imageNamed:@"image6.gif"],
              [UIImage imageNamed:@"image7.gif"],
              [UIImage imageNamed:@"image8.jpg"],
              [UIImage imageNamed:@"image9.jpg"],
              [UIImage imageNamed:@"image10.jpg"],
              [UIImage imageNamed:@"image11"],
              [UIImage imageNamed:@"image12"],
              [UIImage imageNamed:@"image13"],
              nil];

	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)changeImageClicked:(UIButton *)sender
{
    static int count = 0;
    
    UIImage *image = [images objectAtIndex:((count++)%images.count)];
    
    [zoomImageView.zoomImageView setImage:image];
}
- (IBAction)nilImageClicked:(UIButton *)sender
{
    [zoomImageView.zoomImageView setImage:nil];
}



@end
