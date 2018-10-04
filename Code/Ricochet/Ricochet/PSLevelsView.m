//
//  PSLevelsView.m
//  ricochet
//
//  Created by Philippe Sawaya on 2/7/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSLevelsView.h"
#import "Constants.h"
#import "PSLevelButton.h"
#import "PSLevel.h"
#import "PSLevelManager.h"
#import "PSUserData.h"

@interface PSLevelsView ()

@property (nonatomic, strong) UIScrollView *buttonsContainer;

@end

@implementation PSLevelsView

-(instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.backgroundColor = [Constants blue];
        
        CGFloat width = self.bounds.size.width,
                height = self.bounds.size.height;
        
        //"Levels" Label
        CGFloat labelWidth = width/1.2, labelHeight = height/4.f;
        UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake((width-labelWidth)/2, labelHeight/4, labelWidth, labelHeight)];
        mainLabel.text = @"Levels";
        mainLabel.textAlignment = NSTextAlignmentCenter;
        mainLabel.font = [UIFont fontWithName:kFontName size:60.f];
        [self addSubview:mainLabel];
        
        NSUInteger buttonsPerPage = kLevelsButtonsNumRows * kLevelsButtonsNumColumns;
        NSUInteger numPages = ceil((CGFloat)kLevelsNumLevels/buttonsPerPage);
        
        //Set-up Scroll View
        CGFloat scrollMinY = kLevelsButtonsTopBound * height;
        CGFloat scrollHeight = height-scrollMinY;
        CGSize contentSize = CGSizeMake(numPages*width, scrollHeight);
        
        self.buttonsContainer = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollMinY, width, scrollHeight)];
        self.buttonsContainer.contentSize = contentSize;
        self.buttonsContainer.pagingEnabled = YES;
        self.buttonsContainer.clipsToBounds = YES;
        self.buttonsContainer.userInteractionEnabled = YES;
        self.buttonsContainer.bounces = NO;
        self.buttonsContainer.directionalLockEnabled = YES;
        self.buttonsContainer.showsHorizontalScrollIndicator = NO;
        self.buttonsContainer.showsVerticalScrollIndicator = NO;
        self.buttonsContainer.scrollsToTop = NO;
        [self addSubview:self.buttonsContainer];
        
        //Add Back Button
        CGFloat backWidth = 0.7 * self.bounds.size.height * kGoalZoneHeightRatio,
                backHeight = backWidth;
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(15, 15, backWidth, backHeight);
        [backButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
        backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        backButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [backButton setImage:[UIImage imageNamed:@"back_button.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backSelected) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        //Set-up Buttons
        [self setupButtons];
    }
    
    return self;
}

-(void)setupButtons {
    [[self.buttonsContainer subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger buttonsPerPage = kLevelsButtonsNumRows * kLevelsButtonsNumColumns;
    NSUInteger numPages = ceil((CGFloat)kLevelsNumLevels/buttonsPerPage);
    
    CGFloat width = self.bounds.size.width,
            height = self.bounds.size.height,
            minX = kLevelsButtonsLeftBound*width,
            minY = 0,
            xPadding = kLevelsButtonsPaddingX*width,
            yPadding = kLevelsButtonsPaddingY*height,
            buttonWidth = kLevelsButtonsWidth*width,
            buttonHeight = kLevelsButtonsHeight*height;
    
    for(NSUInteger page = 0; page < numPages; page++) {
        for(NSUInteger row = 0; row < kLevelsButtonsNumRows; row++) {
            for(NSUInteger col = 0; col < kLevelsButtonsNumColumns; col++) {
                NSUInteger levelNumber = (page*buttonsPerPage) + (col+1) + (row*kLevelsButtonsNumColumns);
                if(levelNumber > kLevelsNumLevels) break;
                
                CGRect frame = CGRectMake(minX + (col*buttonWidth) + (col*xPadding) + (page*width),
                                          minY + (row*buttonHeight) + (row*yPadding),
                                          buttonWidth,
                                          buttonHeight);
                
                PSLevel *level = [PSLevelManager levelForNumber:levelNumber];
                PSLevelButton *button = [PSLevelButton buttonWithFrame:frame level:level minorFontSize:kLevelsButtonsMinorFontSize majorFontSize:kLevelsButtonsMajorFontSize];
                [button addTarget:self action:@selector(levelSelected:) forControlEvents:UIControlEventTouchUpInside];
                [self.buttonsContainer addSubview:button];
                
                BOOL levelIsUnlocked = levelNumber <= [PSUserData sharedData].lastLevelUnlocked;
                NSInteger numBounces = [[[PSUserData sharedData].scores objectForKey:@(levelNumber)] intValue];
                
                LevelStatus currentLevelStatus;
                if(!levelIsUnlocked)                         currentLevelStatus = LevelStatusLocked;
                else if(levelIsUnlocked && numBounces == -1) currentLevelStatus = LevelStatusNew;
                else if(levelIsUnlocked && numBounces > -1)  currentLevelStatus = LevelStatusCompleted;
                
                NSUInteger starsEarned = [PSLevelManager starsForNumberOfBounces:numBounces onLevel:level.levelNumber];
                
                //Add Star/Lock Graphics
                if(currentLevelStatus == LevelStatusCompleted) { //Add Stars Earned
                    UIImage *emptyStar = [UIImage imageNamed:@"star_black.png"],
                            *filledStar  = [UIImage imageNamed:@"star_white.png"];
                    
                    CGFloat starWidth = kLevelsStarsWidth * width,
                            starHeight = kLevelsStarsHeight * height,
                            xPadding = kLevelsStarsPaddingX * width,
                            yOrigin = CGRectGetMaxY(button.frame) + (kLevelsStarsPaddingY*height);
                    
                    for(int i = 0; i < 3; i++) {
                        CGFloat xOrigin = CGRectGetMinX(button.frame) + (i*starWidth) + (i*xPadding);
                        CGRect frame = CGRectMake(xOrigin, yOrigin, starWidth, starHeight);
                        UIImageView *starView = [[UIImageView alloc] initWithFrame:frame];
                        starView.image = (i+1) <= starsEarned ? filledStar : emptyStar;
                        [self.buttonsContainer addSubview:starView];
                    }
                }
                else if(currentLevelStatus == LevelStatusNew) {} //Add Nothing
                else if(currentLevelStatus == LevelStatusLocked) { //Add Lock
                    CGFloat lockWidth = kLevelsLockWidth * width,
                            lockHeight = kLevelsLockHeight * height,
                            xOrigin = CGRectGetMinX(button.frame)+kLevelsLockPaddingX*width,
                            yOrigin = CGRectGetMinY(button.frame)+kLevelsLockPaddingY*height;
                    
                    UIImageView *lockView = [[UIImageView alloc] initWithFrame:CGRectMake(xOrigin, yOrigin, lockWidth, lockHeight)];
                    lockView.image = [UIImage imageNamed:@"lock.png"];
                    [self.buttonsContainer addSubview:lockView];
                }
            }
        }
    }
}

-(void)backSelected {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHomeKey object:nil];
}
-(void)levelSelected:(PSLevelButton *)button {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoadLevelKey object:button.level];
}

@end
