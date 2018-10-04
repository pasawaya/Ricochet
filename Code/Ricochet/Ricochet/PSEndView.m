//
//  PSEndView.m
//  ricochet
//
//  Created by Philippe Sawaya on 2/3/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSEndView.h"
#import "PSLevel.h"
#import "PSLevelButton.h"
#import "PSLevelManager.h"
#import "PSUserData.h"
#import "Constants.h"

@interface PSEndView ()

@end

@implementation PSEndView

-(instancetype)initWithFrame:(CGRect)frame level:(PSLevel *)level {
    if(self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 22.0f;
        self.backgroundColor = [Constants bumperColor];
        
        //Add Stroke
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 8.f;
        
        CGFloat width = frame.size.width,
                height = frame.size.height;
        
        //Add Label
        CGFloat labelWidth = width,
                labelHeight = 0.17 * height;
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height * 0.1, labelWidth, labelHeight)];
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.text = @"Completed!";
        messageLabel.font = [UIFont fontWithName:kFontName size:35];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:messageLabel];
        
        
        CGFloat buttonSize = 0.16 * height;
        
        CGFloat minX = 0.1 * width,
                minY = 0.7 * height;
        
        CGFloat paddingX = (width-(2*minX)-(3*buttonSize))/2;
        
        //Add Home Button
        UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        homeButton.frame = CGRectMake(minX, minY, buttonSize, buttonSize);
        [homeButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        homeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        homeButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [homeButton setImage:[UIImage imageNamed:@"home_button.png"] forState:UIControlStateNormal];
        [homeButton addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:homeButton];
        
        //Add Retry Button
        UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        retryButton.frame = CGRectMake(CGRectGetMaxX(homeButton.frame)+paddingX, minY, buttonSize, buttonSize);
        [retryButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        retryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        retryButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [retryButton setImage:[UIImage imageNamed:@"replay_button.png"] forState:UIControlStateNormal];
        [retryButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:retryButton];
        
        //Add Next Button
        UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        nextButton.frame = CGRectMake(CGRectGetMaxX(retryButton.frame)+paddingX, minY, buttonSize, buttonSize);
        [nextButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        nextButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        nextButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [nextButton setImage:[UIImage imageNamed:@"next_button.png"] forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextLevel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:nextButton];
    }
    
    return self;
}

-(void)setUIForLevel:(PSLevel *)level {
    CGFloat width  = self.frame.size.width,
            height = self.frame.size.height;
    
    //Add Level Image
    CGFloat levelSize = 0.4*width;
    CGRect levelFrame = CGRectMake((width-levelSize)/2, height*0.3, levelSize, levelSize);
    PSLevelButton *levelImage = [PSLevelButton buttonWithFrame:levelFrame level:level minorFontSize:kEndViewLevelIconMinorFontSize majorFontSize:kEndViewLevelIconMajorFontSize];
    levelImage.userInteractionEnabled = NO;
    [self addSubview:levelImage];
    
    //Add Stars
    CGFloat starSize = 0.07 * height,
            starPaddingX = 0.01 * height;
    
    CGFloat starMidX = width/2,
            starMinX = starMidX-(starSize/2)-(starSize)-starPaddingX,
            starMinY = 0.59 * height;
    
    NSUInteger numBounces = [[PSUserData sharedData].scores[@(level.levelNumber)] unsignedIntegerValue];
    NSUInteger numStars = [PSLevelManager starsForNumberOfBounces:numBounces onLevel:level.levelNumber];
    
    for(int i = 0; i < 3; i++) {
        NSString *imageName = (i+1) <= numStars ? @"star_white.png" : @"star_black.png";
        UIImageView *star = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        star.frame = CGRectMake(starMinX+(i*starSize)+(i*starPaddingX), starMinY, starSize, starSize);
        [self addSubview:star];
    }
}

-(void)showForLevel:(PSLevel *)level {
    [self setUIForLevel:level];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 1;
    }];
}

#pragma mark - Button Actions
-(void)nextLevel {
    [self fadeOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationNextKey object:nil];
}

-(void)retry {
    [self fadeOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRetryKey object:nil];
}

-(void)home {
    [self fadeOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHomeKey object:nil];
}

#pragma mark - View Animations
-(void)fadeOut {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        self.alpha = 0;
    }];
}

@end
