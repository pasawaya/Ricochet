//
//  Constants.h
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Constants : NSObject

typedef NS_ENUM(u_int32_t, ColliderType) {
    ColliderTypeBumper = 1,
    ColliderTypePuck = 2,
    ColliderTypeObstacle = 4,
    ColliderTypeWall = 8
};

extern NSString * const kFontName;

extern CGFloat const kSliderTapThreshold;
extern CGFloat const kStrokeWidth;
extern CGFloat const kGoalZoneHeightRatio;

//Levels Screen Constants
extern CGFloat const kLevelsButtonsLeftBound;
extern CGFloat const kLevelsButtonsTopBound;
extern CGFloat const kLevelsButtonsPaddingX;
extern CGFloat const kLevelsButtonsPaddingY;
extern CGFloat const kLevelsButtonsWidth;
extern CGFloat const kLevelsButtonsHeight;
extern CGFloat const kLevelsStarsWidth;
extern CGFloat const kLevelsStarsHeight;
extern CGFloat const kLevelsStarsLeftBound;
extern CGFloat const kLevelsStarsPaddingX;
extern CGFloat const kLevelsStarsPaddingY;
extern CGFloat const kLevelsLockWidth;
extern CGFloat const kLevelsLockHeight;
extern CGFloat const kLevelsLockPaddingX;
extern CGFloat const kLevelsLockPaddingY;
extern NSUInteger const kLevelsNumLevels;
extern NSUInteger const kLevelsButtonsNumRows;
extern NSUInteger const kLevelsButtonsNumColumns;

//Notification Keys
extern NSString * const kNotificationNextKey;
extern NSString * const kNotificationHomeKey;
extern NSString * const kNotificationPlayKey;
extern NSString * const kNotificationLevelsKey;
extern NSString * const kNotificationLeaderboardKey;
extern NSString * const kNotificationStoreKey;
extern NSString * const kNotificationSettingsKey;
extern NSString * const kNotificationLoadLevelKey;
extern NSString * const kNotificationRetryKey;
extern NSString * const kNotificationResetLevelSelectionKey;

//Data Keys
extern NSString * const kUserDataScoresKey;
extern NSString * const kUserDataLastLevelOpenedKey;
extern NSString * const kUserDataLastLevelUnlockedKey;

//Font Sizes
extern CGFloat const kLevelsButtonsMajorFontSize;
extern CGFloat const kLevelsButtonsMinorFontSize;
extern CGFloat const kEndViewLevelIconMajorFontSize;
extern CGFloat const kEndViewLevelIconMinorFontSize;

//Animation
extern NSString * const kAnimationMovingNodeKey;
extern CGFloat const kAnimationDuration;

//Parser Keys
extern NSString * const kObstacleKey;
extern NSString * const kBumperKey;
extern NSString * const kMovingBumperKey;
extern NSString * const kMovingObstacleKey;
extern NSString * const kMultipleMovingBumperKey;
extern NSString * const kMultipleMovingObstacleKey;
extern NSString * const kRotatingObstacleKey;
extern NSString * const kRotatingBumperKey;
extern NSString * const kDiagonalObstacleKey;
extern NSString * const kDiagonalBumperKey;
extern NSString * const kExternallyRotatingObstacleKey;
extern NSString * const kExternallyRotatingBumperKey;
extern NSString * const kMovingDiagonalObstacleKey;
extern NSString * const kMovingDiagonalBumperKey;
extern NSString * const kRotatingMovingObstacleKey;
extern NSString * const kRotatingMovingBumperKey;

//Dimensions
+(CGFloat)width;
+(CGFloat)height;
+(CGSize)puckSize;

//Colors
+(UIColor *)gray;
+(UIColor *)blue;
+(UIColor *)red;
+(UIColor *)green;

+(UIColor *)goalLineColor;
+(UIColor *)goalZoneColor;
+(UIColor *)backgroundColor;
+(UIColor *)obstacleColor;
+(UIColor *)bumperColor;

@end
