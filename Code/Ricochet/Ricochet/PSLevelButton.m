//
//  PSLevelButton.m
//  ricochet
//
//  Created by Philippe Sawaya on 2/7/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSLevelButton.h"
#import "Constants.h"
#import "PSLevel.h"

@implementation PSLevelButton

+(instancetype)buttonWithFrame:(CGRect)frame level:(PSLevel *)level minorFontSize:(CGFloat)minorSize majorFontSize:(CGFloat)majorSize {
    PSLevelButton *button = [super buttonWithType:UIButtonTypeCustom];
    button.level = level;
    button.frame = frame;
    
    NSString *buttonTitle = [NSString stringWithFormat:@"%lu", (unsigned long)level.levelNumber];
    
    
    [button setBackgroundImage:[UIImage imageNamed:@"level_base.png"] forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    CGFloat fontSize = majorSize;
    if([NSString stringWithFormat:@"%lu", (unsigned long)level.levelNumber].length > 1) {
        fontSize = minorSize;
    }
    
    [button.titleLabel setFont:[UIFont fontWithName:kFontName size:fontSize]];
    
    return button;
}

@end