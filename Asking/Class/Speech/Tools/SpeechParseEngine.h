//
//  SpeechParseEngine.h
//  Asking
//
//  Created by Lves Li on 14/11/21.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FunctionModel.h"
#import "MessageModel.h"




@interface SpeechParseEngine : NSObject

/*解析语音获得模型*/
-(id)parseSpeechByDictionary:(NSDictionary *)dic;



@end
