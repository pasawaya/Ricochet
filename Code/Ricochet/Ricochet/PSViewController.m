//
//  ViewController.m
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "PSViewController.h"
#import "PSGameScene.h"
#import "Constants.h"
#import "PSHomeView.h"
#import "PSLevelsView.h"
#import "PSLevelManager.h"
#import "PSGameView.h"
#import "PSSettingsView.h"
#import "PSStoreView.h"
#import "PSUserData.h"

@interface PSViewController ()

@property (nonatomic, strong) PSGameView *gameView;
@property (nonatomic, strong) PSHomeView *homeView;
@property (nonatomic, strong) PSLevelsView *levelsView;
@property (nonatomic, strong) PSSettingsView *settingsView;
@property (nonatomic, strong) PSStoreView *storeView;

@end

@implementation PSViewController

#pragma mark - Initialization -
-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextLevel) name:kNotificationNextKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(play) name:kNotificationPlayKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLevelsView) name:kNotificationLevelsKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLevel:) name:kNotificationLoadLevelKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(retry) name:kNotificationRetryKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHomeView) name:kNotificationHomeKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSettingsView) name:kNotificationSettingsKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStoreView) name:kNotificationStoreKey object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetLevelSelectionButtons) name:kNotificationResetLevelSelectionKey object:nil];
    
//    NSUInteger lastLevel = [PSUserData sharedData].lastLevelUnlocked;
    self.gameView = [[PSGameView alloc] initWithFrame:self.view.frame level:[PSLevelManager levelForNumber:1]];
    [self.view addSubview:self.gameView];
    
    self.levelsView = [[PSLevelsView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.levelsView];
    
    self.settingsView = [[PSSettingsView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.settingsView];
    
    self.storeView = [[PSStoreView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.storeView];
    
    self.homeView = [[PSHomeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.homeView];
    [self.homeView runGIF];
}

#pragma mark - Button Actions -
-(void)play {
    [self.gameView reshowCurrentLevel];
    [self showView:self.gameView];
}

-(void)showLevelsView {
    [self showView:self.levelsView];
}

-(void)showSettingsView {
    [self showView:self.settingsView];
}

-(void)showStoreView {
    [self showView:self.storeView];
}

-(void)showLevel:(NSNotification *)notif {
    [self.gameView showLevel:(PSLevel *)notif.object];
    [self showView:self.gameView];}

-(void)nextLevel {
    [self.gameView showNextLevel];
}

-(void)retry {
    [self.gameView reshowCurrentLevel];
}

-(void)showHomeView {
    [self showView:self.homeView];
    [self.homeView runGIF];
}

-(void)resetLevelSelectionButtons {
    [self.levelsView setupButtons];
}

#pragma mark - Animation -
-(void)showView:(UIView *)view {
    
    /*
        Split Top View in Following Situations:
            - Home -> Anything 
            - Level Selection -> Game
     */
    
    //Get Top View
    UIView *topView = [self.view.subviews lastObject];
    
    //If on Home page, split home page
    if([topView isKindOfClass:[PSHomeView class]] ||
       ([topView isKindOfClass:[PSLevelsView class]] &&
        [view isKindOfClass:[PSGameView class]])) {
           
        //Bring destination view to second in view hierarchy
        [self.view bringSubviewToFront:view];
        [self.view bringSubviewToFront:topView];
        [self splitView:topView];
    }
    
    //If not, recombine home page
    else {
        //Bring destination view to top of view hierarchy
        [self combineInView:view];
    }
}

-(void)combineInView:(UIView *)view {
    //Get Snapshot of View
    UIImage *image = [PSViewController imageFromView:view];
    
    //Get Separate Halves as Images
    CGFloat imageWidth = image.size.width,
           imageHeight = image.size.height;
    
    CGRect leftImageFrame = CGRectMake(0, 0, imageWidth, 2*imageHeight);
    CGRect rightImageFrame = CGRectMake(imageWidth, 0, imageWidth, 2*imageHeight);
    
    CGImageRef left = CGImageCreateWithImageInRect(image.CGImage, leftImageFrame);
    CGImageRef right = CGImageCreateWithImageInRect(image.CGImage, rightImageFrame);
    
    UIImage *leftImage = [UIImage imageWithCGImage:left scale:1 orientation:UIImageOrientationUp];
    UIImage *rightImage = [UIImage imageWithCGImage:right scale:1 orientation:UIImageOrientationUp];
    
    CGImageRelease(left);
    CGImageRelease(right);
    
    //Add Halves to Screen
    CGRect leftImageViewFrame = CGRectMake(-imageWidth/2, 0, imageWidth/2, imageHeight),
          rightImageViewFrame = CGRectMake([Constants width], 0, imageWidth/2, imageHeight);
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:leftImage];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:rightImage];
    leftImageView.frame = leftImageViewFrame;
    rightImageView.frame = rightImageViewFrame;
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:leftImageView];
    [self.view addSubview:rightImageView];
    [self.view bringSubviewToFront:leftImageView];
    [self.view bringSubviewToFront:rightImageView];
    
    //Animate In Halves
    CGRect leftToFrame = CGRectMake(0, 0, imageWidth/2, imageHeight),
          rightToFrame = CGRectMake(imageWidth/2, 0, imageWidth/2, imageHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        leftImageView.frame = leftToFrame;
        rightImageView.frame = rightToFrame;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:view];
        [self.view sendSubviewToBack:leftImageView];
        [self.view sendSubviewToBack:rightImageView];
    }];
}

-(void)splitView:(UIView *)view {
    //Get Snapshot of View
    UIImage *image = [PSViewController imageFromView:view];
    
    //Get Separate Halves as Images
    CGFloat imageWidth = image.size.width,
            imageHeight = image.size.height;
    
    CGRect leftImageFrame = CGRectMake(0, 0, imageWidth, 2*imageHeight);
    CGRect rightImageFrame = CGRectMake(imageWidth, 0, imageWidth, 2*imageHeight);
    
    CGImageRef left = CGImageCreateWithImageInRect(image.CGImage, leftImageFrame);
    CGImageRef right = CGImageCreateWithImageInRect(image.CGImage, rightImageFrame);
    
    UIImage *leftImage = [UIImage imageWithCGImage:left scale:1 orientation:UIImageOrientationUp];
    UIImage *rightImage = [UIImage imageWithCGImage:right scale:1 orientation:UIImageOrientationUp];

    CGImageRelease(left);
    CGImageRelease(right);
    
    //Add Halves to Screen
    CGRect leftImageViewFrame = CGRectMake(0, 0, imageWidth/2, imageHeight),
           rightImageViewFrame = CGRectMake(imageWidth/2, 0, imageWidth/2, imageHeight);
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithImage:leftImage];
    UIImageView *rightImageView = [[UIImageView alloc] initWithImage:rightImage];
    leftImageView.frame = leftImageViewFrame;
    rightImageView.frame = rightImageViewFrame;
    leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:leftImageView];
    [self.view addSubview:rightImageView];
    
    //Hide Actual View
    [self.view sendSubviewToBack:view];
    
    //Animate Out Halves
    CGRect leftToFrame = CGRectMake(-imageWidth/2, 0, imageWidth/2, imageHeight),
          rightToFrame = CGRectMake(imageWidth, 0, imageWidth/2, imageHeight);
    [UIView animateWithDuration:kAnimationDuration animations:^{
        leftImageView.frame = leftToFrame;
        rightImageView.frame = rightToFrame;
    } completion:^(BOOL finished) {
        [self.view sendSubviewToBack:leftImageView];
        [self.view sendSubviewToBack:rightImageView];
    }];    
}

#pragma mark - Animation Helpers -
+(UIImage *)imageFromView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Clean-Up -
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
