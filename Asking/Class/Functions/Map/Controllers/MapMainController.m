//
//  MapMainController.m
//  高德地图
//
//  Created by Lves Li on 14/12/17.
//  Copyright (c) 2014年 Lves. All rights reserved.
//

#import "MapMainController.h"

#import "BusListController.h"
#import "StartAnnotationView.h"
#import "CommonUtility.h"
#import "LineDashPolyline.h"
#import "FootBottomView.h"
#import "BusScrollContentView.h"
#import "StartAnnotation.h"
#import "MapNaviDetailController.h"
#import "BusTransitController.h"
#import "AppDelegate.h"


#define kPaddingW 7.f
#define kBottomViewH 60.f

#define kTopToolBarW 180.f
#define kTopToolBarH 44.f
#define kTopToolMarginW 0.f
///轨迹线的颜色
#define kStrokeColor [UIColor colorWithRed:42/255.f green:69/255.f blue:213/255.f alpha:0.9]
#define kMapSearchKey @"cbb2675cabed5fc7b447117fd87f4a31"


typedef enum{
    kAnnotationStart=0,
    kAnnotationEnd,
    kAnnotationNone,
    kAnnotationStartCoors,
    kAnnotationEndCoors,
    kAnnotationRoute
}AnnotationType;

@interface MapMainController ()<MAMapViewDelegate,AMapSearchDelegate,BusListControllerDelegate,BottomViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    MAMapView *_mapView;
    MAPointAnnotation *pointAnnotation;
    
    AMapSearchAPI *search; //地点搜索
    AMapSearchType mapSearchType; //搜索类型
    
    NSString *startPlace; //开始位置
    NSString *endPlace;   //结束位置
    
    ///选择开始位置
    NSString *_selectStartPlace;
    ///选择结束位置
    NSString *_selectEndPlace;
    
    
    AnnotationType annotationtype;//锚点类型
    
    BOOL startOk; //开始点经纬度OK
    BOOL endOk;   //终点OK
    CLLocationCoordinate2D startCoordinate; //开始点坐标
    CLLocationCoordinate2D endCoordinate;   //终点坐标
    MAAnnotationView *selectAnnotation;   //选择锚点
    
    NSString  *_userCurrentCity; //用户当前所在的城市
    
    UIButton *_busNaviBtn;//公交导航按钮
    UIButton *_carNaviBtn;//驾车导航按钮
    UIButton *_footNaviBtn;//步行导航按钮
    
    FootBottomView *_footBottomView;  //底部的步行介绍视图
    BOOL _isFootBottomViewShow;   //底部步行和私家车的视图是否存在
    
    BusListController *_busController; //公交方案视图
    BOOL _isBusControllerShow; //公交方案视图是否显示
    ///公交方案数组
    NSArray *_busTransitArray;
    ///公交滚动视图
    UIScrollView *_busScrollView;
    ///滚动视图是否显示
    BOOL _isBusScrollViewShow;
    
    UIPageControl *pageControl;
    NSUInteger currentPage;  //pageControl的当前页
    ///选择的步行或驾车方案
    AMapPath *_selectedMapPath;
    ///选择的公交方案
    AMapTransit *_selectedMapTransit;
    
    
    BOOL _isGetLocation;  //是否获得定位
    BOOL _isFromUserLocation;// 是否从用户当前位置出发
    
    ///用户当前坐标
    CLLocationCoordinate2D _userCoordinate2D;
    AppDelegate *appDelegate;
}

@end

@implementation MapMainController
#pragma mark 构造函数

-(id)initWithStartPlace:(NSString *)startP endPlace:(NSString *)endP{
    if(self=[super init]){
        startPlace=startP;
        endPlace=endP;
        startOk=NO;
        endOk=NO;
        
        appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        _userCurrentCity=appDelegate.cityName;
    }
    return self;
}


#pragma mark - 生命周期函数

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    //1.添加顶部toolbar
    [self buildTopToolBar];
    
    //2. 初始化地图
    [self buildMapView];
    
    //3.添加底部的视图
    [self buildBottomView];
    if(![CLLocationManager locationServicesEnabled]){
        //开始搜索
        [self startMap];
    }
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    
    //设置按钮字体
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:@"返回"
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:@selector(backButtonClick:)];
    self.navigationController.navigationBar.topItem.backBarButtonItem=btnBack;
   
}
-(void)backButtonClick:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    _mapView.delegate=nil;
    _mapView.showsUserLocation=NO;
    search.delegate=nil;
    
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mapView.delegate=self;
    _mapView.showsUserLocation=YES;
    [search setDelegate:self];
}




/*添加地图*/
-(void)buildMapView{
    //1. 注册服务
    [MAMapServices sharedServices].apiKey = kMapSearchKey;
    //添加地图和代理
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    //3. 显示用户位置
    _mapView.showsUserLocation = YES;    //YES 为打开定位，NO为关闭定位
    //    [_mapView setUserTrackingMode: MAUserTrackingModeFollowWithHeading animated:YES]; //地图跟着位置移动
    _mapView.showsScale = YES;
    _mapView.userInteractionEnabled=YES;
    
    
    //4. 搜索Api
    [MAMapServices sharedServices].apiKey = kMapSearchKey;
    search=[[AMapSearchAPI alloc] initWithSearchKey:kMapSearchKey Delegate:self];
    
    
    //地图控件
    _mapView.logoCenter = CGPointMake(kPaddingW+3.f, kScreenHeight-_mapView.logoSize.height-kBottomViewH);
}

/*
初始化底部视图
*/

-(void)buildBottomView{
   
   //1. 初始化底部步行和驾车的view
    _footBottomView=[[FootBottomView alloc] initWithFrame:CGRectMake(0, kScreenHeight-kBottomViewH, kScreenWidth, kBottomViewH)];
    _isFootBottomViewShow=NO;
    //2. 初始化地图方案视图
    _busController=[[BusListController alloc] initWithStyle:UITableViewStyleGrouped];
    _isBusControllerShow=NO;
    
    //3. 公交滚动视图
    _busScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, kScreenHeight-70.f, kScreenWidth, 70)];
    _busScrollView.backgroundColor=[UIColor whiteColor];
    _busScrollView.pagingEnabled=YES;
    _busScrollView.showsHorizontalScrollIndicator=NO;
    _busScrollView.delegate=self;
    _busScrollView.bounces=NO;
    _isBusScrollViewShow=NO;
    
    CGSize busScrollViewSize=_busScrollView.frame.size;
    pageControl=[[UIPageControl alloc] init];
    pageControl.center=CGPointMake(busScrollViewSize.width/2.f,kScreenHeight-7.5f);
    pageControl.pageIndicatorTintColor=[UIColor colorWithRed:240/255.f green:240/255.f blue:240/255.f alpha:1];
    pageControl.currentPageIndicatorTintColor=[UIColor grayColor];
    [pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    pageControl.bounds=CGRectMake(0, 0, 100, 15);
        
}


/*
添加顶部的导航方式按钮
*/
-(void)buildTopToolBar{
    
    //添加顶部的ToolBar
    UIView *topToolView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, kTopToolBarW, kTopToolBarH)];
    [topToolView setBackgroundColor:[UIColor clearColor]];
    
    CGFloat btnW=kTopToolBarW/3.f;
    //1.公交
    _busNaviBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, kTopToolBarH)];
    [_busNaviBtn setImage:[UIImage imageNamed:@"icon_navibar_bus"] forState:UIControlStateNormal];
    [_busNaviBtn setImage:[UIImage imageNamed:@"icon_navibar_bus_highlighted"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [_busNaviBtn addTarget:self action:@selector(busNaviBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topToolView addSubview:_busNaviBtn];
    
    //2. 私家车
    _carNaviBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_busNaviBtn.frame)+kTopToolMarginW, 0, btnW, kTopToolBarH)];
    [_carNaviBtn setImage:[UIImage imageNamed:@"icon_navibar_car"] forState:UIControlStateNormal];
    [_carNaviBtn setImage:[UIImage imageNamed:@"icon_navibar_car_highlighted"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [_carNaviBtn addTarget:self action:@selector(carNaviBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topToolView addSubview:_carNaviBtn];
    //3. 步行
    _footNaviBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_carNaviBtn.frame)+kTopToolMarginW, 0, btnW, kTopToolBarH)];
    [_footNaviBtn setImage:[UIImage imageNamed:@"icon_navibar_foot"] forState:UIControlStateNormal];
    [_footNaviBtn setImage:[UIImage imageNamed:@"icon_navibar_foot_highlighted"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [_footNaviBtn addTarget:self action:@selector(footNaviBtnClick:) forControlEvents:UIControlEventTouchDown];
    [topToolView addSubview:_footNaviBtn];
    //添加toolBar
    self.navigationItem.titleView = topToolView;
    
    


}

#pragma mark 
-(void)startMap{
    
    //默认私家车搜索
    mapSearchType=AMapSearchType_NaviDrive;
    _carNaviBtn.selected=YES;
    [_carNaviBtn setImage:[UIImage imageNamed:@"icon_navibar_car_highlighted"] forState:UIControlStateSelected];
    

    
    //1.）有开始点
    if (startPlace.length>0&&![startPlace isEqualToString:@"当前位置"]) {
         _isFromUserLocation=NO;
        [self searchPlaceByKey:startPlace]; //开始搜索开始点
        
        
    }else{    //2.) 没有开始点，从用户位置出发
        _isFromUserLocation=YES;
        if (_userCoordinate2D.latitude!=0&&_userCoordinate2D.longitude!=0) {
            startCoordinate=_userCoordinate2D;
        }else{
            startCoordinate=appDelegate.userLocation;
        }
        
        startOk=YES;
        _selectStartPlace=@"当前位置";
        
        
        if (endPlace.length>0&&![endPlace isEqualToString:@"当前位置"]) {
            [self searchPlaceByKey:endPlace]; //开始搜索终点
        }else{
            if (_userCoordinate2D.latitude!=0&&_userCoordinate2D.longitude!=0) {
                endCoordinate=_userCoordinate2D;
            }else{
                endCoordinate=appDelegate.userLocation;
            }
            endOk=YES;
            _selectEndPlace=@"当前位置";
        }
    }
    
    if (startOk&&endOk) {
        [self searchNaviByType:mapSearchType];
    }


}

#pragma mark - 点击搜索方式按钮

-(void)busNaviBtnClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    btn.selected=YES;
    
    if (btn.selected) {
        _carNaviBtn.selected=NO;
        _footNaviBtn.selected=NO;
        [btn setImage:[UIImage imageNamed:@"icon_navibar_bus_highlighted"] forState:UIControlStateSelected];
        [self searchNaviByType:AMapSearchType_NaviBus];
    }
    
}

-(void)carNaviBtnClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    btn.selected=YES;
   
    if (btn.selected) {
        _busNaviBtn.selected=NO;
        _footNaviBtn.selected=NO;
        [btn setImage:[UIImage imageNamed:@"icon_navibar_car_highlighted"] forState:UIControlStateSelected];
        [self searchNaviByType:AMapSearchType_NaviDrive];
    }
}

-(void)footNaviBtnClick:(id)sender{
    UIButton *btn=(UIButton *)sender;
    btn.selected=YES;
    
    if (btn.selected) {
        _carNaviBtn.selected=NO;
        _busNaviBtn.selected=NO;
        [btn setImage:[UIImage imageNamed:@"icon_navibar_foot_highlighted"] forState:UIControlStateSelected];
        [self searchNaviByType:AMapSearchType_NaviWalking];
    }
}




#pragma mark 关键字搜索
- (void)searchPlaceByKey:(NSString *)key
{
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = key;
    poiRequest.offset=10;
    if (_userCurrentCity.length<=0) {
        UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"提醒" message:@"定位失败，请检查定位服务设置！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    poiRequest.city = @[_userCurrentCity];
    poiRequest.requireExtension = YES;
    [search AMapPlaceSearch: poiRequest];
    
}
#pragma mark 添加锚点
/*
 添加锚点
 @param pois：锚点数组
 @return nil
 */
-(void)initAnnotations:(NSArray *)pois{
    
    NSMutableArray *annotations = [[NSMutableArray alloc] initWithCapacity:pois.count];
    int i = 1;
    if (startOk==NO) {
        annotationtype=kAnnotationStartCoors;//选择开始点
    }else{
        annotationtype=kAnnotationEndCoors;  //选择结束点
    }
    for (AMapPOI *poi in pois)
    {
        MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(poi.location.latitude, poi.location.longitude);
        annotation.title = [NSString stringWithFormat:@"%d",i];
        annotation.subtitle = poi.name;
        i++;
        [annotations addObject:annotation];
    }
    
    //添加锚点
    [_mapView addAnnotations:annotations];
    //显示锚点区域
    [_mapView showAnnotations:annotations animated:YES];
    
}
#pragma mark 添加起始点
-(void)addStartAndEndAnnotation{
    //1. 设置锚点类型
    annotationtype=kAnnotationRoute;
    //2. 添加起始点
     if (_isFromUserLocation==NO) {
        StartAnnotation *startAnnotation = [[StartAnnotation alloc] init];
        startAnnotation.coordinate = CLLocationCoordinate2DMake(startCoordinate.latitude,startCoordinate.longitude);
        [_mapView addAnnotation:startAnnotation];
     }

    MAPointAnnotation *endAnnotation = [[MAPointAnnotation alloc] init];
    endAnnotation.coordinate = CLLocationCoordinate2DMake(endCoordinate.latitude,endCoordinate.longitude);
    [_mapView addAnnotation:endAnnotation];

}

#pragma mark - 点击公交方案Controller的cell代理函数
-(void)busListControllerClickedCell:(NSUInteger)index{
    //获得点击的方案
    AMapTransit *currentTransit= _busTransitArray[index];
    _selectedMapTransit=currentTransit;
    //1.1 去除视图
    if(_isBusControllerShow){
        [[self.view viewWithTag:8400] removeFromSuperview];
        _isBusControllerShow=NO;
    }
    //1.2 添加滚动视图
    pageControl.numberOfPages=_busTransitArray.count;
    pageControl.currentPage=index;
    currentPage=index;
    
    _busScrollView.contentSize=CGSizeMake(kScreenWidth*_busTransitArray.count, 70);
    //添加子视图
    for (int i=0;i<_busTransitArray.count;i++) {
        AMapTransit *mapTransit = _busTransitArray[i];
        BusScrollContentView *busContent=[[BusScrollContentView alloc] initWithFrame:CGRectMake(kScreenWidth*i, 0, kScreenWidth, 70)];
        busContent.transit=mapTransit;
        if (i==_busTransitArray.count-1) { //最后一个不显示下一个按钮
            busContent.hasNext=NO;
        }
        
        [_busScrollView addSubview:busContent];
        
        
        //添加单击事件
        UITapGestureRecognizer *tapBusNaviRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBusNaviView:)];
        tapBusNaviRecognizer.delegate=self;
        [busContent.contentWebView addGestureRecognizer:tapBusNaviRecognizer];
        
    }
    [_busScrollView scrollRectToVisible:CGRectMake(kScreenWidth*index, 0, kScreenWidth, 70) animated:NO];
    
    if (_isBusScrollViewShow==NO) {
        
        [self.view addSubview:_busScrollView];
        [self.view addSubview:pageControl];
        _isBusScrollViewShow=YES;
    }
    
    
    
    //1.3 绘制路线轨迹
    
    [self buildBusOverlays:currentTransit];
    
    
    
    

}
#pragma mark UIGestureRecognizerClick
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
#pragma mark 点击某一个公交方案View
-(void)tapBusNaviView:(id)sender{
    BusTransitController *busTransitController=[[BusTransitController alloc] init];
    busTransitController.busTransit=_selectedMapTransit;
    [busTransitController setStartPlace:_selectStartPlace andEndPlace:_selectEndPlace];
    [self.navigationController pushViewController:busTransitController animated:YES];
    
    
}


#pragma mark - SearchPDelegate
#pragma mark 地点搜索完毕
/*
 
 地点搜索回调，如果有结果添加锚点，否则提示。
 
*/
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
   
    if (response.count > 0)
    {
        [_mapView removeAnnotations:_mapView.annotations];
        [self initAnnotations:response.pois]; //添加锚点
    }else{
        NSLog(@"%@",@"未找到");
    }
    
}



#pragma mark 路径搜索回调
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest *)request response:(AMapNavigationSearchResponse *)response
{
    
    
    if(response.count>0){ //搜索结果不为空
        
        if (mapSearchType==AMapSearchType_NaviBus) {                                                   //1. 公交路线
            NSArray *transits = response.route.transits;
            _busTransitArray=[transits subarrayWithRange:NSMakeRange(0, 5)];
            
            //1.1 隐藏底部的footbottomView
            if (_isFootBottomViewShow) {
                [_footBottomView removeFromSuperview];
                _isFootBottomViewShow=NO;
            }
            //添加bus方案视图
            _busController.transitArray=_busTransitArray;
            _busController.startPlaceStr=_selectStartPlace;
            _busController.endPlaceStr=_selectEndPlace;
            
            if (_isBusControllerShow==NO) {
                _busController.view.tag=8400;
                UIView *view=_busController.view;
                view.frame=CGRectMake(0, 54, kScreenWidth, kScreenHeight-54);
                [self.view addSubview:view];
                _busController.delegate=self;
                
                _isBusControllerShow=YES;
            }
            
        }else if(mapSearchType==AMapSearchType_NaviDrive|mapSearchType==AMapSearchType_NaviWalking){   //2. 步行或者驾车路线
            //2.1 清楚地图上的锚点和轨迹
            [self clearMap];
            //2.1.1 去除Bus方案控制器视图
            if(_isBusControllerShow){
                [[self.view viewWithTag:8400] removeFromSuperview];
                _isBusControllerShow=NO;
            }
            if (_isBusScrollViewShow) {
                [_busScrollView removeFromSuperview];
                [pageControl removeFromSuperview];
                _isBusScrollViewShow=NO;
            }
            
            
            NSMutableArray *polylinesArray = [[NSMutableArray alloc] init];
            AMapRoute *route=response.route;
            
            //2.2 把所有的都画出来
            
            for (AMapPath *path in route.paths)
            {
                NSArray *polylines = nil;
                polylines = [CommonUtility polylinesForPath:path];
                
                [_mapView addOverlays:polylines];  //在地图上画路径
                
                [polylinesArray addObjectsFromArray:polylines];
            }
            
            //2.3 设置标题和子标题
            AMapPath *path=nil;
            if (route.paths.count>0) {
                path=route.paths[0];
            }
            _selectedMapPath=path; //设置选择的交通方案
            //设置底部视图
            [_footBottomView setBottomViewDistance:path.distance andDuration:path.duration andTaxiCost:route.taxiCost];
            
            if (_isFootBottomViewShow==NO) {
                [self.view addSubview:_footBottomView];
                _footBottomView.delegate=self;
                _isFootBottomViewShow=YES;
            }
            
            /* 缩放地图使其适应polylines的展示. */
            [_mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:polylinesArray] edgePadding:UIEdgeInsetsMake(180, 50, 150, 50) animated:YES];
            //添加起点终点两个锚点
            [self addStartAndEndAnnotation];
            
        }
    
    }

}

#pragma mark 绘制公交路线
/*
 绘制公交方案
 @param mapTransit 公交方案
 @return void
*/
-(void)buildBusOverlays:(AMapTransit *)mapTransit{
    //1.清除以前的路线
    [self clearMap];
    //1.2 重新绘制路线
    NSMutableArray *polylinesArray = [[NSMutableArray alloc] init];
    //1.3 获得公交方案，便利每一个路段
    for (AMapSegment *segment in mapTransit.segments)
    {
        NSArray *polylines = nil;
        
        polylines = [CommonUtility polylinesForSegment:segment];
        
        [_mapView addOverlays:polylines];  //在地图上画路径
        
        [polylinesArray addObjectsFromArray:polylines];
    }
    
    /* 1.4 缩放地图使其适应polylines的展示. */
    [_mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:polylinesArray] edgePadding:UIEdgeInsetsMake(170, 40, 150, 40) animated:YES];
    //1.5 添加起点终点两个锚点
    [self addStartAndEndAnnotation];

}
#pragma mark  选中摸个锚点
- (void)selectAnnotation:(id < MAAnnotation >)annotation
{
    [_mapView selectAnnotation:annotation animated:NO];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    
    if (annotationtype==kAnnotationStartCoors||annotationtype==kAnnotationEndCoors) { //选择开始
        
        
        if ([annotation isKindOfClass:[MAPointAnnotation class]])
        {
            static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
            StartAnnotationView *annotationView = (StartAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[StartAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:userLocationStyleReuseIndetifier];
            }
            MAPointAnnotation *ann = (MAPointAnnotation *)annotation;
            annotationView.name=ann.subtitle;
            if (annotationtype==kAnnotationStartCoors) {
                [annotationView setBtnTitile:@"起点"];
                [annotationView.startButton addTarget:self action:@selector(startFromHere:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [annotationView setBtnTitile:@"终点"];
                [annotationView.startButton addTarget:self action:@selector(endThere:) forControlEvents:UIControlEventTouchUpInside];
            }
            //默认选中第一个
            NSUInteger index=[_mapView.annotations indexOfObject:annotation];
            if (0==index) {
                [self performSelector:@selector(selectAnnotation:) withObject:[_mapView.annotations firstObject] afterDelay:0.5];
            }

            
            return annotationView;
        }
        
    }else if (annotationtype==kAnnotationRoute){
        if ([annotation isKindOfClass:[StartAnnotation class]]){
            
            static NSString *userLocationStyleReuseIndetifier = @"DefaultReuseIndetifier";
            MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:userLocationStyleReuseIndetifier];
            }
            
           annotationView.image=[UIImage imageNamed:@"default_common_route_startpoint_normal"];
           return annotationView;
        
        }else if ([annotation isKindOfClass:[MAPointAnnotation class]])
        {
            static NSString *userLocationStyleReuseIndetifier = @"DefaultReuseIndetifier";
            MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
            if (annotationView == nil)
            {
                annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                              reuseIdentifier:userLocationStyleReuseIndetifier];
            }
            
            annotationView.image=[UIImage imageNamed:@"default_common_route_endpoint_normal"];
            
            return annotationView;
        }
        

    }
    
   
    return nil;
}

#pragma mark 绘制路径回调函数
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[LineDashPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        
        overlayView.lineWidth   = 8;
        overlayView.strokeColor =kStrokeColor;
        overlayView.lineDash =YES;  //是否绘制成虚线
        
        return overlayView;
    }else if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *overlayView = [[MAPolylineView alloc] initWithPolyline:overlay];
        
        overlayView.lineWidth   = 8.5f;
        overlayView.strokeColor =kStrokeColor;
        overlayView.lineJoinType=kMALineJoinRound;//连接类型
        overlayView.lineCapType = kMALineCapRound;//端点类型
        return overlayView;
    }
    return nil;
}


/*
 点击锚点
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    selectAnnotation=view;
}


/*
当位置跟新时的回调
*/
-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation==YES)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        _userCoordinate2D=userLocation.coordinate;
        
        if(_isGetLocation==NO){
            _isGetLocation=YES;
            //开始搜索
            [self startMap];
            
        }

    }
}


#pragma mark - 点击锚点
#pragma mark 选择开始点
-(void)startFromHere:(id)sender{
    
    if (selectAnnotation) {
//        StartAnnotation *annotation= selectAnnotation.annotation;
        //确定开始点
        startCoordinate=[selectAnnotation.annotation coordinate];
        startOk=YES;
        
        _selectStartPlace=[(StartAnnotationView *)selectAnnotation name];
        

        if (endPlace.length>0&&![endPlace isEqualToString:@"当前位置"]) {
            [self searchPlaceByKey:endPlace]; //开始搜索终点
        }else{
            if (_userCoordinate2D.latitude!=0&&_userCoordinate2D.longitude!=0) {
                endCoordinate=_userCoordinate2D;
            }else{
                endCoordinate=appDelegate.userLocation;
            }
            endOk=YES;
            _selectEndPlace=@"当前位置";
        }
        

        if (startOk&&endOk) {
            [self searchNaviByType:mapSearchType];
        }
        
        
    }

}
#pragma mark 选择终点
-(void)endThere:(id)sender{
    
    if (selectAnnotation) {
        _selectEndPlace=[(StartAnnotationView *)selectAnnotation name];
        //确定终点
        endCoordinate=[selectAnnotation.annotation coordinate];
        endOk=YES;
    }
    if (startOk&&endOk) {
        [self searchNaviByType:mapSearchType];
    }
    
}

#pragma mark - 路径规划
- (void)searchNaviByType:(AMapSearchType)searchType
{
    if(startOk &&endOk){
        
        AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
        naviRequest.searchType = searchType;
        mapSearchType=searchType; //设置搜索类型
        naviRequest.requireExtension = YES;
        naviRequest.city = _userCurrentCity; //设置用户当前城市 ,公交一定要设置
        naviRequest.origin = [AMapGeoPoint locationWithLatitude:startCoordinate.latitude longitude:startCoordinate.longitude];
        naviRequest.destination = [AMapGeoPoint locationWithLatitude:endCoordinate.latitude longitude:endCoordinate.longitude];
        [search AMapNavigationSearch: naviRequest]; //开始搜索

    }
    
}

#pragma mark - 清楚所有锚点和路径
-(void)clearMap{
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
}

#pragma mark - ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSInteger page= scrollView.contentOffset.x/kScreenWidth;
    if (currentPage==page) {
        return;
    }
    
    pageControl.currentPage=page;
    currentPage=page;
    _selectedMapTransit=_busTransitArray[page];
    

    //绘制路径
   [self buildBusOverlays:_selectedMapTransit];
    
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"endScroll");
}
#pragma mark 点击PageControl
-(void)pageControlClicked:(UIPageControl *)cPageControl{
    NSInteger page=cPageControl.currentPage;
    currentPage=page;
    [_busScrollView scrollRectToVisible:CGRectMake(kScreenWidth*page, 0, kScreenWidth, 70) animated:YES];
    
}
#pragma mark BorttomViewDelegate
-(void)tapDetailView{
    MapNaviDetailController *naviDetailController=[[MapNaviDetailController alloc] init];
    //设置起始地
    naviDetailController.startPlace=_selectStartPlace;
    naviDetailController.endPlace=_selectEndPlace;
    //如果是驾车或者是步行
    if (mapSearchType==AMapSearchType_NaviDrive||mapSearchType==AMapSearchType_NaviWalking) {
        //设置路径方案
        naviDetailController.mapPath=_selectedMapPath;
       
    }else if (mapSearchType==AMapSearchType_NaviBus){
        return;
        
    }
    
    
    [self.navigationController pushViewController:naviDetailController  animated:YES];
    
}


@end
