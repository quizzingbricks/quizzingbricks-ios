//
//  QBLoginViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-20.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QBCommunicationManager.h"

@interface QBLoginViewController : UIViewController <UITextFieldDelegate, QBLoginComDelegate, QBMeComDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

- (IBAction)logout:(UIStoryboardSegue *)segue;
- (IBAction)login:(id)sender;

@end
