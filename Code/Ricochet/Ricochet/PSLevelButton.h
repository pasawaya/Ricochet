//
//  PSLevelButton.h
//  ricochet
//
//  Created by Philippe Sawaya on 2/7/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSLevel;

@interface PSLevelButton : UIButton

@property (nonatomic, strong) PSLevel *level;

+(instancetype)buttonWithFrame:(CGRect)frame level:(PSLevel *)level minorFontSize:(CGFloat)minorSize majorFontSize:(CGFloat)majorSize;

@end
