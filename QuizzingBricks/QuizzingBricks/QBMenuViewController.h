//
//  QBMenuViewController.h
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-20.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QBMenuViewController : UITableViewController

- (IBAction)cancel:(UIStoryboardSegue *)segue;
- (IBAction)createLobby:(UIStoryboardSegue *)segue;

@end
