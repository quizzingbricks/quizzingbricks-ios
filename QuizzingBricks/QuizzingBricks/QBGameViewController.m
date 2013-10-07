//
//  QBGameViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-22.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBGameViewController.h"
#import "QBBoardView.h"

@interface QBGameViewController ()

@end

@implementation QBGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    QBBoardView *gameView = [[QBBoardView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x+10, self.view.bounds.origin.y+100, self.view.bounds.size.width+150, self.view.bounds.size.height)];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
    [scrollView setContentSize:CGSizeMake(self.view.bounds.size.width+150, self.view.bounds.size.height)];
    [scrollView addSubview:gameView];
    [self.view addSubview:scrollView];
    [self.view setNeedsDisplay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
