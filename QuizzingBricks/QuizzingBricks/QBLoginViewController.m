//
//  QBLoginViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-20.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBLoginViewController.h"
#import "QBMenuViewController.h"

@interface QBLoginViewController ()

@end

@implementation QBLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad Login");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(UIStoryboardSegue *)segue
{
    if ([[segue identifier] isEqualToString:@"LogOut"]) {
        [self dismissViewControllerAnimated: YES completion:NULL];
    }
}

- (IBAction)loginButton:(id)sender {
}

@end
