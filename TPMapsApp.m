//
//  TPMapsApp.m
//
//  Created by Mark Ferlatte on 9/11/13.
//  Copyright (c) 2013 Tetherpad, Inc. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <dispatch/dispatch.h>

#import "TPMapsApp.h"
#import "TPAppleMapsApp.h"
#import "TPGoogleMapsApp.h"
#import "TPWazeMapsApp.h"

@implementation TPMapsApp

#pragma mark - Class methods

+ (NSArray *)availableMapsApps {
    static NSArray *mapsApps;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // The order of this array is important; it should be ordered from least common to most common so that
        // we default to  maps app that the customer has explicitly installed, and then fall back to the common ones.
        mapsApps = @[
                     [[TPWazeMapsApp alloc] init],
                     [[TPGoogleMapsApp alloc] init],
                     [[TPAppleMapsApp alloc] init]
                     ];

    });
    return mapsApps;
}

+ (NSArray *)installedMapsApps {
    NSArray *mapsApps = [self availableMapsApps];
    NSIndexSet *installedApps = [mapsApps indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        TPMapsApp *app = obj;
        return app.installed;
    }];
    return [mapsApps objectsAtIndexes:installedApps];
}

+ (TPMapsApp *)mapsAppWithIdentifier:(NSString *)identifier {
    NSArray *availableMapsApps = [self availableMapsApps];
    for (TPMapsApp *app in availableMapsApps) {
        if ([app.identifier isEqualToString:identifier]) {
            return app;
        }
    }
    return nil;
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<TPMapApp name:%@>", self.name];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    if (! [object isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToMapsApp:object];
}

- (NSUInteger)hash {
    return [self.identifier hash];
}

#pragma mark - TPMapsApp

- (NSString *)name {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)isInstalled {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (NSString *)identifier {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)isEqualToMapsApp:(TPMapsApp *)mapsApp {
    if (! mapsApp) {
        return NO;
    }
    return [self.identifier isEqualToString:mapsApp.identifier];
}

- (BOOL)openWithQuery:(NSString *)query {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)openForDirectionsWithStart:(NSString *)start
                       destination:(NSString *)destination
                        travelMode:(enum TPMapsAppTravelMode)travelMode {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

- (BOOL)openMapsAppWithBaseURLString:(NSString *)baseURLString params:(NSDictionary *)params {
    NSString *queryString = [NSString stringWithFormat:@"?%@",
                             AFQueryStringFromParametersWithEncoding(params, NSUTF8StringEncoding)];
    NSString *mapURLString = [baseURLString stringByAppendingString:queryString];
    return [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapURLString]];
}

@end
