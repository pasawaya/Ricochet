//
//  PSPositionSlider.h
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SliderMode) {
    SliderModePosition,
    SliderModeAngle,
    SliderModePlay
};

@interface PSPositionSlider : UISlider

@property (nonatomic, assign) SliderMode mode;
@property (nonatomic, assign) CGFloat initialValue;

-(instancetype)initWithFrame:(CGRect)frame thumbSize:(CGSize)size;
-(CGFloat)thumbXPosition;

@end
