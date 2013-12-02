//
//  QBGamesViewController.m
//  QuizzingBricks
//
//  Created by Linus Hedenberg on 2013-09-22.
//  Copyright (c) 2013 Linus Hedenberg. All rights reserved.
//

#import "QBGamesViewController.h"
#import "QBDataManager.h"
#import "QBCommunicationManager.h"
#import "QBLobby.h"
#import "QBGame.h"
#import "QBPlayer.h"
#import "QBLobbyViewController.h"
#import "QBGameViewController.h"

@interface QBGamesViewController ()

@end

@implementation QBGamesViewController

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
    
    NSLog(@"viewDidLoad Games");
    
    self.lobbies = [[NSArray alloc] init];
    self.games = [[NSArray alloc] init];
    
    [self getLobbyList];
    [self getGameList];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self getLobbyList];
    [self getGameList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getLobbyList
{
    QBDataManager *dm = [QBDataManager sharedManager];
    QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
    cm.lobbyDelegate = self;
    [cm getLobbiesWithToken:dm.token];
}

- (void)getGameList
{
    QBDataManager *dm = [QBDataManager sharedManager];
    QBCommunicationManager *cm = [[QBCommunicationManager alloc] init];
    cm.gameDelegate = self;
    [cm getGamesWithToken:dm.token];
}

- (void)lobbies:(NSArray *)lobbyList{
    self.lobbies = lobbyList;
    NSLog(@"loblen: %ld", (unsigned long)(long)self.lobbies.count);
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.tableView reloadData];
                   });
}

- (void)getLobbiesFailed{
    // TODO: Error-handle this sheit
    NSLog(@"getLobbies Failed.");
}

- (void)lobby:(QBLobby *)l
{
    // Not used
}

- (void)getLobbyFailed{
    // TODO: Error-handle this sheit
    NSLog(@"getLobby Failed.");
}

- (void)createdLobby:(QBLobby *)l{
    // Not used
}

- (void)createLobbyFailed{
    // TODO: Error-handle this sheit
    NSLog(@"createLobby Failed.");
}

- (void)inviteFriendSucceded
{
    // Not used
}

- (void)inviteFriendFailed
{
    // Not used
}

- (void)acceptInviteSucceeded
{
    // Not used
}

- (void)acceptInviteFailed
{
    // Not used
}

- (void)startGameSucceeded
{
    // Not used
}

- (void)startGameFailed
{
    // Not used
}

- (void)games:(NSArray *)gameList{
    self.games = gameList;
    NSLog(@"gamelen: %ld", (long)self.games.count);
    dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.tableView reloadData];
                   });
}

- (void)getGamesFailed{
    // TODO: Error-handle this sheit
    NSLog(@"getGames Failed.");
}

- (void)game:(QBGame *)g
{
    // Not used
}

- (void)getGameFailed{
    // TODO: Error-handle this sheit
    NSLog(@"getGame Failed.");
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return self.lobbies.count;
    }
    return self.games.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSLog(@"lobbycell");
        static NSString *CellIdentifier = @"LobbyCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...;
        QBLobby *lobby = [self.lobbies objectAtIndex:indexPath.row];
        if (lobby.isOwner) {
            [cell.textLabel setText:[NSString stringWithFormat:@"Game Lobby - Owner %@",[[self.lobbies objectAtIndex:indexPath.row] lobbyID]]];
        } else {
            [cell.textLabel setText:[NSString stringWithFormat:@"Game Lobby %@",[[self.lobbies objectAtIndex:indexPath.row] lobbyID]]];
        }
        if (lobby.size == 2) {
            [cell.detailTextLabel setText:@"Two Player"];
        } else {
            [cell.detailTextLabel setText:@"Four Player"];
        }
        return cell;

    }
    static NSString *CellIdentifier = @"GameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [cell.textLabel setText:[NSString stringWithFormat:@"%@", [self.games objectAtIndex:indexPath.row]]];
    
    return cell;
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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"ViewLobbySegue"]) {
        QBLobbyViewController *lvc = segue.destinationViewController;
        lvc.lobbyID = [[self.lobbies objectAtIndex:[self.tableView indexPathForSelectedRow].row] lobbyID];
    } else if ([[segue identifier] isEqualToString:@"ViewGameSegue"]) {
        QBGameViewController *gvc = segue.destinationViewController;
        gvc.gameID = [self.games objectAtIndex:[self.tableView indexPathForSelectedRow].row];
        
    }
}


@end
