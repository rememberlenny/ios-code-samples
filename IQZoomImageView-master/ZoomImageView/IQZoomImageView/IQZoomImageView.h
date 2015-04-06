
#import <UIKit/UIKit.h>

@interface IQZoomImageView : UIScrollView<UIScrollViewDelegate>

@property(nonatomic, assign) CGSize extendedTouchSize;
@property(nonatomic, strong) UIImage *image;

@end
