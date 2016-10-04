//
//  JKSnappingViewDemoViewController.m
//  JKUIKitDynamicsDemos
//
//  Created by Jayesh Kawli Backup on 9/5/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "JKSnappingViewDemoViewController.h"

@interface JKSnappingViewDemoViewController ()

@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UIButton* snapViewHideButton;

@property (nonatomic, strong) UIView* snapView;
@property (nonatomic, strong) UIView* v;
@property (nonatomic, strong) UIDynamicAnimator* dynamicAnimator;
@property (nonatomic, strong) UISnapBehavior* snapBehaviour;
@property (nonatomic, strong) UIDynamicAnimator* dynamicAnimator1;
@property (nonatomic, strong) UISnapBehavior* snapBehaviour1;

@property (nonatomic, strong) UIGravityBehavior* gravityBehaviour;
@property (nonatomic, strong) UIDynamicItemBehavior* dynamicItemBehaviour;
@property (nonatomic, strong) UICollisionBehavior* collisionBehaviour;

@end

@implementation JKSnappingViewDemoViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Snapping View";

	_dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	_button = [[UIButton alloc] initWithFrame:CGRectMake (100, 100, 200, 44)];
	[_button setTitle:@"Press Me For snap" forState:UIControlStateNormal];
	[_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[self.view addSubview:_button];
	[_button addTarget:self action:@selector (showSnapView) forControlEvents:UIControlEventTouchUpInside];
	_snapView = [[UIView alloc] initWithFrame:CGRectMake (0, 0, 200, 100)];
	_snapView.backgroundColor = [UIColor greenColor];

	_snapViewHideButton = [[UIButton alloc] initWithFrame:CGRectMake (50, 50, 100, 44)];
	[_snapViewHideButton setTitle:@"hide" forState:UIControlStateNormal];
	[_snapViewHideButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[_snapView addSubview:_snapViewHideButton];
	[_snapViewHideButton addTarget:self
				action:@selector (hideSnapView)
		      forControlEvents:UIControlEventTouchUpInside];

	_dynamicItemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[ _snapView ]];

	_gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[ _snapView ]];
	_gravityBehaviour.gravityDirection = CGVectorMake (0.0, 10.0);
	__weak typeof(self) weakSelf = self;
	_gravityBehaviour.action = ^() {
	  __strong typeof(self) strongSelf = weakSelf;
	  if (strongSelf.snapView.frame.origin.y >= self.view.frame.size.height) {
		  [strongSelf.dynamicAnimator removeAllBehaviors];
		  [strongSelf.snapView removeFromSuperview];
		  strongSelf.snapView.transform = CGAffineTransformIdentity;
		  strongSelf.snapView.frame = CGRectMake (0, 0, 200, 100);
		  NSLog (@"%@", NSStringFromCGRect (strongSelf.snapView.frame));
	  }
	};

	_snapView.transform = CGAffineTransformIdentity;
	_snapView.layer.transform = CATransform3DIdentity;
	_snapBehaviour = [[UISnapBehavior alloc] initWithItem:_snapView snapToPoint:self.view.center];
	_snapBehaviour.damping = 0.6;

	_collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[ _snapView ]];
	_collisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;
    
    self.v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.v.backgroundColor = [UIColor redColor];
    self.dynamicAnimator1 = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.snapBehaviour1 = [[UISnapBehavior alloc] initWithItem:self.v snapToPoint:CGPointMake(300, 300)];
    self.snapBehaviour1.damping = 0.6;
    [self.view addSubview:self.v];
    [self.dynamicAnimator1 addBehavior:self.snapBehaviour1];
}

- (void)showSnapView {
	[self.view addSubview:_snapView];
	[_dynamicAnimator addBehavior:_snapBehaviour];
}

- (void)hideSnapView {
	[_dynamicAnimator removeAllBehaviors];
	[_dynamicItemBehaviour addAngularVelocity:M_PI / 2.0 forItem:_snapView];
	[_dynamicAnimator addBehavior:_gravityBehaviour];
	[_dynamicAnimator addBehavior:_dynamicItemBehaviour];
}

@end
