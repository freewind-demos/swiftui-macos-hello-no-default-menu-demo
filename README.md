# SwiftUI macOS 哈喽无默认菜单

## 简介

这个 demo 只开一个 macOS SwiftUI 窗口。

窗口里只显示 `Hello, no menus`。

重点不是界面，而是尽量把系统默认菜单清空。

## 快速开始

### 环境要求

- macOS 14+
- Xcode 15+
- XcodeGen

### 运行

```bash
cd swiftui-macos-hello-no-default-menu-demo
xcodegen generate
open SwiftUIMacOSHelloNoDefaultMenuDemo.xcodeproj
```

也可以命令行构建：

```bash
./scripts/build.sh
```

## 概念讲解

### 只显示一个文字

```swift
struct ContentView: View {
    var body: some View {
        Text("哈喽")
            .font(.largeTitle)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

这里没有列表、按钮、工具栏。

窗口内容只有一个 `Text`。

### 先关掉 SwiftUI 默认 commands

```swift
Window("Hello, no menus", id: "main") {
    ContentView()
}
.commandsRemoved()
.commandsReplaced {}
```

`commandsRemoved()` 用来去掉 scene 自带 commands。

`commandsReplaced {}` 再把 SwiftUI 默认 command 集整体替换为空。

### 再从 AppKit 层把主菜单置空

```swift
final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.mainMenu = NSMenu()
    }
}
```

这一步比单纯写 SwiftUI commands 更狠。

它会直接把应用主菜单栏对象换成空菜单。

## 完整示例

```swift
import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.mainMenu = NSMenu()
    }
}

@main
struct HelloNoDefaultMenuApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Window("哈喽", id: "main") {
            ContentView()
        }
        .defaultSize(width: 320, height: 180)
        .commandsRemoved()
        .commandsReplaced {}
    }
}
```

## 注意事项

macOS 某些系统行为可能仍保留极少量平台级入口。

如果不同系统版本还有残留，不一定是代码没生效，也可能是系统不允许完全没有菜单结构。

这个 demo 已先做两层处理：

1. SwiftUI commands 置空
2. AppKit `mainMenu` 置空

## 完整讲解（中文）

这个 demo 的目标很单纯：

1. 打开应用
2. 只看到一个写着 `Hello, no menus` 的窗口
3. 默认菜单能删就删

普通 SwiftUI macOS App 一启动，通常会自动带上应用菜单、文件菜单、编辑菜单、窗口菜单、帮助菜单。

如果只写视图，不处理 commands，这些菜单会一直在。

所以这里分两层做：

第一层是 SwiftUI 官方入口。

`commandsRemoved()` 和 `commandsReplaced {}` 先告诉 SwiftUI：不要帮我挂默认菜单命令。

第二层是 AppKit 底层入口。

在应用启动完成后，直接执行 `NSApp.mainMenu = NSMenu()`，把主菜单对象换成空菜单。

这样做的好处是简单、直接、代码少。

如果你后面想加回某个菜单，不要改视图，只需要：

- 去掉 `commandsReplaced {}`
- 或者保留空菜单方案，但自己重新设置 `NSMenu`

当前 demo 刻意不做这些扩展，保持它只验证一件事：SwiftUI macOS App 如何尽可能去掉默认菜单。
