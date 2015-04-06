
#import "IQZoomImageView.h"
#import "IQShadowImageView.h"


#define CONTENT_INSET 10.0f
#define ZOOM_LEVELS 100



static inline CGFloat ZoomScaleThatFits(CGSize target, CGSize source)
{
	CGFloat w_scale = (target.width / source.width);
	CGFloat h_scale = (target.height / source.height);
	return ((w_scale < h_scale) ? w_scale : h_scale);
}


@implementation IQZoomImageView
{
    IQShadowImageView *_imageView;
}

-(void)initialize
{
    self.scrollsToTop = NO;
    self.delaysContentTouches = NO;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.contentMode = UIViewContentModeRedraw;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.autoresizesSubviews = NO;
    self.bouncesZoom = YES;
    self.delegate = self;
    self.clipsToBounds = NO;

    _imageView = [[IQShadowImageView alloc] initWithFrame:self.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_imageView];
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

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    
    [self setZoomScale:1.0 animated:YES];
    _imageView.image = _image;
    
    if (_image == nil || CGSizeEqualToSize(CGSizeZero, _image.size))
    {
        CGRect bounds = self.frame;
        bounds.origin = CGPointZero;
        
        _imageView.frame    = bounds;
    }
    else
    {
        CGRect bounds = CGRectZero;
        bounds.size = _image.size;
        
        _imageView.frame    = bounds;
    }
    
    self.contentSize = _imageView.bounds.size;
    self.contentOffset = CGPointMake((0.0f - CONTENT_INSET), (0.0f - CONTENT_INSET));
    self.contentInset = UIEdgeInsetsMake(CONTENT_INSET, CONTENT_INSET, CONTENT_INSET, CONTENT_INSET);
    [self updateMinimumMaximumZoom];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self updateMinimumMaximumZoom];
}

- (void)updateMinimumMaximumZoom
{
	CGRect targetRect = CGRectInset(self.bounds, CONTENT_INSET, CONTENT_INSET);
	CGFloat zoomScale = ZoomScaleThatFits(targetRect.size, _imageView.bounds.size);
	self.minimumZoomScale = zoomScale;
	self.maximumZoomScale = (zoomScale * ZOOM_LEVELS);
    self.zoomScale = self.minimumZoomScale;
}

//- (void)layoutSubviews
//{
//	[super layoutSubviews];
//    
//	CGSize boundsSize = self.bounds.size;
//	CGRect viewFrame = _imageView.frame;
//    
//	if (viewFrame.size.width < boundsSize.width)
//		viewFrame.origin.x = (((boundsSize.width - viewFrame.size.width) / 2.0f) + self.contentOffset.x);
//	else
//		viewFrame.origin.x = 0.0f;
//    
//	if (viewFrame.size.height < boundsSize.height)
//		viewFrame.origin.y = (((boundsSize.height - viewFrame.size.height) / 2.0f) + self.contentOffset.y);
//	else
//		viewFrame.origin.y = 0.0f;
//    
//	_imageView.frame = viewFrame;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect boundsRect = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    CGRect proposedContentFrame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    
    if (boundsRect.size.width>proposedContentFrame.size.width)
        proposedContentFrame.origin.x = ((boundsRect.size.width-proposedContentFrame.size.width+self.bounds.origin.x/2.0)/2.0);
    
    if (boundsRect.size.height>proposedContentFrame.size.height)
        proposedContentFrame.origin.y = ((boundsRect.size.height-proposedContentFrame.size.height+self.bounds.origin.y/2.0)/2.0);
    
    _imageView.center = CGPointMake(CGRectGetMidX(proposedContentFrame), CGRectGetMidY(proposedContentFrame));
}


- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return _imageView;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = CGRectInset(self.bounds, -_extendedTouchSize.width, -_extendedTouchSize.height);
    return (CGRectContainsPoint(bounds, point));
}

@end




