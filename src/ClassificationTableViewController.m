#import "ClassificationTableViewController.h"
#import "ClassificationEntity+CoreDataProperties.h"
#import "ClassificationEntity+CoreDataClass.h"
#import "AppDelegate.h"
#import "Utils.h"
#import "UtilsDataBase.h"
#import "ClassificationTableViewCell.h"

@implementation ClassificationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayClassification.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_classification" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.labelTeam.text = NSLocalizedString(@"CLASSIFICATION_TEAM", nil);
        cell.backgroundColor = [Utils primaryColor];
        cell.labelPoints.textColor = [UIColor whiteColor];
        cell.labelTeam.textColor = [UIColor whiteColor];
        cell.labelMatchesPlayed.textColor = [UIColor whiteColor];
        cell.labelMatchesWon.textColor = [UIColor whiteColor];
        cell.labelMatchesDrawn.textColor = [UIColor whiteColor];
        cell.labelMatchesLost.textColor = [UIColor whiteColor];
        cell.labelPoints.textColor = [UIColor whiteColor];
        UIFont *currentFont = cell.textLabel.font;
        UIFont *newFont = [UIFont fontWithName:[NSString stringWithFormat:@"%@-Bold",currentFont.fontName] size:currentFont.pointSize - 2];
        cell.labelPoints.font = newFont;
        cell.labelTeam.font = newFont;
        cell.labelMatchesPlayed.font = newFont;
        cell.labelMatchesWon.font = newFont;
        cell.labelMatchesDrawn.font = newFont;
        cell.labelMatchesLost.font = newFont;
        cell.labelPoints.font = newFont;
        cell.viewSeparatorLine.hidden = true;
    } else {
        ClassificationEntity *classificationEntity = [arrayClassification objectAtIndex:indexPath.row - 1];
        cell.labelPosition.text = [NSString stringWithFormat:@"%d", classificationEntity.position];
        cell.labelTeam.text = classificationEntity.team;
        cell.labelMatchesPlayed.text = [NSString stringWithFormat:@"%d", classificationEntity.matchesPlayed];
        cell.labelMatchesWon.text = [NSString stringWithFormat:@"%d", classificationEntity.matchesWon];
        cell.labelMatchesDrawn.text = [NSString stringWithFormat:@"%d", classificationEntity.matchesDrawn];
        cell.labelMatchesLost.text = [NSString stringWithFormat:@"%d", classificationEntity.matchesLost];
        cell.labelPoints.text = [NSString stringWithFormat:@"%d", classificationEntity.points];
    }
    return cell;
}

#pragma mark - private methods
-(void) reloadDataTable:(CompetitionEntity *) competition {
    arrayClassification = [UtilsDataBase queryClassification:competition];
    [self.tableView reloadData];
}
@end
