//
//  DPAViewController.m
//  GestureDemo
//
//  Created by Andrea Dal Ponte on 15/11/13.
//  Copyright (c) 2013 Develon srl. All rights reserved.
//

#import "DPAViewController.h"

@interface DPAViewController ()

@property (nonatomic, assign) NSInteger imageCounter;

@end

@implementation DPAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    tap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipe:)];
    swipe.delegate = self;
    swipe.direction = UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionUp;
    swipe.numberOfTouchesRequired = 2;
    [self.view addGestureRecognizer:swipe];
}

- (UIImage *)nextImage
{
    self.imageCounter++;
    if(self.imageCounter > 9) self.imageCounter = 1;
    return [UIImage imageNamed:[NSString stringWithFormat:@"img0%i.jpg", self.imageCounter]];
}

- (void) onSwipe:(UISwipeGestureRecognizer *)swipe
{
    [UIView animateWithDuration:0.5 animations:^
    {
        for (UIView *view in self.view.subviews)
        {
            if ([view isKindOfClass:[UIImageView class]])
            {
                CGRect frame = view.frame;
                frame.origin.y = 1000.0f;
                view.frame = frame;
            }
        }
    } completion:^(BOOL finished)
    {
        for (UIView *view in self.view.subviews)
        {
            if ([view isKindOfClass:[UIImageView class]])
            {
                [view removeFromSuperview];
            }
        }
    }];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)tap
{
    CGPoint center = [tap locationInView:self.view];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self nextImage]];
    imageView.center = center;
    imageView.alpha = 0.2;
    imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
    imageView.transform = CGAffineTransformMakeRotation(M_PI);
    imageView.layer.shadowColor = [UIColor grayColor].CGColor;
    imageView.layer.shadowOffset = CGSizeMake(2, 3);
    imageView.layer.shadowOpacity = 0.5;
    imageView.layer.shadowRadius = 1.0;
    imageView.clipsToBounds = NO;
    imageView.userInteractionEnabled = YES;
    
    
    [self addGestureToImageView:imageView];
    [self.view addSubview:imageView];
    
    [UIView animateWithDuration:0.6 animations:^{
        imageView.alpha = 1.0;
        imageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) addGestureToImageView:(UIImageView *)imageView
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    [imageView addGestureRecognizer:pan];
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(onPinch:)];
    [imageView addGestureRecognizer:pinch];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(onRotation:)];
    [imageView addGestureRecognizer:rotation];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [imageView addGestureRecognizer:longPress];
}

- (void) onLongPress:(UILongPressGestureRecognizer *)longPress
{
    UIView *view = [longPress view];
    
    [UIView animateWithDuration:0.6f animations:^{

         CGRect frame = view.frame;
         frame.origin.y = 1000.0f;
         view.frame = frame;
        
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

- (void) onPan:(UIPanGestureRecognizer *)pan
{
    pan.delegate = self;
    CGPoint panPoint = [pan translationInView:self.view];
    CGPoint imageCenter = pan.view.center;
    imageCenter.x+= panPoint.x;
    imageCenter.y+= panPoint.y;
    pan.view.center = imageCenter;
    [pan setTranslation:CGPointZero inView:self.view];
}


- (void) onPinch:(UIPinchGestureRecognizer *)pinch
{
    pinch.delegate = self;
    CGFloat scale = [pinch scale];
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, scale, scale);
    [pinch setScale:1];
}


- (void) onRotation:(UIRotationGestureRecognizer *)rotation
{
    rotation.delegate = self;
    CGFloat scale = [rotation rotation];
    rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, scale);
    [rotation setRotation:0.0];
}


// gestureRecognizer

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isKindOfClass:[UISwipeGestureRecognizer class]])
    {
        CGPoint point = [gestureRecognizer locationInView:self.view];
        UIView *view = [self.view hitTest:point withEvent:nil];
        if ([view isKindOfClass:[UIImageView class]])
        {
            return NO;
        }
    }
    
    return YES;
}

@end
