#import "CompetitionsTableViewController.h"
#import "AppDelegate.h"
#import "CompetitionEntity+CoreDataProperties.h"
#import "Utils.h"
#import "UtilsDataBase.h"
#import "CompetitionTabBarController.h"
#import "CompetitionTableViewCell.h"


@implementation CompetitionsTableViewController

@synthesize sportSelectedTag;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *townSelected = [userDefaults objectForKey:PREF_TOWN_NAME];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@", townSelected, NSLocalizedString(sportSelectedTag, nil)];
    self.interstitial = [[GADInterstitial alloc] initWithAdUnitID:AD_UNIT_ID_INTERSTITIAL];
    [self.interstitial loadRequest:[GADRequest request]];
}

-(void)viewWillAppear:(BOOL)animated {
    arrayCompetitions = [UtilsDataBase queryCompetitionsBySport:sportSelectedTag];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (arrayCompetitions.count == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 200)];
        label.text = NSLocalizedString(@"COMPETITIONS_EMPTY", nil);
        label.numberOfLines = 4;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Verdana-Bold" size:22];
        label.textColor = [Utils primaryColor];
        [view addSubview:label];
        self.tableView.backgroundView = view;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    } else {
        self.tableView.backgroundView  = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return arrayCompetitions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CompetitionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_competition" forIndexPath:indexPath];
    CompetitionEntity *competitionEntity = [arrayCompetitions objectAtIndex:indexPath.row];
    cell.labelCompetitionName.text = competitionEntity.name;
    cell.labelCategory.text = competitionEntity.category;
    cell.labelCategory.backgroundColor = [Utils accentColor];
    cell.labelCategory.layer.cornerRadius = 5;
    cell.labelCategory.layer.masksToBounds = true;
    cell.viewCompetition.layer.cornerRadius = 5;
    cell.viewCompetition.layer.masksToBounds = true;
    cell.viewCompetition.backgroundColor = [Utils primaryColor];
    return cell;
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil) style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:[Utils primaryColorDarker]];
    CompetitionTabBarController *competitionTabBarController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CompetitionEntity *competitionEntity = [arrayCompetitions objectAtIndex:indexPath.row];
    competitionTabBarController.competitionEntity = competitionEntity;
    [Utils showInterstitial:self.interstitial inViewController:self];
}
@end
