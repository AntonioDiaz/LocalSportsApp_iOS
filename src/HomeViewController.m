#import "HomeViewController.h"
#import "Utils.h"
#import "SportsViewController.h"
#import "SideMenuController.h"
#import "TownsTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"device directory: %@", documentsDirectoryPath);
    self.navigationItem.title = [NSString stringWithFormat: NSLocalizedString(@"HOME_TITLE", nil), APP_NAME];
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *townSelectedStr = [userDefaults objectForKey:PREF_TOWN_NAME];
    if (townSelectedStr.length > 0) {
        [self navigateToSportsScreen];
    } else {
        self.navigationItem.title = [NSString stringWithFormat: NSLocalizedString(@"HOME_TITLE", nil), APP_NAME];
        //check for internet conection.
        if ([Utils noTengoInterne]) {
            [Utils showAlert:NSLocalizedString(@"HOME_INTERNET_REQUIRED", nil)];
        } else {
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config];
            NSURL *url = [NSURL URLWithString:URL_TOWNS];
            NSURLSessionTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"Error on task: %@", error.description);
                } else {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    if (httpResponse.statusCode == 200) {
                        NSError *jsonError = nil;
                        arrayTowns = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.townsTableView reloadData];
                        });
                    } else {
                        NSLog(@"status: %ld", (long)httpResponse.statusCode);
                    }
                }
            }];
            [task resume];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrayTowns count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TownsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_town_new"];
    NSDictionary *dictionary = [arrayTowns objectAtIndex:indexPath.row];
    NSString *name = [dictionary objectForKey:@"name"];
    NSString *iconName = [dictionary objectForKey:@"iconName"];
    UIImage *image = [UIImage imageNamed: iconName];
    cell.labelTownName.text = name;
    [cell.imageViewTown setImage:image];
    cell.imageViewTown.layer.cornerRadius = 5;
    cell.imageViewTown.clipsToBounds = true;
    cell.viewContent.layer.cornerRadius = 5;
    [cell.viewContent setBackgroundColor:[Utils primaryColor]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dictionaryTown = [arrayTowns objectAtIndex:indexPath.row];
    NSString *townSelectedString = [dictionaryTown objectForKey:@"name"];
    NSString *townSelectedId = [dictionaryTown objectForKey:@"id"];
    NSString *iconName = [dictionaryTown objectForKey:@"iconName"];
    NSString *townPrimaryColor = [dictionaryTown objectForKey:@"colorPrimary"];
    NSString *townAccentColor = [dictionaryTown objectForKey:@"colorAccent"];
    NSArray *sports = [dictionaryTown objectForKey:@"sportsDeref"];
    //NSArray *sports = [dictionaryTown objectForKey:@"sportsDeref"];
    [userDefaults setValue:townSelectedString forKey:PREF_TOWN_NAME];
    [userDefaults setValue:townSelectedId forKey:PREF_TOWN_ID];
    [userDefaults setObject:sports forKey:PREF_TOWN_SPORTS];
    //[userDefaults setObject:sports forKey:PREF_TOWN_SPORTS]
    if (townPrimaryColor!=nil && townPrimaryColor!=(id)[NSNull null] && townPrimaryColor.length>0) {
        [userDefaults setInteger:[Utils intFromHexString:townPrimaryColor] forKey:PREF_PRIMARY_COLOR];
    }
   if (townAccentColor!=nil && townAccentColor!=(id)[NSNull null] && townAccentColor.length>0) {
        [userDefaults setInteger:[Utils intFromHexString:townAccentColor] forKey:PREF_ACCENT_COLOR];
    }
    if (@available(iOS 10.3, *)) {
        [UIApplication.sharedApplication setAlternateIconName:iconName completionHandler:nil];
    } else {
        NSLog(@"not possible to change app icon.");
    }
    [self navigateToSportsScreen];
}

#pragma mark - private methods
-(void) navigateToSportsScreen {
    NSString *storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    SideMenuController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SportsNavigationController"];
    //vc.leftViewBackgroundColor =[UIColor grayColor];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
