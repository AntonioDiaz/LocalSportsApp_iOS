#import "SideMenuTableController.h"
#import "Utils.h"
#import "UtilsDataBase.h"

@interface SideMenuTableController ()

@end

@implementation SideMenuTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrayMenuItems = [[NSArray alloc] initWithObjects:@"cell_empty", @"cell_title", @"cell_change_town", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrayMenuItems.count;
}

#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idCell = [arrayMenuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell forIndexPath:indexPath];
    if (indexPath.row==1) {
        cell.backgroundColor = [Utils primaryColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==2) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setValue:nil forKey:PREF_TOWN_NAME];
        [userDefaults setValue:nil forKey:PREF_TOWN_ID];
        [userDefaults setValue:nil forKey:PREF_PRIMARY_COLOR];
        [userDefaults setValue:nil forKey:PREF_ACCENT_COLOR];
        [UtilsDataBase deleteAllEntities:COMPETITION_ENTITY];
        [UtilsDataBase deleteAllEntities:FAVORITE_TEAM_ENTITY];
        if (@available(iOS 10.3, *)) {
            [UIApplication.sharedApplication setAlternateIconName:nil completionHandler:nil];
        } else {
            NSLog(@"not possible to change app icon.");
        }
        NSString *storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"RootNavigationController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
@end
