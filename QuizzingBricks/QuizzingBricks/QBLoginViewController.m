//
//  QBLoginViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-20.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBLoginViewController.h"
#import "QBMenuViewController.h"
#import "QBDataManager.h"

@interface QBLoginViewController ()

- (BOOL)NSStringIsValidEmail:(NSString *)checkString;

@end

@implementation QBLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.loadingIndicator hidesWhenStopped];
    [self.loadingIndicator stopAnimating];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"viewDidLoad Login");
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.loadingIndicator stopAnimating];
}

/*
- (void)viewDidAppear:(BOOL)animated
{
    [self.loadingIndicator hidesWhenStopped];
    [self.loadingIndicator stopAnimating];
    
    QBDataManager *dm = [QBDataManager sharedManager];
    if (![dm.token isEqualToString:@""]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        });
    }
    
}*/

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
    [self.loadingIndicator startAnimating];
    if ([self NSStringIsValidEmail:[self.emailInput text]]) {
        NSLog(@"Valid Mail");
        QBCommunicationManager *qbc = [[QBCommunicationManager alloc] init];
        qbc.loginDelegate = self;
        NSString *email = @"a@a.a";
        NSString *password = @"b";
        if (![self.emailInput.text isEqualToString:@""]) {
            email = self.emailInput.text;
        }
        if (![self.passwordInput.text isEqualToString:@""]) {
            password = self.passwordInput.text;
        }
        
        [qbc loginWithEmail:email password:password];
    } else {
        NSLog(@"Invalid Mail");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid email" message:@"The email is not valid." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [self.loadingIndicator stopAnimating];
    }
}

- (void)loginToken:(NSString *)token
{
    NSLog(@"loginTokenreturn");
    QBDataManager *dm = [QBDataManager sharedManager];
    [dm setToken:token];
    QBCommunicationManager *qbc = [[QBCommunicationManager alloc] init];
    qbc.meDelegate = self;
    [qbc getMeWithToken:token];
    //[self.loadingIndicator stopAnimating];
    //dispatch_sync(dispatch_get_main_queue(), ^{
    // [self performSegueWithIdentifier:@"loginSegue" sender:self];
    // });
}

- (void)loginFailed
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.loadingIndicator stopAnimating];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:@"Please try again.. biatch." delegate:Nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    });
    NSLog(@"login failed");
}

- (void)returnMeWithUserID:(NSString *)userID email:(NSString *) email
{
    NSLog(@"returnMeWithUserID");
    QBDataManager *dm = [QBDataManager sharedManager];
    [dm setU_id:userID];
    [dm setEmail:email];
    NSLog(@"u_id: %@, email: %@", userID, email);
    [self.loadingIndicator stopAnimating];
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"loginSegue" sender:self];
    });
    
}

- (void)getMeFailed
{
    NSLog(@"GetMeFailed  in loginView");
    
}

- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    return YES;
    /*
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
     */
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ((textField == self.emailInput) || (textField == self.passwordInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
