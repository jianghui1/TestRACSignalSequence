//
//  TestRACSignalSequenceTests.m
//  TestRACSignalSequenceTests
//
//  Created by ys on 2018/8/17.
//  Copyright © 2018年 ys. All rights reserved.
//

#import <XCTest/XCTest.h>

#import <ReactiveCocoa.h>
#import <RACSignalSequence.h>

@interface TestRACSignalSequenceTests : XCTestCase

@end

@implementation TestRACSignalSequenceTests

- (void)test_sequenceWithSignal
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSequence *sequence = [RACSignalSequence sequenceWithSignal:signal];
    
    NSLog(@"sequenceWithSignal -- %@", sequence);
    
    // 打印日志：
    /*
     2018-08-17 17:08:33.093062+0800 TestRACSignalSequence[50146:18295650] sequenceWithSignal -- <RACSignalSequence: 0x60400023fe80>{ name = , values = (
     1
     ) … }
     */
}

- (void)test_head
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSequence *sequence = [RACSignalSequence sequenceWithSignal:signal];
    
    NSLog(@"head -- %@", sequence.head);
    
    // 打印日志：
    /*
     2018-08-17 17:10:39.537477+0800 TestRACSignalSequence[50245:18302711] head -- 1
     */
}

- (void)test_tail
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSequence *sequence = [RACSignalSequence sequenceWithSignal:signal];
    
    NSLog(@"tail -- %@", sequence.tail);
    
    // 打印日志：
    /*
     2018-08-17 17:12:54.839794+0800 TestRACSignalSequence[50350:18310055] tail -- <RACSignalSequence: 0x60400023c820>{ name = , values = (
     2
     ) … }
     */
}

- (void)test_array
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSequence *sequence = [RACSignalSequence sequenceWithSignal:signal];
    
    NSLog(@"array -- %@", sequence.array);
    
    // 打印日志：
    /*
     2018-08-17 17:17:30.637284+0800 TestRACSignalSequence[50521:18323552] array -- (
     1,
     2
     )
     */
}

@end
