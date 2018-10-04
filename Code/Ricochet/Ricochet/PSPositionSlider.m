//
//  PSPositionSlider.m
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSPositionSlider.h"

@interface PSPositionSlider ()

@property (nonatomic, assign) CGSize thumbSize;

@end

@implementation PSPositionSlider

-(instancetype)initWithFrame:(CGRect)frame thumbSize:(CGSize)size {
    if(self = [super initWithFrame:frame]) {
        self.mode = SliderModePosition;
        
        self.continuous = YES;
        self.minimumValue = CGRectGetMinX(frame);
        self.maximumValue = CGRectGetMaxX(frame);
        self.thumbSize = size;
        self.value = CGRectGetMidX(frame);
        
        UIImage *thumbImage = [self imageWithImage:[UIImage imageNamed:@"transparent_thumb.png"] scaledToSize:size];
        [self setThumbImage:thumbImage forState:UIControlStateNormal];
        
        UIImage *sliderTrackImage = [[UIImage imageNamed:@"shotline.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 7, 0, 0)];
        [self setMinimumTrackImage:sliderTrackImage forState:UIControlStateNormal];
        [self setMaximumTrackImage:sliderTrackImage forState:UIControlStateNormal];
    }
    
    return self;
}

-(CGFloat)thumbXPosition {
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGRect thumbRect = [self thumbRectForBounds:self.bounds
                                      trackRect:trackRect
                                          value:self.value];
    return self.frame.origin.x + CGRectGetMidX(thumbRect);
}

#pragma mark - Utility
-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    return CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value], -10, -10);
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
