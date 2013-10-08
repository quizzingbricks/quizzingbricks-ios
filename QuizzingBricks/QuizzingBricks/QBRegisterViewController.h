//
//  QBRegisterViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-10-08.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBRegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordInput;

- (IBAction)cancelButton:(id)sender;

@end
