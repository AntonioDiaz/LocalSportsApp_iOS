#import "Utils.h"
#import "UtilsDataBase.h"
#import "TeamMatchesTableViewController.h"
#import "FavoriteTeamMatchTableViewCell.h"
#import "MatchEntity+CoreDataProperties.h"
#import "MatchAddEventViewController.h"
#import "MatchSendIssueViewController.h"

@implementation TeamMatchesTableViewController

@synthesize competitionEntity;
@synthesize teamName;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadCompetitionDetails:competitionEntity inTable:self.tableView];
    self.navigationItem.prompt = [NSString stringWithFormat:@"%@ - %@", self.competitionEntity.name, self.competitionEntity.category];
    self.navigationItem.title = teamName;
    isFavoriteTeam = true;
    [self updateFavoriteImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private methods
-(void) updateFavoriteImage {
    NSString *favoriteImage = @"favorite_unselect";
    if (isFavoriteTeam) {
        favoriteImage = @"favorite";
    }
    UIImage *image = [[UIImage imageNamed:favoriteImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image = [Utils imageWithSize:image scaledToSize:CGSizeMake(30, 30)];
    buttonFavorite = [[UIBarButtonItem alloc]initWithImage:image
                                                     style:UIBarButtonItemStylePlain
                                                    target:self
                                                    action:@selector(switchFavoriteCompetition:)];
    [buttonFavorite setTintColor:[Utils accentColor]];
    self.navigationItem.rightBarButtonItem = buttonFavorite;
}

/** set or unset team as favorite. */
-(void) switchFavoriteCompetition:(id)sender {
    isFavoriteTeam = !isFavoriteTeam;
    [UtilsDataBase markOrUnmarkTeamAsFavorite:teamName
                              withCompetition:self.competitionEntity.idCompetitionServer
                                   isFavorite:isFavoriteTeam];
    [self updateFavoriteImage];
}

/** Load details (matches) from server and update tables in DB. */
-(void) loadCompetitionDetails:(CompetitionEntity *) competitionEntity inTable:(UITableView *) tableView {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config];
    NSString *idCompetitionServerStr = [NSString stringWithFormat:@"%ld", (long)competitionEntity.idCompetitionServer];
    NSString *strUrlCompetitions = [NSString stringWithFormat:URL_COMPETITION_DETAILS, idCompetitionServerStr];
    NSURL *url = [NSURL URLWithString:strUrlCompetitions];
    NSURLSessionTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error on task: %@", error.description);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200) {
                NSError *jsonError = nil;
                NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSArray *arrayMatches = [jsonResults objectForKey:@"matches"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UtilsDataBase deleteMatches:competitionEntity];
                    [UtilsDataBase deleteAllEntities:COURT_ENTITY];
                    for (NSDictionary *matchDictionary in arrayMatches) {
                        [UtilsDataBase insertMatch: matchDictionary withEntity:self.competitionEntity];
                    }
                    NSArray *arrayAllMatches = [UtilsDataBase queryMatches:competitionEntity];
                    matches = [[NSMutableArray alloc] init];
                    for (MatchEntity *match in arrayAllMatches) {
                        if ([teamName isEqualToString:match.teamLocal] || [teamName isEqualToString:match.teamVisitor]) {
                            [matches addObject:match];
                        }
                    }
                    [tableView reloadData];
                });
            } else {
                NSLog(@"status: %d", (int)httpResponse.statusCode);
            }
        }
    }];
    [task resume];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteTeamMatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_favorite_team_match" forIndexPath:indexPath];
    cell.labelWeek.text = [NSString stringWithFormat:NSLocalizedString(@"CALENDAR_WEEK", nil), (int)indexPath.row + 1];
    cell.labelWeek.backgroundColor = [Utils accentColor];
    MatchEntity *matchEntity = [matches objectAtIndex:indexPath.row];
    NSString* dateStr = [Utils formatDateDoubleToStr:matchEntity.date];
    if (matchEntity.state == CANCELED) {
        cell.labelDate.text = NSLocalizedString(@"CALENDAR_CANCELED", nil);
    } else {
        cell.labelDate.text = dateStr;
    }
    cell.labelPlace.text = matchEntity.court.centerName;
    cell.labelTeamLocal.text = matchEntity.teamLocal;
    cell.labelTeamVisitor.text = matchEntity.teamVisitor;
    if (matchEntity.state == PLAYED) {
        cell.labelScoreLocal.text = [NSString stringWithFormat:@"%d", matchEntity.scoreLocal];
        cell.labelScoreVisitor.text = [NSString stringWithFormat:@"%d", matchEntity.scoreVisitor];
    } else {
        cell.labelScoreLocal.text = @"-";
        cell.labelScoreVisitor.text = @"-";
    }
    cell.viewContent.layer.cornerRadius = 5;
    cell.viewContent.layer.masksToBounds = true;
    cell.viewContent.backgroundColor = [Utils primaryColor];
    cell.labelWeek.layer.cornerRadius = 5;
    cell.labelWeek.layer.masksToBounds = true;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

#pragma mark - table delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    matchEntity = [matches objectAtIndex:indexPath.row];
    NSString *alertTitle = NSLocalizedString(@"MATCH_ACTION_TITLE", nil);
    NSString *strActionShare = NSLocalizedString(@"MATCH_ACTION_SHARE", nil);
    NSString *strActionAddEvent = NSLocalizedString(@"MATCH_ACTION_EVENT", nil);
    NSString *strActionSendIssue = NSLocalizedString(@"MATCH_ACTION_ISSUE", nil);
    NSString *strActionOpenMap = NSLocalizedString(@"MATCH_ACTION_MAP", nil);;
    NSString *strActionClose = NSLocalizedString(@"MATCH_ACTION_CLOSE", nil);
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    }
    UIAlertAction *actionShare = [UIAlertAction actionWithTitle:strActionShare
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *action) {
                                                            NSString *dateStr = [Utils formatDateDoubleToStr:matchEntity.date];
                                                            NSString *strShareText = NSLocalizedString(@"MATCH_SHARE_TEXT", nil);
                                                            NSString *textToShare = [NSString stringWithFormat:strShareText, matchEntity.week, matchEntity.teamLocal, matchEntity.teamVisitor, matchEntity.court.centerName, dateStr];
                                                            [Utils actionShareMatch:textToShare inViewController:self];
                                                            [alertController dismissViewControllerAnimated:YES completion:nil];
                                                        }];
    [alertController addAction:actionShare];
    
    UIAlertAction *actionAddEvent = [UIAlertAction actionWithTitle:strActionAddEvent style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:SEGUE_EVENT sender:nil];
    }];
    [alertController addAction:actionAddEvent];
    
    UIAlertAction *actionSendIssue = [UIAlertAction actionWithTitle:strActionSendIssue style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self performSegueWithIdentifier:SEGUE_POST sender:nil];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:actionSendIssue];
    
    UIAlertAction *actionOpenMap = [UIAlertAction actionWithTitle:strActionOpenMap style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIApplication *application = [UIApplication sharedApplication];
        NSString *courtAddress = matchEntity.court.centerAddress;
        NSString *centerName = matchEntity.court.centerName;
        courtAddress =  [NSString stringWithFormat:@"%@, %@", centerName, courtAddress];
        courtAddress = [courtAddress stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        NSURLComponents *components = [NSURLComponents componentsWithString:@"http://maps.apple.com"];
        NSURLQueryItem *address = [NSURLQueryItem queryItemWithName:@"address" value:courtAddress];
        components.queryItems = @[address];
        NSURL *url = components.URL;
        [application openURL:url options:@{} completionHandler:nil];
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:actionOpenMap];
    
    UIAlertAction *actionClose = [UIAlertAction actionWithTitle:strActionClose style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    [alertController addAction:actionClose];
    [self presentViewController:alertController animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:[Utils primaryColorDarker]];
    if ([[segue identifier] isEqualToString:SEGUE_EVENT]) {
        MatchAddEventViewController *matchAddEventViewController = (MatchAddEventViewController *) segue.destinationViewController;
        matchAddEventViewController.matchEntity = matchEntity;
    }
    if ([[segue identifier] isEqualToString:SEGUE_POST]) {
        MatchSendIssueViewController *matchSendIssueController = (MatchSendIssueViewController *) segue.destinationViewController;
        matchSendIssueController.matchEntity = matchEntity;
    }
}
@end
