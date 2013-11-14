//
//  QBFriendsViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-11-14.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBFriendsViewController.h"
#import "QBDataManager.h"
#import "QBCommunicationManager.h"
#import "QBFriend.h"

@interface QBFriendsViewController ()

@end

@implementation QBFriendsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"Friends did load");
    
    self.friends = [[NSArray alloc] init];
    
    QBDataManager *dm = [[QBDataManager alloc] init];
    QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
    cm.friendsDelegate = self;
    [cm getFriendsWithToken:dm.token];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)returnFriends:(NSArray *)friends
{
    NSLog(@"returnFriends");
    self.friends = friends;
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.tableView reloadData];
                   });
}

- (void)getFriendsFailed
{
    NSLog(@"getFriendsFailed..");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"friends count: %ld", [self.friends count]);
    return [self.friends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    QBFriend *friend = [self.friends objectAtIndex:indexPath.row];
    NSString *text = [NSString stringWithFormat:@"%@ - %@",[friend userID],[friend email]];
    [cell.textLabel setText:text];
    
    return cell;
}

- (IBAction)addFriend:(UIStoryboardSegue *)segue
{
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
