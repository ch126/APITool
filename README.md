# ChAPITool
a api tool

```Objective-C

//upload one data
NSData * yourData;
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    [ApiBox uploadBinary:yourData withURL:@"http://your_api.php" withAttName:@"your_att_name"];
});

//upload multiple datas
NSData * data1;
NSData * data2;
NSData * data3;    
NSDictionary * yourDataDic = @{ @"att_name_1" : data1,
                                @"att_name_2" : data2,
                                @"att_name_3" : data3};
                                
[ChAPITool uploadWithDataDic:yourDataDic withURL:@"http://your_api.php"];
