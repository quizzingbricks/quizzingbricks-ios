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

- (BOOL)NSStringIsValidEmail:(NSString *)checkString;

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
    //[self performSegueWithIdentifier:@"loginSegue" sender:self];
    
    if ([self NSStringIsValidEmail:[self.emailInput text]]) {
        NSLog(@"Valid Mail");
    } else {
        NSLog(@"Invalid Mail");
    }
    
    QBCommunicationManager *qbc = [[QBCommunicationManager alloc] init];
    qbc.delegate = self;
    [qbc loginWithEmail:@"a@a.a" password:@"b"];
}

- (void)loginToken:(NSString *)token
{
    dispatch_sync(dispatch_get_main_queue(), ^{
     [self performSegueWithIdentifier:@"loginSegue" sender:self];
     });
}

- (void)loginFailed
{
    NSLog(@"login failed");
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.emailInput) || (textField == self.passwordInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
