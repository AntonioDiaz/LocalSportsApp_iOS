#import "CalendarViewController.h"
#import "MatchEntity+CoreDataProperties.h"
#import "SportCourtEntity+CoreDataProperties.h"
#import "MatchDetailTableViewCell.h"
#import "Utils.h"
#import "UtilsDataBase.h"
#import "MatchAddEventViewController.h"
#import "MatchMapViewController.h"
#import "MatchSendIssueViewController.h"
#import "CalendarHeadingTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sectionsExpanded = [[NSMutableIndexSet alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self calculateNumOfWeeks];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([sectionsExpanded containsIndex:section]) {
        return numMatchesEachWeek + 1;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        CalendarHeadingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_calendar_heading" forIndexPath:indexPath];
        cell.labelTitle.text = [NSString stringWithFormat:NSLocalizedString(@"CALENDAR_WEEK", nil), (int)indexPath.section + 1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [Utils primaryColor];
        cell.labelTitle.backgroundColor = [Utils primaryColor];
        return cell;
    } else {
        MatchDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_calendar_detail" forIndexPath:indexPath];
        int indexInArray = ((int)indexPath.row - 1) + (int)indexPath.section * numMatchesEachWeek;
        MatchEntity *matchEntity = [arrayMatches objectAtIndex:indexInArray];
        NSString* dateStr = @"-";
        if (matchEntity.date) {
            dateStr = [Utils formatDateDoubleToStr:matchEntity.date];
        }
        NSString* teamVisitor = matchEntity.teamVisitor;
        cell.labelLocal.text = matchEntity.teamLocal;
        cell.labelDate.text = dateStr;
        NSString* centerName = @"-";
        if (matchEntity.court) {
            centerName = matchEntity.court.centerName;
        }
        NSString *scoreText = @"";
        if (matchEntity.state==PENDING) {
            scoreText = @"-";
        } else if (matchEntity.state == PLAYED) {
            scoreText = [NSString stringWithFormat:@"%d - %d", matchEntity.scoreLocal, matchEntity.scoreVisitor];
        } else if (matchEntity.state == CANCELED) {
            scoreText = @"CANC";
            dateStr = @"";
            centerName = @"-";
        } else if (matchEntity.state == RESTING) {
            scoreText = @"DESC";
            dateStr = @"";
            teamVisitor = @"";
            centerName = @"-";
        }
        cell.labelCenter.text = centerName;
        cell.labelVisitor.text = teamVisitor;
        cell.labelDate.text = dateStr;
        cell.labelScore.text = scoreText;
        cell.labelCenter.text = centerName;
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0) {
        return 50.0;
    } else {
        return 65.0;
    }
}

#pragma mark - table delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //unselect cell.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSInteger section = indexPath.section;
        NSMutableArray *mutableArrayCells = [[NSMutableArray alloc] init];
        for (int i=1; i<=numMatchesEachWeek; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
            [mutableArrayCells addObject:indexPath];
        }
        if ([sectionsExpanded containsIndex:section]) {
            [sectionsExpanded removeIndex:section];
            [tableView deleteRowsAtIndexPaths:mutableArrayCells withRowAnimation:UITableViewRowAnimationTop];
        } else {
            [sectionsExpanded addIndex:section];
            [tableView insertRowsAtIndexPaths:mutableArrayCells withRowAnimation:UITableViewRowAnimationTop];
        }
    } else {
        NSString *alertTitle = NSLocalizedString(@"MATCH_ACTION_TITLE", nil);
        NSString *strActionShare = NSLocalizedString(@"MATCH_ACTION_SHARE", nil);
        NSString *strActionAddEvent = NSLocalizedString(@"MATCH_ACTION_EVENT", nil);
        NSString *strActionSendIssue = NSLocalizedString(@"MATCH_ACTION_ISSUE", nil);
        NSString *strActionOpenMap = NSLocalizedString(@"MATCH_ACTION_MAP", nil);;
        NSString *strActionClose = NSLocalizedString(@"MATCH_ACTION_CLOSE", nil);
        NSIndexPath *indexPath = [self.tableViewCalendar indexPathForSelectedRow];
        int indexInArray = ((int)indexPath.row - 1) + (int)indexPath.section * numMatchesEachWeek;
        matchEntity = [arrayMatches objectAtIndex:indexInArray];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        }
        UIAlertAction *actionShare = [UIAlertAction actionWithTitle:strActionShare
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action) {
                NSString *dateStr = [Utils formatDateDoubleToStr:matchEntity.date];
                NSString *strShareText = NSLocalizedString(@"MATCH_SHARE_TEXT", nil);
                NSString *textToShare = [NSString stringWithFormat:strShareText, matchEntity.week, matchEntity.teamLocal,
                                         matchEntity.teamVisitor, matchEntity.court.centerName, dateStr];
                [Utils actionShareMatch:textToShare inViewController:self];
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
        [alertController addAction:actionShare];
        UIAlertAction *actionAddEvent = [UIAlertAction actionWithTitle:strActionAddEvent style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self performSegueWithIdentifier:SEGUE_EVENT sender:nil];
        }];
        if (matchEntity.state!=PENDING || !matchEntity.date) {
            [actionAddEvent setEnabled:false];
        }
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
        if (matchEntity.state==CANCELED || matchEntity.state==RESTING || !matchEntity.court.centerName) {
            [actionOpenMap setEnabled:false];
        }
        [alertController addAction:actionOpenMap];
        
        UIAlertAction *actionClose = [UIAlertAction actionWithTitle:strActionClose style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }];
        [alertController addAction:actionClose];
        [self presentViewController:alertController animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString * strBack = NSLocalizedString(@"BACK", nil);
    self.tabBarController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:strBack style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.tabBarController.navigationItem.backBarButtonItem setTintColor:[Utils primaryColorDarker]];
    if ([[segue identifier] isEqualToString:SEGUE_EVENT]) {
        MatchAddEventViewController *matchAddEventViewController = (MatchAddEventViewController *) segue.destinationViewController;
        matchAddEventViewController.matchEntity = matchEntity;
    }
    if ([[segue identifier] isEqualToString:SEGUE_POST]) {
        MatchSendIssueViewController *matchSendIssueController = (MatchSendIssueViewController *) segue.destinationViewController;
        matchSendIssueController.matchEntity = matchEntity;
    }
}


-(void) reloadDataTable:(CompetitionEntity *) competition {
    competitionEntity = competition;
    self.labelCategory.text = competitionEntity.category;
    arrayMatches = [UtilsDataBase queryMatches:competition];
    if (arrayMatches.count > 0) {
        numOfWeeks = [self calculateNumOfWeeks];
        numMatchesEachWeek = (int)arrayMatches.count / numOfWeeks;
    }
    [self.tableViewCalendar reloadData];
}

-(int) calculateNumOfWeeks {
    int maxWeek = 0;
    for (MatchEntity* matchEntity in arrayMatches) {
        if (matchEntity.week>maxWeek) {
            maxWeek = matchEntity.week;
        }
    }
    return maxWeek;
}

@end
