//
//  UrlPath.h
//  PatrolSystem
//
//  Created by 刘艳凯 on 2017/4/5.
//  Copyright © 2017年 YiTu. All rights reserved.
//

#ifndef UrlPath_h
#define UrlPath_h

//线上服务器地址
#define HostAdress @"http://www.yituinfo.cn/Patrolling/"
//本地服务器地址
//#define HostAdress @"http://192.168.100.29/Patrolling/"

//图片地址
#define picUrl @"http://www.yituinfo.cn/Patrolling"
//#define picUrl @"http://192.168.100.29/Patrolling"

//socket通信地址
#define socketAdress @"119.23.251.169"
//#define socketAdress @"192.168.100.29"
#define socketPort 8888
#define helpSocketPoet 8889 
//查看错误编码
#define allErrorAdress @"http://192.168.0.101/Patrolling/error.do/"

#define ConvertUrl(relativeUrl) [NSString stringWithFormat:@"%@%@", HostAdress, relativeUrl]


//接口地址
#define kUrl_Register                   ConvertUrl(@"interface/mobile/update/register.do")                          //用户注册
#define kUrl_Retrieve                   ConvertUrl(@"interface/mobile/update/forgotPassword.do")                   //找回密码
#define kUrl_WorkType                   ConvertUrl(@"interface/mobile/query/queryAllTypeOfWork.do")               //获取工种
#define kUrl_Login                       ConvertUrl(@"interface/mobile/query/login.do")                               //用户登录
#define kUrl_GetStaffTask               ConvertUrl(@"interface/mobile/query/queryCraft.do")                        //获取工作人员任务数据
#define kUrl_StaffState                 ConvertUrl(@"interface/mobile/query/userStatus.do")                        //获取用户工作状态
#define kUrl_QuickLogin                 ConvertUrl(@"interface/mobile/query/automaticLogin.do")                    //快速登录
#define kUrl_GetSignIn                  ConvertUrl(@"interface/mobile/query/accessToSignIn.do")                    //获取签到
#define kUrl_SignIn                      ConvertUrl(@"interface/mobile/update/sign_in.do")                           //用户打卡
#define KUrl_SignOut                     ConvertUrl(@"interface/mobile/update/sign_out.do")                          //下班打卡
#define kUrl_QuerySecurityLine         ConvertUrl(@"interface/mobile/query/queryAllTheSecurityLine.do")        //查询所有的安保路线
#define kUrl_PatrolRecord               ConvertUrl(@"interface/mobile/update/saveSecurityPatrolRecord.do")      //保存安保路线
#define kUrl_SubmitPatrolRecord        ConvertUrl(@"interface/mobile/update/updateNowLocationds.do")           //上传巡逻报告
#define kUrl_StartTask                   ConvertUrl(@"interface/mobile/query/openTask.do")                          //开始任务
#define kUrl_ConnectJudge               ConvertUrl(@"interface/mobile/query/connectJudge.do")                      //判断是否进入任务区域
#define kUrl_EndPatrol                   ConvertUrl(@"interface/mobile/update/EndPatrol.do")                        //结束巡逻
#define kUrl_QueryCleaningArea         ConvertUrl(@"interface/mobile/query/queryAllCleaningArea.do")            //查询所有保洁区域
#define kUrl_SaveCleaningArea          ConvertUrl(@"interface/mobile/update/saveCleaningRecords.do")            //保存打扫记录
#define kUrl_SubmitCleaningRecords    ConvertUrl(@"interface/mobile/update/endCleaningRecords.do")             //提交打扫报告
#define kUrl_GetAllFerryBus             ConvertUrl(@"interface/mobile/query/queryAllFerryPush.do")               //获取所有摆渡车
#define kUrl_GetAllFerryLine            ConvertUrl(@"interface/mobile/query/queryFeeryPushLine.do")              //获取所有摆渡车路线
#define kUrl_BindingFerryBus            ConvertUrl(@"interface/mobile/update/saveChooseShuttleBuses.do")        //绑定摆渡车
#define KUrl_ChangeFerryBus             ConvertUrl(@"interface/mobile/update/transfer.do")                          //更换摆渡车
#define KUrl_BindingFerryLine           ConvertUrl(@"interface/mobile/update/saveFerryPushRecord.do")            //绑定摆渡车路线
#define kUrl_SubFerryPushRecord        ConvertUrl(@"interface/mobile/update/submitFerryPushRecord.do")          //绑定路线和摆渡车
#define kUrl_GetAllBoat                  ConvertUrl(@"interface/mobile/query/queryAllPleasureBoat.do")             //获取所有游船
#define kUrl_SaveBoat                     ConvertUrl(@"interface/mobile/update/saveChoosePleasureBoat.do")         //绑定游船
#define kUrl_getBoatLine                 ConvertUrl(@"interface/mobile/query/queryAllCruiseLines.do")               //获取游船路线
#define kUrl_StartBoatRecord            ConvertUrl(@"interface/mobile/update/saveTheBoatCirculationRecords.do") //上传开船报告
#define kUrl_EndBoatRecord              ConvertUrl(@"interface/mobile/update/endTheBoatCirculationRecords.do")   //上传停船报告
#define kUrl_ChangeBoat                  ConvertUrl(@"interface/mobile/update/changeShips.do")                        //切换船只k
#define kUrl_GetAllPush                  ConvertUrl(@"interface/mobile/query/queryAllPush.do")                        //获取推送
#define kUrl_OneKeyHelp                  ConvertUrl(@"interface/mobile/update/openHelp.do")                            //开启一键求助
#define kUrl_SureComplete               ConvertUrl(@"interface/mobile/update/verifyComplete_tcp.do")                //确认任务完成
#define kUrl_ApplyFillCheck             ConvertUrl(@"interface/mobile/update/submitExamineApproveSign.do")        //申请补签
#define kUrl_LookFillCheck              ConvertUrl(@"interface/mobile/query/queryExamineApproveSignPaging.do")    //查看补签状态
#define kUrl_StaffAttendance            ConvertUrl(@"interface/mobile/query/queryClock.do")                           //获取当月考勤
#define kUrl_StaffHelpList              ConvertUrl(@"interface/mobile/query/queryEmergencyCalling.do")             //用户求助记录列表
#define kUrl_StaffHelpDetail            ConvertUrl(@"interface/mobile/query/getEmergencyCallingInfo.do")           //获取求助详细信息
#define kUrl_StaffHelpFinish            ConvertUrl(@"interface/mobile/update/accomplishEmergencyCalling.do")       //完成一键求助
#define kUrl_StaffUnusualList           ConvertUrl(@"interface/mobile/query/queryAbnormalNowLocationd.do")         //巡逻异常列表
#define kUrl_StaffUnusualDetail        ConvertUrl(@"interface/mobile/query/getNowLocationdsInfo.do")               //巡逻异常详细信息
#define kUrl_FinishUnusual              ConvertUrl(@"interface/mobile/update/accomplishNowLocationds.do")          //完成巡逻异常
#endif /* UrlPath_h */










