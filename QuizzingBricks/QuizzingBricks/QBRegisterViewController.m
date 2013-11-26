//
//  QBRegisterViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-08.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBRegisterViewController.h"
#import "QBCommunicationManager.h"
#import "QBDataManager.h"

@interface QBRegisterViewController ()

@end

@implementation QBRegisterViewController

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
    NSLog(@"viewDidLoad Register");
    [self.loadingIndicator hidesWhenStopped];
    [self.loadingIndicator stopAnimating];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerButton:(id)sender {
    [self.loadingIndicator startAnimating];
    if ([[self.passwordInput text] isEqualToString:[self.confirmPasswordInput text]]) {
        QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
        cm.registerDelegate = self;
        [cm registerWithEmail:[self.emailInput text] password:[self.passwordInput text]];
    } else {
        NSLog(@"Invalid Mail");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email" message:@"The email is not valid." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.loadingIndicator stopAnimating];
    }
}

- (void)registerSuccess {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.loadingIndicator stopAnimating];
        //NSLog(@"Registration success!");
        //QBDataManager *dm = [QBDataManager sharedManager];
        //[dm setToken:token];
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)registerFailed {
    NSLog(@"register failed");
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register failed" message:@"The email is invalid or already connected to an account." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.loadingIndicator stopAnimating];
    });
}


@end
