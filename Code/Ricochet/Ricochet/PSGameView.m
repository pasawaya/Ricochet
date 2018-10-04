//
//  PSGameView.m
//  ricochet
//
//  Created by Philippe Sawaya on 2/16/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSGameView.h"
#import "PSGameScene.h"
#import "PSLevel.h"
#import "PSLevelManager.h"
#import "Constants.h"
#import "PSLevelButton.h"

#import "PSGameNode.h"

@interface PSGameView ()

@property (nonatomic, strong) PSGameScene *gameScene;
@property (nonatomic, strong) PSLevel *currentLevel;
@property (nonatomic, strong) UILabel *levelLabel;

@end

@implementation PSGameView

-(instancetype)initWithFrame:(CGRect)frame level:(PSLevel *)level {
    if(self = [super initWithFrame:frame]) {
        self.currentLevel = level;
        
        self.gameScene = [[PSGameScene alloc] initWithSize:self.bounds.size level:level];
        [(SKView *)self presentScene:self.gameScene];
        
        CGFloat width    = self.bounds.size.width,
                height   = self.bounds.size.height * kGoalZoneHeightRatio,
                xPadding = 30;
        
        //Add Pause and Home Buttons
        CGFloat buttonWidth = 0.7 * height,
                buttonHeight = buttonWidth;
        
        UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        retryButton.frame = CGRectMake(width-xPadding-buttonWidth, (height-buttonHeight)/2, buttonWidth, buttonHeight);
        [retryButton setImage:[UIImage imageNamed:@"replay_button.png"] forState:UIControlStateNormal];
        [retryButton addTarget:self action:@selector(reshowCurrentLevel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:retryButton];
        [self sendSubviewToBack:retryButton];
        
        UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        homeButton.frame = CGRectMake(width-CGRectGetMaxX(retryButton.frame), (height-buttonHeight)/2, buttonWidth, buttonHeight);
        [homeButton setImage:[UIImage imageNamed:@"home_button.png"] forState:UIControlStateNormal];
        [homeButton addTarget:self action:@selector(home) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:homeButton];
        [self sendSubviewToBack:homeButton];
        
        //Add Level Number
        CGRect levelLabelFrame = CGRectMake(0, (height-buttonHeight)/2, [Constants width], buttonHeight);
        self.levelLabel = [[UILabel alloc] initWithFrame:levelLabelFrame];
        self.levelLabel.textAlignment = NSTextAlignmentCenter;
        self.levelLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.currentLevel.levelNumber];
        self.levelLabel.font = [UIFont fontWithName:kFontName size:32];
        self.levelLabel.textColor = [Constants backgroundColor];
        [self addSubview:self.levelLabel];
        [self sendSubviewToBack:self.levelLabel];
    }
    
    return self;
}

-(void)showLevel:(PSLevel *)level {
    self.currentLevel = level;
    self.levelLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.currentLevel.levelNumber];
    [self.gameScene resetForLevel:level];
}

-(void)showNextLevel {
    [self showLevel:[PSLevelManager levelForNumber:(self.currentLevel.levelNumber+1)]];
}

-(void)reshowCurrentLevel {
    [self showLevel:self.currentLevel];
}

-(void)home {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHomeKey object:nil];
}

@end
