//
//  FavoriteTeamEntity+CoreDataProperties.m
//  LocalSports
//
//  Created by Antonio Díaz Arroyo on 20/12/17.
//  Copyright © 2017 cice. All rights reserved.
//
//

#import "FavoriteTeamEntity+CoreDataProperties.h"

@implementation FavoriteTeamEntity (CoreDataProperties)

+ (NSFetchRequest<FavoriteTeamEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FavoriteTeamEntity"];
}

@dynamic isFavorite;
@dynamic teamName;
@dynamic idCompetitionServer;

@end
