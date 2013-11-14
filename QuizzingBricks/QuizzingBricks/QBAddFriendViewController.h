//
//  QBAddFriendViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-14.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBAddFriendViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailInput;
@property (strong, nonatomic) NSString *email;

@end
