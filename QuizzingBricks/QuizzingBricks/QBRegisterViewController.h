//
//  QBRegisterViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-08.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBCommunicationManager.h"

@interface QBRegisterViewController : UIViewController <QBRegisterComDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordInput;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)cancelButton:(id)sender;
- (IBAction)registerButton:(id)sender;

- (void)registerSuccess;
- (void)registerFailed;

@end
