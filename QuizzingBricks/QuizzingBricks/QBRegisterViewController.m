//
//  QBRegisterViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-08.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBRegisterViewController.h"

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
    NSLog(@"Username: %@, Password: %@", self.emailInput.text, self.passwordInput.text);
    
    NSString *post = [NSString stringWithFormat:@"email=%@&password=%@", self.emailInput.text, self.passwordInput.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%ld", [postData length]];
    
    NSURL *url = [[NSURL alloc] initWithString:@"http://192.168.2.6:5000/api/user/register/"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if (error) {
            [self fetchingFailedWithError:error];
        } else {
            NSLog(@"Registration success!");
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void)fetchingFailedWithError:(NSError *)error
{
    NSLog(@"failed registration");
}

@end
