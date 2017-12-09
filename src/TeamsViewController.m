#import "TeamsViewController.h"
#import "UtilsDataBase.h"
#import "CalendarHeadingTableViewCell.h"
#import "TeamMatchTableViewCell.h"
#import "Utils.h"

@implementation TeamsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    sectionsExpanded = [[NSMutableIndexSet alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [arrayTeams count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([sectionsExpanded containsIndex:section]) {
        int numMatches = (int)[[arrayTeamMatches objectAtIndex:section] count];
        return  numMatches + 1;
    } else {
        return 1;
    }
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        CalendarHeadingTableViewCell *cell = [self.tableViewTeams dequeueReusableCellWithIdentifier:@"cell_team_heading"];
        cell.labelTitle.text = [arrayTeams objectAtIndex:indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = UIColorFromRGB(0x0061a8);
        return cell;
    } else {
        TeamMatchTableViewCell *cell = [self.tableViewTeams dequeueReusableCellWithIdentifier:@"cell_team_match"];
        NSMutableArray *matches = [arrayTeamMatches objectAtIndex:indexPath.section];
        MatchEntity *matchEntity = [matches objectAtIndex:indexPath.row -1];
        cell.labelTeamLocal.text = matchEntity.teamLocal;
        cell.labelTeamVisitor.text = matchEntity.teamVisitor;
        NSString *scoreText = [NSString stringWithFormat:@"%d - %d", matchEntity.scoreLocal, matchEntity.scoreVisitor];
        if (matchEntity.state==PENDING) {
            scoreText = @"-";
        } else if (matchEntity.state == CANCELED) {
            scoreText = @"CANC";
        }
        cell.labelResult.text = scoreText;
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, CGFLOAT_MAX);
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0) {
        return 50.0;
    } else {
        return 40.0;
    }
}

#pragma mark - table delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        //unselect cell.
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSInteger section = indexPath.section;
        NSMutableArray *mutableArrayCells = [[NSMutableArray alloc] init];
        int numMatches = (int)[[arrayTeamMatches objectAtIndex:section] count];
        for (int i=1; i<=numMatches; i++) {
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
    }
}

#pragma mark - private methods
-(void) reloadDataTable:(CompetitionEntity *) competition {
    arrayTeams = [[NSMutableArray alloc] init];
    arrayTeamMatches = [[NSMutableArray alloc] init];
    NSArray *arrayMatches = [UtilsDataBase queryMatches:competition];
    for (MatchEntity *matchEntity in arrayMatches) {
        if ([arrayTeams indexOfObject:matchEntity.teamLocal]==NSNotFound) {
            [arrayTeams addObject:matchEntity.teamLocal];
            [arrayTeamMatches addObject:[[NSMutableArray alloc] init]];
        }
    }
    [arrayTeams sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (MatchEntity *matchEntity in arrayMatches) {
        NSUInteger teamLocalPosition = [arrayTeams indexOfObject:matchEntity.teamLocal];
        NSMutableArray *teamAsLocalMatches = [arrayTeamMatches objectAtIndex:teamLocalPosition];
        [teamAsLocalMatches addObject:matchEntity];
        NSUInteger teamVisitorPosition = [arrayTeams indexOfObject:matchEntity.teamVisitor];
        NSMutableArray *teamAsVisitorMatches = [arrayTeamMatches objectAtIndex:teamVisitorPosition];
        [teamAsVisitorMatches addObject:matchEntity];
    }
    [self.tableViewTeams reloadData];
}
@end
