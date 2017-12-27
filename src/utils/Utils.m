#import "Utils.h"
#import "Reachability.h"

@implementation Utils

+(NSString*) enumSportToString:(EnumSports)enumSport {
    switch (enumSport) {
        case FOOTBALL:
            return @"FUTBOL_11";
        case BASKETBALL:
            return @"BALONCESTO";
        case VOLLEYBALL:
            return @"VOLEIBOL";
        case HANDBALL:
            return @"BALONMANO";
        case HOCKEY:
            return @"UNIHOCKEY";
        default:
            break;
    }
}

+(void)showComingSoon {
    [self showAlert:@"comming soon"];
}

+(void)showAlert:(NSString *) alertDesc {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:APP_NAME message:alertDesc delegate:self cancelButtonTitle:@"Accept" otherButtonTitles: nil];
    [alertView show];
}

+(NSString*) formatDate:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
    return [dateFormatter stringFromDate:date];
}

+(NSDate*) formatDateDoubleToDate:(double) dateDouble {
    double timestampval = dateDouble / 1000;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    return [NSDate dateWithTimeIntervalSince1970:timestamp];
}

+(NSString*) formatDateDoubleToStr:(double) dateDouble {
    NSDate* date = [self formatDateDoubleToDate:dateDouble];
    return [self formatDate:date];
}

+(NSString *) dictionaryToString:(NSDictionary *) dictionary {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = nil;
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (BOOL) noTengoInterne {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    return networkStatus == NotReachable;
}

+ (UIImage *)imageWithSize:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (void)actionShareMatch:(NSString*) textToShare inViewController:(UIViewController *) viewController {
    NSArray *contents = @[textToShare];
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:contents applicationActivities:nil];
    controller.modalPresentationStyle = UIModalPresentationPopover;
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.sourceView = viewController.view;
    [viewController presentViewController:controller animated:YES completion:nil];
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        if (completed) {
            NSLog(@"We used activity type%@", activityType);
        } else {
            NSLog(@"We didn't want to share anything after all.");
        }
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}

+(UIColor *) primaryColor {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];    
    NSInteger colorInt = [userDefaults integerForKey:PREF_PRIMARY_COLOR];
    if (colorInt == 0) {
        colorInt = COLOR_PRIMARY;
    }
    return UIColorFromRGB(colorInt);
}

+(UIColor *) primaryColorDarker {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger colorInt = [userDefaults integerForKey:PREF_PRIMARY_COLOR];
    if (colorInt == 0) {
        colorInt = COLOR_PRIMARY;
    }
    return [self darkerColorForColor:UIColorFromRGB(colorInt)];
}

+(UIColor *) primaryColorLighter {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger colorInt = [userDefaults integerForKey:PREF_PRIMARY_COLOR];
    if (colorInt == 0) {
        colorInt = COLOR_PRIMARY;
    }
    return [self lighterColorForColor:UIColorFromRGB(colorInt)];
}

+(UIColor *) accentColor {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger colorInt = [userDefaults integerForKey:PREF_ACCENT_COLOR];
    if (colorInt == 0) {
        colorInt = COLOR_ACCENT;
    }
    return UIColorFromRGB(colorInt);
}

+(NSInteger)intFromHexString:(NSString *) hexStr {
    unsigned int hexInt = 0;
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@"#"]];
    // Scan hex value
    [scanner scanHexInt:&hexInt];
    return hexInt;
}

+ (UIColor *)lighterColorForColor:(UIColor *)c {
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

+ (UIColor *)darkerColorForColor:(UIColor *)c {
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}
@end
