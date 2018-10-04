//
//  PSEndView.h
//  ricochet
//
//  Created by Philippe Sawaya on 2/3/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PSLevel;

@interface PSEndView : UIView

-(instancetype)initWithFrame:(CGRect)frame level:(PSLevel *)level;
-(void)showForLevel:(PSLevel *)level;

@end
