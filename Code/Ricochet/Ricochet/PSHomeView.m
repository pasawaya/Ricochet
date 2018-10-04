//
//  PSHomeVIew.m
//  ricochet
//
//  Created by Philippe Sawaya on 2/4/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSHomeView.h"
#import "Constants.h"
#import "UIImage+animatedGIF.h"

@interface PSHomeView ()

@property (nonatomic, strong) UIImageView *gifView;
@property (nonatomic, strong) UIImage *gif;

@end

@implementation PSHomeView

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [Constants blue];
        
        CGFloat width = [Constants width], height = [Constants height];
        
        //Ricochet Title GIF
        self.gif = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:@"bounce1" withExtension:@"gif"]];
        
        CGPoint gifOrigin = CGPointMake(width/1.2, height * 0.13);
        CGRect gifFrame = CGRectMake(gifOrigin.x, gifOrigin.y, width-2*gifOrigin.x, self.gif.size.height);
        self.gifView = [[UIImageView alloc] initWithFrame:gifFrame];
        self.gifView.animationImages = self.gif.images;
        self.gifView.animationDuration = self.gif.duration;
        self.gifView.animationRepeatCount = 1;
        self.gifView.image = self.gif.images.lastObject;
        self.gifView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.gifView];
        
        //Play Button
        CGFloat playWidth = width/3, playHeight = playWidth;
        CGRect playButtonFrame = CGRectMake((width-playWidth)/2, (height-playHeight)/2, playWidth, playHeight);
        
        UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = playButtonFrame;
        [playButton setImage:[UIImage imageNamed:@"play_icon.png"] forState:UIControlStateNormal];
        [playButton addTarget:self action:@selector(playTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playButton];
        
        //Buttons
        CGFloat buttonWidth = width/8, buttonHeight = buttonWidth, xPadding = 15, yPadding = 50;
        
        CGRect levelsButtonFrame = CGRectMake(CGRectGetMinX(playButtonFrame)-2*xPadding, CGRectGetMaxY(playButtonFrame)+yPadding, buttonWidth, buttonHeight);
        CGRect storeButtonFrame = CGRectMake(CGRectGetMaxX(levelsButtonFrame)+xPadding, CGRectGetMaxY(playButtonFrame)+yPadding, buttonWidth, buttonHeight);
        CGRect settingsButtonFrame = CGRectMake(CGRectGetMaxX(storeButtonFrame)+xPadding, CGRectGetMaxY(playButtonFrame)+yPadding, buttonWidth, buttonHeight);
        
        UIButton *levelsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        levelsButton.frame = levelsButtonFrame;
        [levelsButton setImage:[UIImage imageNamed:@"levels_icon.png"] forState:UIControlStateNormal];
        [levelsButton addTarget:self action:@selector(levelsTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:levelsButton];
        
        UIButton *storeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        storeButton.frame = storeButtonFrame;
        [storeButton setImage:[UIImage imageNamed:@"store_icon.png"] forState:UIControlStateNormal];
        [storeButton addTarget:self action:@selector(storeTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:storeButton];
        
        UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        settingsButton.frame = settingsButtonFrame;
        [settingsButton setImage:[UIImage imageNamed:@"settings_icon.png"] forState:UIControlStateNormal];
        [settingsButton addTarget:self action:@selector(settingsTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:settingsButton];
    }
    
    return self;
}

-(void)postNotificationWithName:(NSString *)name {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil];
}

#pragma mark - Animations
-(void)runGIF {
    [self.gifView startAnimating];
}

-(void)resetGIF {
    self.gifView.image = self.gif.images.firstObject;
}

#pragma mark - Button Tapped Handlers
-(void)playTapped {[self postNotificationWithName:kNotificationPlayKey];}
-(void)levelsTapped {[self postNotificationWithName:kNotificationLevelsKey];}
-(void)settingsTapped {[self postNotificationWithName:kNotificationSettingsKey];}
-(void)storeTapped {[self postNotificationWithName:kNotificationStoreKey];}
//-(void)leaderboardTapped {[self postNotificationWithName:kNotificationLeaderboardKey];}

@end
