//
//  JKVibratingViewController.m
//  JKUIKitDynamicsDemos
//
//  Created by Jayesh Kawli Backup on 9/6/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKVibratingViewController.h"

@interface JKVibratingViewController ()

@property (nonatomic, strong) UIView* vibratorContainerView;
@property (nonatomic, strong) UIView* vibratingView;
@property (nonatomic, strong) UIDynamicAnimator* vibratorDynamicAnimator;
@property (nonatomic, strong) UIGravityBehavior* vibratorGravity;
@property (nonatomic, strong) UICollisionBehavior* vibratorCollisionBehaviour;
@property (nonatomic, strong) UIDynamicItemBehavior* vibratingDynamicItemBehaviour;

@end

@implementation JKVibratingViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Vibrating View";

	_vibratorContainerView =
	    [[UIView alloc] initWithFrame:CGRectMake ((self.view.frame.size.width / 2.0) - 50.0, 200, 100, 100)];
	_vibratorContainerView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:_vibratorContainerView];

	_vibratingView = [[UIView alloc] initWithFrame:CGRectMake (25, 25, 50, 50)];
	_vibratingView.backgroundColor = [UIColor redColor];
	[_vibratorContainerView addSubview:_vibratingView];
	_vibratorContainerView.clipsToBounds = YES;

	_vibratorGravity = [[UIGravityBehavior alloc] initWithItems:@[ _vibratingView ]];
	_vibratorGravity.gravityDirection = CGVectorMake (5.0f, 0.0f);

	_vibratorCollisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[ _vibratingView ]];
	_vibratorCollisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;

	_vibratingDynamicItemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[ _vibratingView ]];
	_vibratingDynamicItemBehaviour.elasticity = 1.0;
	//[_vibratingDynamicItemBehaviour addAngularVelocity:M_PI / 2.0 forItem:_vibratingView];

	_vibratorDynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:_vibratorContainerView];
	[_vibratorDynamicAnimator addBehavior:_vibratorCollisionBehaviour];
	[_vibratorDynamicAnimator addBehavior:_vibratorGravity];
	[_vibratorDynamicAnimator addBehavior:_vibratingDynamicItemBehaviour];
}

@end
