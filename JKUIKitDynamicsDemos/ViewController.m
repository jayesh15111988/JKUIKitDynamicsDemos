//
//  ViewController.m
//  JKUIKitDynamicsDemos
//
//  Created by Jayesh Kawli Backup on 9/5/15.
//  Copyright (c) 2015 Jayesh Kawli Backup. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UICollisionBehaviorDelegate>

@property (nonatomic, strong) UIDynamicAnimator* dynamicAnimator;
@property (nonatomic, strong) UIGravityBehavior* gravityBehaviour;
@property (nonatomic, strong) UICollisionBehavior* collisionBehaviour;
@property (nonatomic, strong) UIDynamicItemBehavior* dynamicItemBehaviour;
@property (nonatomic, strong) UIPushBehavior* pushBehaviour;
@property (nonatomic, strong) UIView* movingView;
@property (nonatomic, strong) UIView* pushView;
@property (nonatomic, assign) BOOL firstContact;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"Basic UIKit Animation";
	_movingView = [[UIView alloc] initWithFrame:CGRectMake (100, 60, 100, 100)];
	_movingView.backgroundColor = [UIColor greenColor];
	[self.view addSubview:_movingView];

	_pushView = [[UIView alloc] initWithFrame:CGRectMake (0, 0, 50, 50)];
	_pushView.backgroundColor = [UIColor blueColor];
	[self.view addSubview:_pushView];

	_pushBehaviour = [[UIPushBehavior alloc] initWithItems:@[ _pushView ] mode:UIPushBehaviorModeInstantaneous];
	//_pushBehaviour.pushDirection = CGVectorMake (0.0f, 10.0f);
	//_pushBehaviour.magnitude = 10.0f;

	UIView* barrier = [[UIView alloc] initWithFrame:CGRectMake (0, 360, 160, 44)];
	barrier.backgroundColor = [UIColor redColor];
	[self.view addSubview:barrier];

	CGPoint rightEdge = CGPointMake (barrier.frame.origin.x + barrier.frame.size.width, barrier.frame.origin.y);
	CGPoint bottomEdge = CGPointMake (barrier.frame.origin.x + barrier.frame.size.width,
					  barrier.frame.origin.y + barrier.frame.size.height);

	_dynamicItemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[ _movingView ]];
	_dynamicItemBehaviour.elasticity = 0.5;

	_dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	_gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[ _movingView, _pushView ]];
	NSLog (@"X Direction %f Y Direction %f", _gravityBehaviour.gravityDirection.dx,
	       _gravityBehaviour.gravityDirection.dy);
	_collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[ _movingView, _pushView ]];
	_collisionBehaviour.collisionDelegate = self;
	_collisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;

	__block NSInteger animationCount = 0;
	__weak typeof(self) weakSelf = self;
	self.collisionBehaviour.action = ^() {
	  animationCount++;
	  if (animationCount % 5 == 0) {
		  __strong typeof(self) strongSelf = weakSelf;
		  UIView* v = [[UIView alloc] initWithFrame:strongSelf.movingView.frame];
		  [v setBackgroundColor:[UIColor clearColor]];
		  v.transform = strongSelf.movingView.transform;
		  v.layer.borderWidth = 1.0f;
		  v.layer.borderColor = [UIColor blackColor].CGColor;
		  [strongSelf.view addSubview:v];
	  }
	};

	[_collisionBehaviour addBoundaryWithIdentifier:@"rightBarrier"
					     fromPoint:barrier.frame.origin
					       toPoint:rightEdge];
	[_collisionBehaviour addBoundaryWithIdentifier:@"bottomBarrier"
					     fromPoint:CGPointMake (barrier.frame.origin.x,
								    barrier.frame.origin.y + barrier.frame.size.height)
					       toPoint:bottomEdge];
	[_dynamicAnimator addBehavior:_gravityBehaviour];
	[_dynamicAnimator addBehavior:_collisionBehaviour];
	[_dynamicAnimator addBehavior:_dynamicItemBehaviour];
	[_dynamicAnimator addBehavior:_pushBehaviour];
}

- (void)collisionBehavior:(UICollisionBehavior*)behavior
      beganContactForItem:(id<UIDynamicItem>)item
   withBoundaryIdentifier:(id<NSCopying>)identifier
		  atPoint:(CGPoint)point {
	NSLog (@"Boundary contact occurred for identifier %@", identifier);
	if (!_firstContact) {
		_firstContact = YES;
		UIView* additionalView = [[UIView alloc] initWithFrame:CGRectMake (100, 100, 50, 50)];
		additionalView.backgroundColor = [UIColor yellowColor];
		[self.view addSubview:additionalView];
		[_gravityBehaviour addItem:additionalView];
		[_collisionBehaviour addItem:additionalView];
		UIAttachmentBehavior* attachmentBehaviour =
		    [[UIAttachmentBehavior alloc] initWithItem:additionalView attachedToItem:_movingView];
		[_dynamicAnimator addBehavior:attachmentBehaviour];
	}
}

@end
