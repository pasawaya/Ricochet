//
//  PSGameScene.m
//  Ricochet
//
//  Created by Philippe Sawaya on 2/1/16.
//  Copyright © 2016 Phiji. All rights reserved.
//

#import "PSGameScene.h"
#import "PSPuck.h"
#import "PSWall.h"
#import "PSEndView.h"
#import "Constants.h"
#import "PSPositionSlider.h"
#import "PSLevel.h"
#import "PSLevelManager.h"
#import "PSPauseView.h"
#import "PSGameNode.h"
#import "PSUserData.h"

@interface PSGameScene ()

@property (nonatomic, assign) BOOL hasWon;
@property (nonatomic, assign) BOOL isPickingAngle;
@property (nonatomic, strong) PSPuck *puck;
@property (nonatomic, strong) PSPositionSlider *slider;
@property (nonatomic, strong) PSEndView *endView;
@property (nonatomic, strong) PSLevel *currentLevel;
@property (nonatomic, strong) UIView *arrowLine;
@property (nonatomic, strong) SKSpriteNode *goalZone;
@property (nonatomic, assign) NSUInteger numBounces;

@end

@implementation PSGameScene

#pragma mark - Initialization -
-(instancetype)initWithSize:(CGSize)size level:(PSLevel *)level{
    if(self = [super initWithSize:size]) {
        self.currentLevel = level;
        self.hasWon = NO;
        self.isPickingAngle = NO;
        self.scaleMode = SKSceneScaleModeAspectFit;
        self.physicsWorld.gravity = CGVectorMake(0, 0);
        self.physicsWorld.contactDelegate = self;
        self.backgroundColor = [Constants backgroundColor];
        self.numBounces = 0;
    }
    
    return self;
}

-(void)didMoveToView:(SKView *)view {
    [self createGoalZone];
    [self createWalls];
    [self createSlider];
    [self createPuck];
    [self createArrow];
    [self createEndView];
    
    [self loadLevel:self.currentLevel];
}

-(void)resetForLevel:(PSLevel *)level {
    self.hasWon = NO;
    self.isPickingAngle = NO;
    self.numBounces = 0;
    
    [self resetSlider];
    [self resetPuck];
    [self setWallPhysics];
    
    [self clearCurrentLevel];
    [self loadLevel:level];
}

#pragma mark - Clean-Up -
-(void)clearCurrentLevel {
    for(SKNode *child in self.children) {
        if([child isKindOfClass:[PSGameNode class]]) {
            [child removeActionForKey:kAnimationMovingNodeKey];
            [child removeFromParent];
        }
        else if(child.children.count > 0) {
            for(NSUInteger i = 0; i < child.children.count; i++) {
                if([child.children[i] isKindOfClass:[PSGameNode class]]) {
                    [child removeFromParent];
                }
            }
        }
    }
}

#pragma mark - UI Intitialization -
#pragma mark Level
-(void)addChild:(SKNode *)node {
    [super addChild:node];
}

-(void)loadLevel:(PSLevel *)level {
    self.currentLevel = level;
    [self.currentLevel reset];
    
    for(SKNode *node in self.currentLevel.components) {
        [self addChild:node];
        
        if([node isKindOfClass:[PSGameNode class]] && [(PSGameNode *)node action]) {
            [(PSGameNode *)node beginAction];
        }
    }
}

#pragma mark End View
-(void)createEndView {
    CGFloat width = self.view.bounds.size.width,
            height = self.view.bounds.size.height;
    
    CGFloat endViewWidth = 0.7 * self.view.bounds.size.width,
            endViewheight = 0.6 * self.view.bounds.size.height;
    
    CGRect frame = CGRectMake((width-endViewWidth)/2, (height-endViewheight)/2, endViewWidth, endViewheight);
    self.endView = [[PSEndView alloc] initWithFrame:frame level:self.currentLevel];
    self.endView.alpha = 0;
    [self.view addSubview:self.endView];
}

#pragma mark Puck
-(void)createPuck {
    CGFloat height = self.view.bounds.size.height;
    CGPoint puckPosition = CGPointMake([self.slider thumbXPosition], height-CGRectGetMidY(self.slider.frame));
    self.puck = [PSPuck puckWithPosition:puckPosition size:[Constants puckSize]];
    [self addChild:self.puck];
}

-(void)resetPuck {
    CGPoint position = CGPointMake([self.slider thumbXPosition], [Constants height]-CGRectGetMidY(self.slider.frame));
    self.puck.physicsBody.velocity = CGVectorMake(0, 0);
    
    SKPhysicsBody *puckTemp = self.puck.physicsBody;
    self.puck.physicsBody = nil;
    self.puck.position = position;
    self.puck.physicsBody = puckTemp;
}

-(void)createArrow {
    self.arrowLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.arrowLine.hidden = YES;
    self.arrowLine.layer.anchorPoint = CGPointMake(0, 0);
    self.arrowLine.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.arrowLine];
}

#pragma mark Slider
-(void)createSlider {
    CGFloat width  = self.view.bounds.size.width,
            height = self.view.bounds.size.height;
    
    CGFloat sliderWidth = width/1.2, sliderHeight = 10.0;
    CGRect frame = CGRectMake((width-sliderWidth)/2.0f, height-sliderHeight*5, sliderWidth, sliderHeight);
    
    self.slider = [[PSPositionSlider alloc] initWithFrame:frame thumbSize:[Constants puckSize]];
    [self.slider addTarget:self action:@selector(sliderValueUpdated:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderLifted:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.slider];
}

-(void)resetSlider {
    self.slider.hidden = NO;
    self.slider.value = CGRectGetMidX(self.slider.frame);
    self.slider.mode = SliderModePosition;
}

#pragma mark Walls
-(void)createWalls {
    CGFloat width  = self.view.bounds.size.width,
            height = self.view.bounds.size.height;
    
    CGSize wallSize = CGSizeMake(kStrokeWidth, height);
    CGPoint leftWallCenter  = CGPointMake(wallSize.width/2, height/2),
            rightWallCenter = CGPointMake(width-wallSize.width/2, height/2);
    
    PSWall *leftWall = [PSWall wallWithPosition:leftWallCenter size:wallSize];
    PSWall *rightWall = [PSWall wallWithPosition:rightWallCenter size:wallSize];
    [self addChild:leftWall];
    [self addChild:rightWall];
    
    [self setWallPhysics];
}

-(void)setWallPhysics {
    CGFloat width  = self.view.bounds.size.width,
            height = self.view.bounds.size.height;
    
    CGSize wallSize = CGSizeMake(kStrokeWidth, height);
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(wallSize.width, 0, width-2*wallSize.width, height)];
    self.physicsBody.categoryBitMask = ColliderTypeWall;
}

#pragma mark Goal Zone
-(void)createGoalZone {
    CGFloat width  = self.view.bounds.size.width,
            height = self.view.bounds.size.height;
    
    CGFloat goalZoneHeight = height * kGoalZoneHeightRatio;
    
    self.goalZone = [SKSpriteNode spriteNodeWithColor:[Constants goalZoneColor] size:CGSizeMake(width, goalZoneHeight)];
    self.goalZone.position = CGPointMake(width/2, height-(goalZoneHeight/2));
    [self addChild:self.goalZone];
    
    SKSpriteNode *goalZoneLine = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(width, 4)];
    goalZoneLine.position = CGPointMake(width/2, height-(height*kGoalZoneHeightRatio));
    [self addChild:goalZoneLine];
}

#pragma mark - Game Logic -
-(void)update:(NSTimeInterval)currentTime {
    if(!self.hasWon && CGRectGetMinY(self.puck.frame) > CGRectGetMinY(self.goalZone.frame)) {
        [self endGame];
    }
}

-(void)endGame {
    //Save Score + Unlock Next Level
    [[PSUserData sharedData].scores setObject:@(self.numBounces) forKey:@(self.currentLevel.levelNumber)];
    if(self.currentLevel.levelNumber == [PSUserData sharedData].lastLevelUnlocked) {
        [PSUserData sharedData].lastLevelUnlocked++;
    }
    [[PSUserData sharedData] save];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationResetLevelSelectionKey object:nil];
    
    //Animate Puck Color and Slow Puck Down
    SKAction *colorChange = [SKAction colorizeWithColor:[Constants green] colorBlendFactor:1.0 duration:0.2];
    [self.puck runAction:colorChange];
    
    CGFloat slowDownFactor = 0.1;
    self.puck.physicsBody.velocity = CGVectorMake(slowDownFactor*self.puck.physicsBody.velocity.dx, slowDownFactor*self.puck.physicsBody.velocity.dy);
    
    CGFloat width = self.view.bounds.size.width, height = self.view.bounds.size.height;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0,
                                                                          height-(height*kGoalZoneHeightRatio),
                                                                          width,
                                                                          height*kGoalZoneHeightRatio)];
    self.physicsBody.categoryBitMask = ColliderTypeBumper;
    
    //Show "Completed" Pop-up
    [self.endView showForLevel:self.currentLevel];
    
    self.hasWon = YES;
}

#pragma mark - Angle -
-(void)showArrowToPoint:(CGPoint)point {
    CGPoint thumb = CGPointMake([self.slider thumbXPosition], CGRectGetMidY(self.slider.frame));
    
    CGFloat dx = point.x - thumb.x,
            dy = point.y - thumb.y;
    
    CGFloat padding = 5,
            width = 1,
            height = sqrtf((dx*dx)+(dy*dy))-padding;
    
    if(height > 100) height = 150;
    
    double angle = [self angleBetweenPoint:thumb andPoint:point];
    if      (angle > 0 && angle < M_PI/2)  angle = M_PI/2;  //Essentially limit angle
    else if (angle < 0 && angle > -M_PI/2) angle = -M_PI/2; //between 0 and 180 degrees
    
    self.arrowLine.frame = CGRectMake(thumb.x, thumb.y, width, height);
    self.arrowLine.bounds = CGRectMake(0, 0, width, height);
    self.arrowLine.transform = CGAffineTransformMakeRotation(angle);
}
-(CGFloat)angleBetweenPoint:(CGPoint)p1 andPoint:(CGPoint)p2 {
    CGFloat dx = p2.x-p1.x,
            dy = p2.y-p1.y;
    return atan2(dy, dx)-M_PI/2;
}

#pragma mark - Touch Delegate -
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self.slider.mode == SliderModeAngle) {
        CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
        self.arrowLine.hidden = NO;
        [self showArrowToPoint:point];
    }
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self.slider.mode == SliderModeAngle) {
        CGPoint point = [[[event allTouches] anyObject] locationInView:self.view];
        [self showArrowToPoint:point];
    }
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if(self.slider.mode == SliderModeAngle) {
        self.slider.mode = SliderModePlay;
        self.arrowLine.hidden = YES;
        
        CGPoint point = [[[event allTouches] anyObject] locationInView:self.view],
                thumb = CGPointMake([self.slider thumbXPosition], CGRectGetMidY(self.slider.frame));
        
        CGFloat rads = [self angleBetweenPoint:thumb andPoint:point];
        if      (rads > 0 && rads < M_PI/2)  rads = M_PI/2;
        else if (rads < 0 && rads > -M_PI/2) rads = -M_PI/2;
        
        
        CGFloat arrowLength = MAX(self.arrowLine.frame.size.height, self.arrowLine.frame.size.width),
                angle = -rads-(M_PI/2),
                  mag = 70*(arrowLength/150),
                 xMag = mag*cos(angle),
                 yMag = mag*sin(angle);
        
        [self.puck.physicsBody applyImpulse:CGVectorMake(xMag, yMag)];
    }
}

#pragma mark - PSPositionSlider Delegate -
-(void)sliderValueUpdated:(PSPositionSlider *)slider {
    self.puck.position = CGPointMake([slider thumbXPosition], [Constants height]-CGRectGetMidY(self.slider.frame));
    NSLog(@"update");
}
-(void)sliderTouchDown:(PSPositionSlider *)slider {
    self.slider.initialValue = self.slider.value;
    if(self.slider.mode == SliderModeAngle) {
        self.isPickingAngle = YES;
    }
}
-(void)sliderLifted:(PSPositionSlider *)slider {
    NSLog(@"lift");
    if(self.slider.mode == SliderModePosition) {
        CGFloat delta = fabs(self.slider.value-self.slider.initialValue);
        if(delta < kSliderTapThreshold) {
            self.slider.hidden = YES;
            self.slider.mode = SliderModeAngle;
            self.puck.position = CGPointMake([slider thumbXPosition], [Constants height]-CGRectGetMidY(self.slider.frame));
        }
        self.slider.initialValue = INT_MAX;
    }
}

#pragma mark - SKPhysicsContact Delegate -
-(void)didBeginContact:(SKPhysicsContact *)contact {    
    if(contact.bodyA.categoryBitMask == ColliderTypeObstacle ||
        contact.bodyB.categoryBitMask == ColliderTypeObstacle) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRetryKey object:nil];
    }
    
    if(contact.bodyA.categoryBitMask == ColliderTypeWall ||
       contact.bodyB.categoryBitMask == ColliderTypeWall ||
       contact.bodyA.categoryBitMask == ColliderTypeBumper ||
       contact.bodyB.categoryBitMask == ColliderTypeBumper) {
        self.numBounces++;
    }
}

#pragma mark - Pause View -
-(void)pause {
    CGFloat width = self.view.bounds.size.width,
            height = self.view.bounds.size.height;
    
    CGFloat endViewWidth  = 0.7 * self.view.bounds.size.width,
    endViewheight = 0.6 * self.view.bounds.size.height;
    
    CGRect frame = CGRectMake((width-endViewWidth)/2, (height-endViewheight)/2, endViewWidth, endViewheight);
    
    PSPauseView *pauseView = [[PSPauseView alloc] initWithFrame:frame level:self.currentLevel];
    pauseView.alpha = 0;
    [self.view addSubview:pauseView];
    
    [UIView animateWithDuration:kAnimationDuration animations:^{
        pauseView.alpha = 1;
    }];
}

@end
