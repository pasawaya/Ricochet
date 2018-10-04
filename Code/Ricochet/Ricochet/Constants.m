//
//  Constants.m
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "Constants.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@implementation Constants

const NSUInteger kLevelsNumLevels = 59;

const CGFloat kSliderTapThreshold = 5.f;
const CGFloat kGoalZoneHeightRatio = .111111111; // (1/9)
const CGFloat kStrokeWidth = 7.f;

const CGFloat kLevelsButtonsLeftBound = 0.216;
const CGFloat kLevelsButtonsTopBound = 0.2833;
const CGFloat kLevelsButtonsPaddingX = 0.08;
const CGFloat kLevelsButtonsPaddingY = 0.065;
const CGFloat kLevelsButtonsWidth = 0.136;
const CGFloat kLevelsButtonsHeight = 0.07646;
const CGFloat kLevelsStarsLeftBound = 0.228;
const CGFloat kLevelsStarsWidth = 0.0333;
const CGFloat kLevelsStarsHeight = 0.01799;
const CGFloat kLevelsStarsPaddingX = 0.006667;
const CGFloat kLevelsStarsPaddingY = 0.00375;
const CGFloat kLevelsLockWidth = 0.064;
const CGFloat kLevelsLockHeight = 0.04722638681;
const CGFloat kLevelsLockPaddingX = 0.094;
const CGFloat kLevelsLockPaddingY = 0.0487;
const NSUInteger kLevelsButtonsNumRows = 5;
const NSUInteger kLevelsButtonsNumColumns = 3;

NSString * const kFontName = @"AvenirNext-HeavyItalic";

NSString * const kObstacleKey = @"Obstacle";
NSString * const kBumperKey = @"Bumper";
NSString * const kMovingBumperKey = @"MBumper";
NSString * const kMovingObstacleKey= @"MObstacle";
NSString * const kMultipleMovingBumperKey = @"MMBumper";
NSString * const kMultipleMovingObstacleKey= @"MMObstacle";
NSString * const kRotatingObstacleKey = @"RObstacle";
NSString * const kRotatingBumperKey = @"RBumper";
NSString * const kDiagonalObstacleKey = @"DObstacle";
NSString * const kDiagonalBumperKey = @"DBumper";
NSString * const kExternallyRotatingObstacleKey = @"RRObstacle";
NSString * const kExternallyRotatingBumperKey = @"RRBumper";
NSString * const kMovingDiagonalObstacleKey = @"DMObstacle";
NSString * const kMovingDiagonalBumperKey = @"DMBumper";
NSString * const kRotatingMovingObstacleKey = @"RMObstacle";
NSString * const kRotatingMovingBumperKey = @"RMBumper";

NSString * const kNotificationNextKey = @"notif_next";
NSString * const kNotificationHomeKey = @"notif_home";
NSString * const kNotificationResetLevelSelectionKey = @"notif_reset_level_buttons";
NSString * const kNotificationPlayKey = @"notif_play";
NSString * const kNotificationLevelsKey = @"notif_levels";
NSString * const kNotificationLeaderboardKey = @"notif_leaderboard";
NSString * const kNotificationStoreKey = @"notif_store";
NSString * const kNotificationSettingsKey = @"notif_settings";
NSString * const kNotificationLoadLevelKey = @"notif_load_levels";
NSString * const kNotificationRetryKey = @"notif_retry";

NSString * const kUserDataScoresKey = @"data_scores_key";
NSString * const kUserDataLastLevelOpenedKey = @"data_level_opened_key";
NSString * const kUserDataLastLevelUnlockedKey = @"data_level_unlocked_key";

const CGFloat kLevelsButtonsMajorFontSize = 34;
const CGFloat kLevelsButtonsMinorFontSize = 23;
const CGFloat kEndViewLevelIconMajorFontSize = 70;
const CGFloat kEndViewLevelIconMinorFontSize = 50;

NSString * const kAnimationMovingNodeKey = @"anim_move_node";
const CGFloat kAnimationDuration = 0.6f;

+(CGFloat)width {return [UIScreen mainScreen].bounds.size.width;}
+(CGFloat)height {return [UIScreen mainScreen].bounds.size.height;}
+(CGSize)puckSize {return CGSizeMake(50-kStrokeWidth, 50-kStrokeWidth);}

+(UIColor *)gray {return UIColorFromRGB(0x1e1e1e);}
+(UIColor *)blue {return UIColorFromRGB(0x498eff);}
+(UIColor *)red {return UIColorFromRGB(0xff0000);}
+(UIColor *)green {return UIColorFromRGB(0x70be0b);}

+(UIColor *)goalLineColor {return UIColorFromRGB(0xffffff);}
+(UIColor *)goalZoneColor {return UIColorFromRGB(0x7a7a7a);}
+(UIColor *)backgroundColor {return UIColorFromRGB(0x222222);}
+(UIColor *)obstacleColor {return UIColorFromRGB(0xff7e00);}
+(UIColor *)bumperColor {return UIColorFromRGB(0x498eff);}

@end
