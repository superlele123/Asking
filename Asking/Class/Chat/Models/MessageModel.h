//
//  MessageModel.h
//  Asking
//
//  Created by Lves Li on 14/11/7.
//  Copyright (c) 2014年 Lves. All rights reserved.
//  消息Model

#import <Foundation/Foundation.h>

/*!
 @enum
 @brief 聊天类型
 @constant eMessageBodyType_Text 文本类型
 @constant eMessageBodyType_Image 图片类型
 @constant eMessageBodyType_Video 视频类型
 @constant eMessageBodyType_Location 位置类型
 @constant eMessageBodyType_Voice 语音类型
 @constant eMessageBodyType_File 文件类型
 @constant eMessageBodyType_Command 命令类型
 */
typedef enum {
    MessageBodyType_Text = 1,
    MessageBodyType_Image,
    MessageBodyType_Video,
    MessageBodyType_Location,
    MessageBodyType_Voice,
    MessageBodyType_File,
    MessageBodyType_Command
}MessageBodyType;




@interface MessageModel : NSObject
///消息体类型
@property (nonatomic) MessageBodyType type;
//@property (nonatomic) MessageDeliveryState status;

///是否是发送者
@property (nonatomic) BOOL isSender;
///是否已读
@property (nonatomic) BOOL isRead;
//是否是群聊
@property (nonatomic) BOOL isChatGroup;

@property (nonatomic, strong) NSString *messageId;
///头像地址
@property (nonatomic, strong) NSURL *headImageURL;
///昵称
@property (nonatomic, strong) NSString *nickName;
///用户名
@property (nonatomic, strong) NSString *username;

//text
///消息内容
@property (nonatomic, strong) NSString *content;

//image

///图片大小
@property (nonatomic) CGSize size;
///图片缩略图大小
@property (nonatomic) CGSize thumbnailSize;
///云端图片连接
@property (nonatomic, strong) NSURL *imageRemoteURL;
///略缩图云端图片连接
@property (nonatomic, strong) NSURL *thumbnailRemoteURL;
///本地图片
@property (nonatomic, strong) UIImage *image;
///本地图片略缩图
@property (nonatomic, strong) UIImage *thumbnailImage;


//audio
///本地路径
@property (nonatomic, strong) NSString *localPath;
///远程路径
@property (nonatomic, strong) NSString *remotePath;
///时间
@property (nonatomic) NSInteger time;
//@property (nonatomic, strong) EMChatVoice *chatVoice;
///是否正在播放
@property (nonatomic) BOOL isPlaying;
///是否播放完
@property (nonatomic) BOOL isPlayed;



//location
@property (nonatomic, strong) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

//@property (nonatomic, strong)id<IEMMessageBody> messageBody;
//@property (nonatomic, strong)EMMessage *message;


@end
