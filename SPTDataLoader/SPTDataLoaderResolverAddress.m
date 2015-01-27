/*
 * Copyright (c) 2015 Spotify AB.
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
#import "SPTDataLoaderResolverAddress.h"

@interface SPTDataLoaderResolverAddress ()

@property (nonatomic, assign) NSTimeInterval stalePeriod;

@property (nonatomic, assign) CFAbsoluteTime lastFailedTime;

@end

@implementation SPTDataLoaderResolverAddress

#pragma mark SPTDataLoaderResolverAddress

- (BOOL)isReachable
{
    CFAbsoluteTime currentTime = CFAbsoluteTimeGetCurrent();
    NSTimeInterval deltaTime = currentTime - self.lastFailedTime;
    if (deltaTime < 0.0) {
        return YES;
    }
    
    return deltaTime > self.stalePeriod;
}

+ (instancetype)dataLoaderResolverAddressWithAddress:(NSString *)address
{
    return [[self alloc] initWithAddress:address];
}

- (instancetype)initWithAddress:(NSString *)address
{
    const NSTimeInterval SPTDataLoaderResolverAddressDefaultStalePeriodOneHour = 60.0 * 60.0;
    
    if (!(self = [super init])) {
        return nil;
    }
    
    _address = address;
    _stalePeriod = SPTDataLoaderResolverAddressDefaultStalePeriodOneHour;
    
    return self;
}

- (void)failedToReach
{
    self.lastFailedTime = CFAbsoluteTimeGetCurrent();
}

@end

