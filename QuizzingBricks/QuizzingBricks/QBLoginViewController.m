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

- (IBAction)login:(id)sender {
    NSLog(@"Username: %@, Password: %@", self.usernameInput.text, self.passwordInput.text);
    [self performSegueWithIdentifier:@"loginSegue" sender:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.usernameInput) || (textField == self.passwordInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
