//
//  PSPauseView.h
//  ricochet
//
//  Created by Philippe Sawaya on 2/17/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSLevel;

@interface PSPauseView : UIView

-(instancetype)initWithFrame:(CGRect)frame level:(PSLevel *)level;

@end
