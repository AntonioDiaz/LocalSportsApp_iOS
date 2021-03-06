#import "TeamsViewController.h"
#import "UtilsDataBase.h"
#import "TeamHeadingTableViewCell.h"
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
        TeamHeadingTableViewCell *cell = [self.tableViewTeams dequeueReusableCellWithIdentifier:@"cell_team_heading"];
        NSString *teamName = [arrayTeams objectAtIndex:indexPath.section];
        cell.labelTitle.text = teamName;
        cell.labelTitle.backgroundColor = [Utils primaryColor];
        
        UIImage *image = [UIImage imageNamed:@"favorite_unselect"];
        if ([UtilsDataBase isTeamFavorite:teamName withCompetition:competitionEntity.idCompetitionServer]) {
            image = [UIImage imageNamed:@"favorite"];
        }
        cell.imageViewFavorite.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.imageViewFavorite setTintColor:[UIColor whiteColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [Utils primaryColor];
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
        tapRecognizer.numberOfTapsRequired = 1;
        [cell.imageViewFavorite setUserInteractionEnabled:YES];
        [cell.imageViewFavorite addGestureRecognizer:tapRecognizer];
        cell.imageViewFavorite.tag = indexPath.section;
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
        } else if (matchEntity.state == RESTING) {
            scoreText = @"DESC";
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
-(void) tapDetected:(UITapGestureRecognizer*)sender {
    UIImageView *favoriteView = (UIImageView*)sender.view;
    NSString *teamName = [arrayTeams objectAtIndex:(int)favoriteView.tag];
    long idCompetitionServer = competitionEntity.idCompetitionServer;
    BOOL isFavorite = [UtilsDataBase isTeamFavorite:teamName withCompetition:idCompetitionServer];
    NSString *favoriteImage;
    if (!isFavorite) {
        favoriteImage = @"favorite";
        NSString *msg = NSLocalizedString(@"FAVORITES_TEAM_ADDED", nil);
        [Utils showAlert:msg];
    } else {
        favoriteImage = @"favorite_unselect";
        NSString *msg = NSLocalizedString(@"FAVORITES_TEAM_REMOVED", nil);
        [Utils showAlert:msg];
    }
    [UtilsDataBase markOrUnmarkTeamAsFavorite:teamName withCompetition:idCompetitionServer isFavorite:!isFavorite];
    UIImage *image = [[UIImage imageNamed:favoriteImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    favoriteView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

-(void) reloadDataTable:(CompetitionEntity *) competition {
    competitionEntity = competition;
    arrayTeams = [[NSMutableArray alloc] init];
    arrayTeamMatches = [[NSMutableArray alloc] init];
    NSArray *arrayMatches = [UtilsDataBase queryMatches:competition];
    for (MatchEntity *matchEntity in arrayMatches) {
        if (matchEntity.teamLocal!=nil && [arrayTeams containsObject:matchEntity.teamLocal]!=1) {
            [arrayTeams addObject:matchEntity.teamLocal];
            [arrayTeamMatches addObject:[[NSMutableArray alloc] init]];
        }
        if (matchEntity.teamVisitor!=nil && [arrayTeams containsObject:matchEntity.teamVisitor]!=1) {
            [arrayTeams addObject:matchEntity.teamVisitor];
            [arrayTeamMatches addObject:[[NSMutableArray alloc] init]];
        }
    }
    [arrayTeams sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    for (MatchEntity *matchEntity in arrayMatches) {
        if (matchEntity.teamLocal!=NULL) {
            NSUInteger teamLocalPosition = [arrayTeams indexOfObject:matchEntity.teamLocal];
            NSMutableArray *teamAsLocalMatches = [arrayTeamMatches objectAtIndex:teamLocalPosition];
            [teamAsLocalMatches addObject:matchEntity];
        }
        if (matchEntity.teamVisitor!=NULL) {
            if ([arrayTeams containsObject:matchEntity.teamVisitor]) {
                NSUInteger teamVisitorPosition = [arrayTeams indexOfObject:matchEntity.teamVisitor];
                NSMutableArray *teamAsVisitorMatches = [arrayTeamMatches objectAtIndex:teamVisitorPosition];
                [teamAsVisitorMatches addObject:matchEntity];
            }
        }
    }
    [self.tableViewTeams reloadData];
}
@end
