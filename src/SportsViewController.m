#import "AppDelegate.h"
#import "SportsViewController.h"
#import "CompetitionsTableViewController.h"
#import "CompetitionEntity+CoreDataProperties.h"
#import "UtilsDataBase.h"
#import "UIViewController+LGSideMenuController.h"
#import "FavoritesTableViewController.h"
#import "SportCollectionViewCell.h"

@implementation SportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    managedObjectContext = app.persistentContainer.viewContext;
    self.navigationItem.hidesBackButton = YES;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *appName = NSLocalizedString(@"APP_NAME", nil);
    NSString *townSelected = [userDefaults objectForKey:PREF_TOWN_NAME];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ - %@", appName, townSelected];
    
    UIImage *image = [[UIImage imageNamed:@"menu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    image = [Utils imageWithSize:image scaledToSize:CGSizeMake(30, 30)];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showSideMenu:)];
    [button setTintColor:[Utils primaryColorDarker]];
    self.navigationItem.leftBarButtonItem = button;
    arraySports = [userDefaults objectForKey:PREF_TOWN_SPORTS];
}

-(void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *idTownSelected = [userDefaults objectForKey:PREF_TOWN_ID];
    if (![Utils noTengoInterne]) {
        [self loadCompetitions:idTownSelected];
    }
    if (SHOW_ADS) {
        [self loadBanner];
    } else {
        NSLayoutConstraint *constrain = [NSLayoutConstraint
                                         constraintWithItem:self.collectionViewSports
                                         attribute:NSLayoutAttributeBottom
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:self.collectionViewSports.superview
                                         attribute:NSLayoutAttributeBottom
                                         multiplier:1
                                         constant:0];
        [self.view addConstraint:constrain];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private methods
-(void)loadBanner{
    self.bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    //self.bannerView.frame = CGRectMake(0, 0, self.bannerView.frame.size.width , self.bannerView.frame.size.height);
    self.bannerView.adUnitID = AD_UNIT_ID_BANNER;
    //cuando se clica en el banner, quien se encarga de navegar.
    self.bannerView.rootViewController = self;
    
    //para controlar el flujo del banner, podemos ser los delegados.
    self.bannerView.delegate = self;
    
    // lo enlazamos con la vista del controlador.
    [self.viewHostingBanner addSubview:self.bannerView];
    
    //Cargamos el anuncio
    [self.bannerView loadRequest:[GADRequest request]];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.bannerView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.bottomLayoutGuide
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:self.bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]
                                ]];
}

- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    if (@available(ios 11.0, *)) {
        // In iOS 11, we need to constrain the view to the safe area.
        [self positionBannerViewFullWidthAtBottomOfSafeArea:bannerView];
    } else {
        // In lower iOS versions, safe area is not available so we use
        // bottom layout guide and view edges.
        [self positionBannerViewFullWidthAtBottomOfView:bannerView];
    }
}

#pragma mark - view positioning

- (void)positionBannerViewFullWidthAtBottomOfSafeArea:(UIView *_Nonnull)bannerView NS_AVAILABLE_IOS(11.0) {
    // Position the banner. Stick it to the bottom of the Safe Area.
    // Make it constrained to the edges of the safe area.
    UILayoutGuide *guide = self.view.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints:@[
                                              [guide.leftAnchor constraintEqualToAnchor:bannerView.leftAnchor],
                                              [guide.rightAnchor constraintEqualToAnchor:bannerView.rightAnchor],
                                              [guide.bottomAnchor constraintEqualToAnchor:bannerView.bottomAnchor]
                                              ]];
}

- (void)positionBannerViewFullWidthAtBottomOfView:(UIView *_Nonnull)bannerView {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeLeading
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeading
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeTrailing
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailing
                                                         multiplier:1
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:bannerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.bottomLayoutGuide
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
}

-(void) showSideMenu:(id)sender {
    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
}

-(void) initSportButton:(UIButton*)button withImage:(NSString *) strImage withColor:(UIColor *) color{
    [button setContentMode:UIViewContentModeCenter];
    UIImage *imageFootball = [[UIImage imageNamed:strImage] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [button setImage:imageFootball forState:UIControlStateNormal];
    button.tintColor = color;
    [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
    button.enabled = false;
}

-(void) loadCompetitions:(NSString *) idTown {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *urlSession = [NSURLSession sessionWithConfiguration:config];
    NSString *strUrlCompetitions = [NSString stringWithFormat:URL_COMPETITIONS, idTown];
    NSURL *url = [NSURL URLWithString:strUrlCompetitions];
    NSURLSessionTask *task = [urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error on task: %@", error.description);
        } else {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
            if (httpResponse.statusCode == 200) {
                NSError *jsonError = nil;
                NSArray *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                NSLog(@"competition size %lu", (unsigned long)jsonResults.count);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSMutableSet *setFavoritesIds = [UtilsDataBase queryCompetitionIdsFavorites];
                    //first remove all competitions.
                    [UtilsDataBase deleteAllEntities:COMPETITION_ENTITY];
                   for (NSDictionary *competition in jsonResults) {
                       //[[dictionaryCompetition objectForKey:@"id"] doubleValue];
                       CompetitionEntity * competitionEntity = [UtilsDataBase insertCompetition:competition];
                       NSNumber *idNewCompetition = [NSNumber numberWithDouble:competitionEntity.idCompetitionServer];
                       if([setFavoritesIds containsObject:idNewCompetition]) {
                           [UtilsDataBase markOrUnmarkCompetitionAsFavorite:competitionEntity.idCompetitionServer isFavorite:true];
                       }
                    }
                    [self enableSportButtons];
                });
            } else {
                NSLog(@"status: %d", (int)httpResponse.statusCode);
            }
        }
    }];
    [task resume];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ((int)indexPath.row==0) {
         [self performSegueWithIdentifier:@"idShowFavorites" sender:nil];
    } else {
        NSDictionary *sportDictionary = [arraySports objectAtIndex:indexPath.row -1];
        sportSelectedTag = [sportDictionary objectForKey:@"tag"];
        [self performSegueWithIdentifier:@"idShowCompetitions" sender:nil];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return arraySports.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell_sport";
    SportCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.labelSport.text = NSLocalizedString (@"FAVORITES", nil);
        cell.labelSport.backgroundColor = [Utils accentColor];
        cell.labelSport.layer.cornerRadius = 5;
        cell.labelSport.layer.masksToBounds = true;
        UIImage *image = [[UIImage imageNamed:@"favorite"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.imageViewSport setImage:image];
        [cell.imageViewSport setTintColor:[Utils accentColor]];
    } else {
        NSDictionary *sportDictionary = [arraySports objectAtIndex:indexPath.row - 1];
        NSString *sportName = [sportDictionary objectForKey:@"tag"];
        NSString *imageName = [sportDictionary objectForKey:@"image"];
        cell.labelSport.text = NSLocalizedString (sportName, nil);
        cell.labelSport.backgroundColor = [Utils primaryColor];
        cell.labelSport.layer.cornerRadius = 5;
        cell.labelSport.layer.masksToBounds = true;
        UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [cell.imageViewSport setImage:image];
        [cell.imageViewSport setTintColor:[Utils primaryColor]];
    }
    cell.contentView.alpha = 0.5;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cvWidth = self.collectionViewSports.frame.size.width;
    int rowsNum;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rowsNum = 4;
    } else {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
            rowsNum = 3;
        } else {
            rowsNum = 2;
        }
    }
    return CGSizeMake(cvWidth/rowsNum, cvWidth/rowsNum);
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BACK", nil)
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    [self.navigationItem.backBarButtonItem setTintColor:[Utils primaryColorDarker]];
    if ([[segue identifier] isEqualToString:@"idShowCompetitions"]) {
        CompetitionsTableViewController *viewController = (CompetitionsTableViewController *) segue.destinationViewController;
        viewController.sportSelectedTag = sportSelectedTag;
    } else if ([[segue identifier] isEqualToString:@"idShowFavorites"]) {
        //FavoritesTableViewController *viewController = (FavoritesTableViewController *) segue.destinationViewController;
    }
}

#pragma mark - private methods
-(void) enableSportButtons {
    for (int i=0; i<[self.collectionViewSports numberOfItemsInSection:0]; i++) {
        NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
        UICollectionViewCell *cell = [self.collectionViewSports cellForItemAtIndexPath:index];
        cell.contentView.alpha = 1;
    }
}


#pragma mark - GADBannerViewDelegate
//cuando se carga el anuncio
-(void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    bannerView.alpha = 0;
    [UIView animateWithDuration:3.0 animations:^{
        bannerView.alpha = 1;
    }];
}

//si falla la carga.
-(void)adView:(GADBannerView*) bannerView didFailToReceiveAdWithError:(nonnull GADRequestError *)error {
    NSLog(@"didFailToReceiveAdWithError");
    NSLog(@"%@", error.description);
}


//si el usuario clica sobre el anuncio.
-(void) adViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"adViewWillPresentScreen");
}

@end
