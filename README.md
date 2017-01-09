# Unity Ads 集成实践

此文档更新于2017年1月5日,<br>
使用的 Unity Ads 版本为 2.0.7


## 一部分. 为什么看不到广告?
如果想提问为什么看不到广告, 可能遇到了以下几种情况:<br>
1. 在玩/测游戏的时候, 点击了看广告按钮, 但却看不到广告. 或者在玩/测游戏的时候, 弹出网络或者广告相关的错误提示框等.<br>
2. 已经看了log, 发现广告始终没有准备好(ready).<br>
3. 一直看到的不是真实广告, 而是测试广告.<br>
4. 广告加载很久, 很久都没能看到, 但其实一直等待之后还是看到了<br>
5. 只能看到很少的几个广告, 看不到期望那么多的广告<br>
6. 在Unity中查看, 提示广告集成正确了, 但打包后在实际手机上却看不到广告.<br><br>

### 下面逐条来检查一下是什么问题:
<br>
#### 在玩/测游戏的时候, 点击了看广告按钮, 但却看不到广告.
#### 或者在玩/测游戏的时候, 弹出网络或者广告相关的错误提示框等.
遇到了这种问题, 如果您不是开发者/程序员, 请联系你们团队的开发/程序/技术. Unity并不会与玩家直接打交道, Unity Ads不论是由于什么原因, 都会从程序的层面返回给你们的游戏, 然后你们的开发根据返回的结果, 来处理游戏给玩家带来怎样的反应. 所以如果游戏提示广告错误, 或者点了看广告后弹出显示网络错误等等, 这都是你们的技术人员所做的游戏逻辑.  但实际发生了什么事情, 是你们的技术人员决定的, 它可以在Unity返回"没填充"或者"初始化失败"的时候, 仍然提示玩家"网络错误". 所以如果是从游玩或者黑盒测试的层面发现看不到广告, 请<strong> <span style="color:red">不要联系Unity, 请你们的开发人员来查看原因</span></strong>, 让他们来查看除了什么问题.

#### 已经看了log, 发现广告始终没有准备好(ready).
* 请继续查看log, 如果log一直没有更多的打印出来, 那可能是网络问题, 或者服务器距离太远等, 还在下载. 如果想确认是网络问题, 请使用网络监控软件, 如Charles之类的检查, 看正常时是下载了哪些文件, 慢的时候与正常时对比, 看有什么区别
* 如果看到log有no fill打印的话, 请回忆看24小时内测试了多少个真实广告, Unity Ads限制每天最多25个广告, 如果收到当地填充率影响也可能更低.  如果在广告产业发达国家或地区只看到10个以内的广告, 可以联系Unity帮您查看是否有做限制广告次数等设置.
* 看到log说初始化失败. 初始化失败的原因可能有很多, Unity Ads建议在应用刚开的时候初始化, 但初始化API里的delegate参数却不能为空, 所以需要确保delegate有临时设置等. 请认真查看log, 如果有不理解的log打印出来的话,  请联系Unity并提供您的gameid, 网络状况, 测试设备和OS版本, 操作步骤(出问题时所处环境), 集成代码片段, 从dashboard上的右下角点击联系支持按钮. 
* 如果只是刚过几秒, 您的游戏逻辑此时是允许点击展示视频的, 但每次检查ready状况都是false, 那么请多等一会儿, 每个广告加载十几秒都是正常的. 正如此demo项目中所实现的那样, 在ready后才允许玩家点击看广告按钮,  这样是Unity推荐的用户体验逻辑. 


#### 一直看到的不是真实广告, 而是测试广告.
Unity Ads提供给开发者2种方式设置测试广告. 

* 第一种是在编程API中, 初始化Unity Ads的语句里, 有一个test mode的参数, 如果设成true则为开启测试模式, 反之则为真实广告模式. 
* 第二种是在dashboard上, 针对游戏`项目->指定平台->设置标签`下边, 有一个`覆盖客户端测试模式`选项, 开启这个选项后, 则编程里所指定的测试模式参数失效, 在此选项下, 如果选择强制测试模式, 则现实测试广告, 如果选择强制真实广告, 则不会显示测试广告.
* 如果上述第二种设置好后, 仍然显示测试广告, 请确认您使用的gameid是否正确!


#### 广告加载很久, 很久都没能看到, 但其实一直等待之后还是看到了.
非常抱歉, 这只是单纯的网络问题, 不需要联系Unity. <br><br>
但如果您认为确实是异常情况的话, 请按照如下步骤来检查

1. 您的3G或者wifi的网速(4G应该是没问题的), 如果下载速度不到100KB的话, 那应该确实是网络问题呢.
2. 如果下载速度很快的话, 那么请下载Unity的其他游戏, 走到附近或者远处不同区域进行测试, 如果是中国或者美国, 确实有些区域网络很好, 但Unity Ads的加载速度超过每个视频1分钟的话, 那么请从dashboard右下角联络支持. 

不论怎么说, 这种状况一般并不是客户端集成问题, 我们并没有办法从技术角度来解决. 但有可能是Unity的服务器供应商出现个别地区的网络瘫痪, Unity如果您发现疑似问题, 在联络Unity之后, Unity会给您回复或者帮助解决好问题后再答复您. 

#### 只能看到很少的几个广告, 看不到期望那么多的广告

1. 如果您的游戏允许玩家无间隔连续观看广告的话, 这并不复合Unity Ads广告平台的定位. Unity有限制24小时之内, 同一个游戏里, 一个设备最多只能观看25个广告. 如果您期待很多的话, 那么其实Unity并不能达到这么多. 
2. 如果您只能看到3-5个, 10个, 诸如此类, 那么您可以了解下您所发行的目标地区是否有发达的移动广告产业, 有一些业务欠发达地区确实广告比较少. 如果您确定是广告业务发达地区, 比如美国或者中国, 那您可以把gameid通过dashboard右下角的联系支持功能, 来向Unity咨询, 看看您的游戏是否做了一些特殊配置, 影响了它的填充.
3. 如果您每天只看到1个广告, 并且在中国, 那么可能是在使用Android平台进行测试. Unity Ads目前并不被中国Android所支持. 只有误投到中国区Android上的1-2个广告, 或者完全没有广告.


#### 在Unity中查看, 提示广告集成正确了, 但打包后在实际手机上却看不到广告.

1. 如果您是指在真实测试的时候, 只能看到Unity的测试广告, 看不到真实广告的话, 那么请在初始化的时候, 或者在dashboard上关闭测试模式.
2. 如果您在Unity Editor里边好了, 但在设备上始终都没法正确反应出广告的话, 那么请检查您的测试设备, Unity Ads目前只支持iOS和Android设备, 并且一定要安装了Google Play的Android设备才可以, 中国不支持Unity Ads, 如果目标发行海外市场的话, 可以开启VPN进行测试.


## 二部分. 打印出的log代表什么意思?
#### 1. 成功向服务器发出初始化请求, 但由于网络等原因, 正在等待返回
```
2017-01-06 15:35:21.388034 ads demo ios[425:70451] I/UnityAds: +[UADSApiSdk WebViewExposed_logInfo:callback:] (line:57) :: Received configuration with 2 placements
2017-01-06 15:35:21.489951 ads demo ios[425:70451] LTE
```
像如上这种, 打印出了拿到了x个placements, 说明正确拿到ads plan了, 一般代表初始化正在顺利进行, 然后打印出网络状况, 如这里是LTE, 如果是您自己的环境下也可能是CDMA之类的, 说明初始化流程正在为广告位抓取广告信息. 

#### 2. 初始化语句使用错误的log
```
2017-01-06 15:40:37.797350 ads demo ios[429:71438] E/UnityAds: +[UnityAds initialize:delegate:testMode:] (line:45) :: Unity ads init: invalid argument, halting init
```
如果打印出上述log, 说明在调用初始化语句的时候没有传入delegate, 这个参数的delegate是允许传入空值(nil)的, 但其实传入nil却会出错.

#### 3. 正在加载视频的log
````
2017-01-06 15:42:53.624608 ads demo ios[433:72140] I/UnityAds: +[UADSApiSdk WebViewExposed_logInfo:callback:] (line:57) :: Unity Ads server returned game advertisement for AB Group 11
````
上面这句如果没有接下来打印的话, 说明正在下载广告视频. 如果没有任何下续的log打印出来, 说明卡在网络下载视频这里了, 如果有30秒或者1分钟的话, 那就算比较久了, 一般质量好的4G或者wifi的话, 应该是几秒或者十几秒就可以打印出下续的log了. 在看完一个视频广告后, 正常的话, 会立刻再次打印上边这句, 然后进入等待下载视频的阶段, 直到再次调用`unityAdsReady ` 完成新一个视频的下载.

#### 4. 广告视频成功下载完成的log
````
[UnityAdsDelegate] unityAdsReady, placementId=video
[UnityAdsDelegate] unityAdsReady, placementId=rewardedVideo
````
上面2句是在这个示例项目中, 我们自己打印出来的, 如果正确加载完广告视频, 则Unity Ads会呼叫
`func unityAdsReady(_ placementId: String)` 回调函数, 上面2句log即为我们在这个函数中打印出的log.

#### 5. 本次24小时的广告全都看完了的log
````
2017-01-06 15:54:39.610355 ads demo ios[436:73594] I/UnityAds: +[UADSApiSdk WebViewExposed_logInfo:callback:] (line:57) :: Unity Ads server returned no fill, no ads to show
````
由于本地区填充率问题, 或者看完24小时内的所有25次广告等原因, 返回如上`no fill`的log, 则就是没有填充了. 没有填充大部分时候都是正常情况, 如果您认为可能有问题的话, 请查看上边***<只能看到很少的几个广告, 看不到期望那么多的广告>*** 条目, 如果仍存在问题的话, 可以从dashboard右下角联络Unity技术支持. 


## 三部分. API的具体行为和使用方法
API文档在如下的位置
#### iOS API 文档
* [UnityAds 和 UnityAdsDelegate](chinese_sdk_ios_api_reference)
* [UnityAdsPlacementState](chinese_sdk_ios_api_placementstates)
* [UnityAdsFinishState](chinese_sdk_ios_api_finishstates)
* [UnityAdsError](chinese_sdk_ios_api_errors)

#### Android API 文档
* [UnityAds 和 IUnityAdsListener](chinese_sdk_android_api_reference)
* [UnityAds.PlacementState](chinese_sdk_android_api_placementstates)
* [UnityAds.FinishState](chinese_sdk_android_api_finishstates)
* [UnityAds.UnityAdsError](chinese_sdk_android_api_errors)





## 四部分. 集成时候, 代码层面要注意些什么?
1. 如何设计奖励视频广告的游戏功能? -- 没有准备好时不要给玩家机会来点.
2. 应该何时初始化? 
3. 注意有没有开启break on exception
4. 应该如何检查广告才是正确的"可以展示"?
5. 为什么测着测着就没广告可看了?
6. 

## 五部分. 遇到Unity Ads的bug怎么办?
1. 先看是不是自己集成逻辑的问题, 查看本示例项目是否也有您所发现的bug
2. 查看Unity Ads的版本, 请查看每个版本release的代码改动, 是否已包含了您所发现的bug的修正
3. 到google和英文Unity论坛上查找有没有别人遇到类似的问题
4. 使用互联网查看是否是操作系统问题
5. 使用互联网查看是否是mediation的问题
6. 联系Unity提交bug

## 六部分. 关于API使用的问题
1. 有没有点击或者下载的回调?
2. 是否有控制视频长度的api?
3. 是否能让广告只在wifi时候加载?
4. 按home键后, 无法继续观看视频.


## 七部分. 其他问题
1. 应该给多少奖励?