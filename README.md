##### `RACSignalSequence`作为`RACSequence`的子类，提供了一个方法通过`RACSignal`初始化一个`RACSequence`。

完整测试用例[在这里](https://github.com/jianghui1/TestRACSignalSequence)。

查看`.m`中的方法：

    + (RACSequence *)sequenceWithSignal:(RACSignal *)signal {
    	RACSignalSequence *seq = [[self alloc] init];
    
    	RACReplaySubject *subject = [RACReplaySubject subject];
    	[signal subscribeNext:^(id value) {
    		[subject sendNext:value];
    	} error:^(NSError *error) {
    		[subject sendError:error];
    	} completed:^{
    		[subject sendCompleted];
    	}];
    
    	seq->_subject = subject;
    	return seq;
    }
方法中初始化`RACSignalSequence` `RACReplaySubject`对象，并对参数`signal`完成了订阅，此时通过`RACReplaySubject`保存信号的信息。所以，通过`seq`可以获取`signal`的所有信息。

测试用例：

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
***

    - (id)head {
    	id value = [self.subject firstOrDefault:self];
    
    	if (value == self) {
    		return nil;
    	} else {
    		return value ?: NSNull.null;
    	}
    }
通过`firstOrDefault:`获取`subject`的第一个值，作为`head`值。

测试用例：

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
***

    - (RACSequence *)tail {
    	RACSequence *sequence = [self.class sequenceWithSignal:[self.subject skip:1]];
    	sequence.name = self.name;
    	return sequence;
    }
通过`skip:1`获取信号除去第一个值之后的信号，并通过`sequenceWithSignal:`生成一个`RACSequence`对象作为`tail`值。

测试用例：

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
***

    - (NSArray *)array {
    	return self.subject.toArray;
    }
通过`toArray`获取到信号值组成的数组。

测试用例：

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
***
格式化日志方法不再分析。

##### 所以，这个类的功能就是将一个信号转换成一个序列，通过序列的方法获取信号的值。
