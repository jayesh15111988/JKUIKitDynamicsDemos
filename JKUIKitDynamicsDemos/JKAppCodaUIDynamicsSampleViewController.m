//
//  JKAppCodaUIDynamicsSampleViewController.m
//  JKUIKitDynamicsDemos
//
//  Created by Jayesh Kawli Backup on 9/6/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKAppCodaUIDynamicsSampleViewController.h"

@interface JKAppCodaUIDynamicsSampleViewController ()

@property (nonatomic, strong) UIView* ballView;
@property (nonatomic, strong) UIDynamicAnimator* ballDynamicAnimator;
@property (nonatomic, strong) UIGravityBehavior* ballGravity;
@property (nonatomic, strong) UICollisionBehavior* collisionBehaviour;
@property (nonatomic, strong) UIDynamicItemBehavior* ballDynamicItemBehaviour;
@property (nonatomic, strong) UIPushBehavior* ballPushBehaviour;
@property (nonatomic, strong) UIView* bigRectangleView;
@property (nonatomic, strong) UIButton* openCloseMenuButton;
@property (nonatomic, assign) BOOL menuOpen;

@end

@implementation JKAppCodaUIDynamicsSampleViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.title = @"Bouncing Side View";
	_ballView = [[UIView alloc] initWithFrame:CGRectMake (100, 710, 100, 100)];
	_ballView.backgroundColor = [UIColor redColor];
	_ballView.layer.cornerRadius = 50.0f;
	[self.view addSubview:_ballView];

	self.view.backgroundColor = [UIColor blueColor];

	_menuOpen = NO;
	_bigRectangleView = [[UIView alloc]
	    initWithFrame:CGRectMake (-self.view.frame.size.width / 2.0, 64, self.view.frame.size.width / 2.0,
				      self.view.frame.size.height - 100)];
	_bigRectangleView.backgroundColor = [UIColor greenColor];
	[self.view addSubview:_bigRectangleView];

	_ballDynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

	_collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[ _ballView, _bigRectangleView ]];

	_ballDynamicItemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[ _ballView, _bigRectangleView ]];
	_ballDynamicItemBehaviour.elasticity = 0.6;

	_ballGravity = [[UIGravityBehavior alloc] initWithItems:@[ _ballView, _bigRectangleView ]];

	_ballPushBehaviour = [[UIPushBehavior alloc] initWithItems:@[ _ballView, _bigRectangleView ]
							      mode:UIPushBehaviorModeInstantaneous];

	_openCloseMenuButton = [[UIButton alloc] initWithFrame:CGRectMake (200, 230, 100, 44)];
	[_openCloseMenuButton setTitle:@"Open/Close" forState:UIControlStateNormal];
	[_openCloseMenuButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
	[self.view addSubview:_openCloseMenuButton];
	[_openCloseMenuButton addTarget:self
				 action:@selector (openCloseMenu)
		       forControlEvents:UIControlEventTouchUpInside];
}

- (void)openCloseMenu {
	[_ballDynamicAnimator removeAllBehaviors];
	CGFloat backgorundAlpha;

	if (_menuOpen) {
		backgorundAlpha = 1.0;
		_ballGravity.gravityDirection = CGVectorMake (-5.0, 0.0f);
		_ballPushBehaviour.magnitude = -5.0f;
		[_collisionBehaviour addBoundaryWithIdentifier:@"verticalBoundaryLeft"
						     fromPoint:CGPointMake (-self.view.frame.size.width / 2.0, 0.0)
						       toPoint:CGPointMake (-self.view.frame.size.width / 2.0,
									    self.view.frame.size.height)];
	} else {
		backgorundAlpha = 0.4;
		_ballGravity.gravityDirection = CGVectorMake (5.0, 0.0f);
		_ballPushBehaviour.magnitude = 5.0f;
		[_collisionBehaviour addBoundaryWithIdentifier:@"verticalBoundaryRight"
						     fromPoint:CGPointMake (self.view.frame.size.width / 2.0, 0.0)
						       toPoint:CGPointMake (self.view.frame.size.width / 2.0,
									    self.view.frame.size.height)];
	}
	[_ballDynamicAnimator addBehavior:_ballGravity];
	[_ballDynamicAnimator addBehavior:_collisionBehaviour];
	[_ballDynamicAnimator addBehavior:_ballDynamicItemBehaviour];
	[_ballDynamicAnimator addBehavior:_ballPushBehaviour];
	_menuOpen = !_menuOpen;
}

@end
