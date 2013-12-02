//
//  QBAddFriendViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-14.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBAddFriendViewController.h"

@interface QBAddFriendViewController ()

@end

@implementation QBAddFriendViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailInput) {
        [textField resignFirstResponder];
    }
    return YES;
}

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
    NSLog(@"AddFriend didLoad");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        NSLog(@"FriendEmail:%@",[self.emailInput text]);
        self.email = self.emailInput.text;
    }
}

@end
