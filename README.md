# 一个好用的 Xcode 扩展：GHWXcodeExtension
### 目录

[一. 前言](https://github.com/guohongwei719/GHWXcodeExtension#%E4%B8%80-%E5%89%8D%E8%A8%80)   
[二. 功能演示(注：均可配置快捷键，实现一键操作)](https://github.com/guohongwei719/GHWXcodeExtension#%E4%BA%8C-%E5%8A%9F%E8%83%BD%E6%BC%94%E7%A4%BA%E6%B3%A8%E5%9D%87%E5%8F%AF%E9%85%8D%E7%BD%AE%E5%BF%AB%E6%8D%B7%E9%94%AE%E5%AE%9E%E7%8E%B0%E4%B8%80%E9%94%AE%E6%93%8D%E4%BD%9C)  
[三. 安装配置方法](https://github.com/guohongwei719/GHWXcodeExtension#%E4%B8%89-%E5%AE%89%E8%A3%85%E9%85%8D%E7%BD%AE%E6%96%B9%E6%B3%95)  
[四. 使用注意事项](https://github.com/guohongwei719/GHWXcodeExtension#%E5%9B%9B-%E4%BD%BF%E7%94%A8%E6%B3%A8%E6%84%8F%E4%BA%8B%E9%A1%B9)  
[五. 调试 GHWXcodeExtension](https://github.com/guohongwei719/GHWXcodeExtension#%E4%BA%94-%E8%B0%83%E8%AF%95-ghwxcodeextension)  
[六. 后记](https://github.com/guohongwei719/GHWXcodeExtension#%E5%85%AD-%E5%90%8E%E8%AE%B0)

## 一. 前言
在 Xcode8 以前，开发者可以在 Xccode 运行时通过注入代码来实现插件的功能。插件可以在Alcatraz 上面提交和分发。不过 Xcode8 禁止了该方式的插件安装，转而向开发者提供了Xcode Source Editor Extension（以下简称 Extension）的方式来做插件。平时写代码过程中发现有很多代码都是重复的，属于无脑代码，而且团队协作中统一的代码格式规范非常重要，因此试图通过 Extension 解决这些问题，从而开发了这个工具。  

实现的功能：  

1. 初始化自定义view、UICollectionViewCell、UITableViewCell、viewController，自动删除无用代码和添加默认代码；
2. 为属性自动添加懒加载代码、对应协议声明和协议方法，主要有 UITableView\UICollectionView\UIScrollView\UIButton\UILabel\UIImageView；
3. 选中一个类，文件顶部自动添加对应的 import；
4. 给 import 分组排序去重，从上到下为 主类头文件、viewController、view、manager & logic、第三方库、model、category、其他。


## 二. 功能演示(注：均可配置快捷键，实现一键操作)
#### 1. 初始化自定义view、UICollectionViewCell、UITableViewCell、viewController，自动删除无用代码和添加默认代码；

![(image)](https://github.com/guohongwei719/GHWXcodeExtension/blob/master/resources/initView.gif)


#### 2. 为属性自动添加懒加载代码、对应协议声明和协议方法，主要有 UITableView\UICollectionView\UIScrollView\UIButton\UILabel\UIImageView；  

![(image)](https://github.com/guohongwei719/GHWXcodeExtension/blob/master/resources/addLazyCode.gif)

注意：需要添加懒加载代码的属性需要被光标选中

#### 3. 选中一个类，文件顶部自动添加对应的 import；
  
![(image)](https://github.com/guohongwei719/GHWXcodeExtension/blob/master/resources/addImport.gif)

#### 4. 给 import 分组排序去重，从上到下为 主类头文件、viewController、view、manager & logic、第三方库、model、category、其他。
  
![(image)](https://github.com/guohongwei719/GHWXcodeExtension/blob/master/resources/sortImport.gif)

注意：  

1. 如果不选中对应的 import 则默认是所有 import 行，如果选中的话则只会对选中的 import 分组排序去重  
2. viewController 后缀小写必须为 "controller.h"、"vc.h"；  
3. view 后缀小写必须为 "view.h"、"bar.h"、"cell.h"；  
4. manager & logic 后缀小写必须为"manager.h"、"logic.h"、"helper.h"、"services.h"、"service.h"。

## 三. 安装配置方法
#### 1. 将项目 clone 下来，如果不想 clone 项目，直接去 release 下面下载生成的 GHWXcodeExtension.zip，链接 [https://github.com/guohongwei719/GHWXcodeExtension/releases](https://github.com/guohongwei719/GHWXcodeExtension/releases)，解压即可，然后跳到第三步，如下图
![](./resources/11.png)
#### 2. 将 clone 的项目编译成功，到 Products 下，选择 GHWXcodeExtension.app 右键，选择 Show in Finder
![](./resources/6.png)

#### 3. 将 GHWXcodeExtension 复制到应用程序下面，双击打开
![](./resources/7.png)
#### 4. 到 系统偏好设置 找到 扩展，选择 Xcode Source Editor，选中 GHWExtension
![](./resources/8.png)
![](./resources/9.png)

#### 5. 打开项目以后，可以在 Xcode 菜单栏，选择 Editor, 可以看到 GHWExtension 出现在最下面
![](./resources/4.png)

#### 6. 选择 GHWExtension，出现可以使用的功能选项，顾名思义
![](./resources/5.png)

#### 7. 四个功能选项都可以配置快捷键，实现一键操作，推荐分别设置为 option+z\option+x\option+c\option+v，如下图
![](./resources/10.png)

## 四. 使用注意事项
#### 1. 使用 addLazyCode 功能的时候，如果添加了代码后想撤销，使用 command + z，这时候 Xcode 可能会 crash，这应该是 Xcode 本身的一个 bug，所以需要注意一下，正常情况下添加以后也不会撤销，如果要撤销手动删除也很方便，即使 crash 了再打开就行了，打开以后是删除状态。希望苹果能尽快修复这个 bug。

## 五. 调试 GHWXcodeExtension
#### 1. 选择 GHWExtension scheme
![](./resources/1.png)

#### 2. 运行，选择 xcode，点击 run
![](./resources/2.png)

#### 3. 选择一个项目
![](./resources/3.png)

## 六. 后记
欢迎提 bug 和 feature。  
微博：[黑化肥发灰11](https://weibo.com/u/2977255324)   
简书地址：[https://www.jianshu.com/u/fb5591dbd1bf](https://www.jianshu.com/u/fb5591dbd1bf)  
掘金地址：[https://juejin.im/user/595b50896fb9a06ba82d14d4](https://juejin.im/user/595b50896fb9a06ba82d14d4)
# Xcode-Extension
