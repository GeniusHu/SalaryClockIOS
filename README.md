# SalaryClockIOS 工资计时器

## 项目概述
SalaryClockIOS是一款iOS应用，用于实时计算和展示用户的工作收入。它能够根据用户的工资标准，实时显示当天、当月和当年的收入情况，并提供倒计时功能显示距离下班时间。

## 技术栈
- 开发语言：Swift
- UI框架：SwiftUI
- 依赖管理：CocoaPods
- 第三方库：SnapKit（UI布局）

## 核心功能
1. 实时收入计算
2. 工作时间倒计时
3. 多语言支持（中文、英文）
4. 节假日管理
5. 个性化设置

## 项目结构

### 控制器（Controller）
- `AppDataManager`：应用数据管理
- `EarningsManager`：收入计算管理
- `HolidayManager`：节假日管理
- `Extensions`：Swift扩展方法

### 视图（Views）
- `DashboardView`：主仪表盘
- `CountdownView`：倒计时显示
- `EarningsCardView`：收入卡片
- `HeaderView`：页面头部
- `InfoCardView`：信息卡片
- `SettingsView`：设置页面
- `TimeBlockView`：时间块显示
- `UserInfoCard`：用户信息卡片

### 工具类（Utils）
- `EarningsCalculator`：收入计算器
- `UserDefaultsManager`：用户配置管理

### 数据模型（Entity）
- `Holiday`：节假日数据模型

## 核心类说明

### EarningsManager
负责处理所有与收入计算相关的逻辑：
- 实时收入计算
- 工作日判断
- 收入统计（日/月/年）

### HolidayManager
管理节假日相关功能：
- 节假日数据加载
- 节假日判断
- 工作日历管理

### AppDataManager
应用核心数据管理：
- 用户配置管理
- 应用状态管理
- 数据持久化

## 本地化支持
应用支持中文和英文两种语言：
- `en.lproj/Localizable.strings`：英文本地化
- `zh-Hans.lproj/Localizable.strings`：简体中文本地化

## 配置说明
用户可配置的主要参数：
- 月薪设置
- 工作时间设置
- 货币单位设置
- 界面主题设置

## 开发环境要求
- Xcode 14.0+
- iOS 14.0+
- CocoaPods

## 安装说明
1. 克隆项目代码
2. 执行 `pod install` 安装依赖
3. 使用 Xcode 打开 `Paytimer.xcworkspace`
4. 编译运行项目