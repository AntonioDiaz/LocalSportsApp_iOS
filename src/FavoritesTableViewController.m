#import "FavoritesTableViewController.h"
#import "UtilsDataBase.h"
#import "Utils.h"
#import "CompetitionTableViewCell.h"
#import "FavoriteTeamTableViewCell.h"
#import "FavoriteTeamEntity+CoreDataProperties.h"
#import "CompetitionTabBarController.h"

@interface FavoritesTableViewController ()

@end

@implementation FavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"FAVORITES", nil);
}

-(void)viewWillAppear:(BOOL)animated {
    arrayCompetitions = [UtilsDataBase queryCompetitionsFavorites];
    arrayTeams = [UtilsDataBase queryAllTeamsFavorites];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrayCompetitions.count == 0 && arrayTeams.count == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 200)];
        label.text = NSLocalizedString(@"FAVORITES_EMPTY", nil);
        label.numberOfLines = 4;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Verdana-Bold" size:22];
        label.textColor = UIColorFromRGB(COLOR_PRIMARY);
        [view addSubview:label];
        self.tableView.backgroundView = view;
        return 0;
    } else {
        self.tableView.backgroundView  = nil;
        if (section == 0) {
            return arrayTeams.count;
        } else {
            return arrayCompetitions.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == 0) {
         FavoriteTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_team" forIndexPath:indexPath];
         FavoriteTeamEntity *favoriteTeam = [arrayTeams objectAtIndex:indexPath.row];
         CompetitionEntity *competitionEntity = [UtilsDataBase queryCompetitionsByIdServer:favoriteTeam.idCompetitionServer];
         NSString *sportStr = NSLocalizedString(competitionEntity.sport, nil);
         NSLog(@"Competition %@", competitionEntity.name);
         cell.labelCompetition.text = [NSString stringWithFormat:@"%@ - %@", sportStr, competitionEntity.name];
         cell.labelCategory.text = competitionEntity.category;
         cell.labelTeam.text = favoriteTeam.teamName;
         cell.labelTeam.layer.cornerRadius = 5;
         cell.labelTeam.layer.masksToBounds = true;
         cell.viewContainer.layer.cornerRadius = 5;
         cell.viewContainer.layer.masksToBounds = true;
         return cell;
    } else {
        CompetitionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_competition" forIndexPath:indexPath];
        CompetitionEntity *competitionEntity = [arrayCompetitions objectAtIndex:indexPath.row];
        NSString *sportStr = NSLocalizedString(competitionEntity.sport, nil);
        cell.labelCompetitionName.text = [NSString stringWithFormat:@"%@ - %@", sportStr, competitionEntity.name];
        cell.labelCategory.text = competitionEntity.category;
        cell.labelCategory.layer.cornerRadius = 5;
        cell.labelCategory.layer.masksToBounds = true;
        cell.viewCompetition.layer.cornerRadius = 5;
        cell.viewCompetition.layer.masksToBounds = true;
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section==0) {
        return 130.0;
    } else {
        return 110.0;
    }
}

#pragma mark - Navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:UIColorFromRGB(COLOR_PRIMARY)];
    if ([[segue identifier] isEqualToString:@"segue_favorite_competition"]) {
        CompetitionTabBarController *competitionTabBarController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CompetitionEntity *competitionEntity = [arrayCompetitions objectAtIndex:indexPath.row];
        competitionTabBarController.competitionEntity = competitionEntity;
    }
}
@end
