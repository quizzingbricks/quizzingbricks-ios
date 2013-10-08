//
//  QBLoginViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-20.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBLoginViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;

- (IBAction)logout:(UIStoryboardSegue *)segue;
- (IBAction)login:(id)sender;

@end
