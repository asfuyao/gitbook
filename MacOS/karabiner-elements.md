# karabiner-elements

开源软件 – 键盘键位修改神器

## 介绍

Karabiner-Elements是一款macOS系统下的键盘映射和增强工具，允许用户修改键盘映射和创建复杂的自定义快捷键。它是Karabiner的后继版本，采用了完全不同的设计，并具有更好的性能和功能。

## 功能

### 键盘映射

Karabiner-Elements允许用户修改键盘映射，这意味着可以将键盘上的任何键映射到其他键，也可以将多个键组合成一个键。例如，您可以将Caps Lock键映射为Esc键，将右Option键映射为Control键，或将Fn键映射为Command键。

### 自定义快捷键

Karabiner-Elements允许用户创建自定义的复杂快捷键。您可以通过将多个键组合成一个键来创建自定义快捷键，或者将一组键绑定到一些功能。例如，您可以将Ctrl+Option+H键绑定到”前往Home目录”命令，将Ctrl+Option+L键绑定到”锁定屏幕”命令，或者将Ctrl+Shift+Option+Command+P键绑定到”启动屏幕保护程序”命令。

### 修改鼠标设置

Karabiner-Elements允许用户修改鼠标的一些设置，例如滚动方向、滚动速度、鼠标移动速度等等。

### 事件触发器

Karabiner-Elements允许用户创建事件触发器。当某个事件发生时，Karabiner-Elements会执行一些操作。例如，您可以创建一个事件触发器，当插入USB设备时，自动打开某个应用程序。

## brew安装

```shell
brew install --cask karabiner-elements
```

## 常用Rule



### 右手复制

```json
{
    "description": "PC-Style Copy (Ctrl+Insert) for JIS/PC keyboard",
    "manipulators": [
        {
            "from": {
                "key_code": "insert",
                "modifiers": {
                    "mandatory": ["control"],
                    "optional": ["any"]
                }
            },
            "to": [
                {
                    "key_code": "c",
                    "modifiers": ["left_command"]
                }
            ],
            "type": "basic"
        }
    ]
}
```

### 右手剪切

```json
{
    "description": "PC-Style Cut (Ctrl+Del) for JIS/PC keyboard",
    "manipulators": [
        {
            "from": {
                "key_code": "delete_forward",
                "modifiers": {
                    "mandatory": ["control"],
                    "optional": ["any"]
                }
            },
            "to": [
                {
                    "key_code": "x",
                    "modifiers": ["left_command"]
                }
            ],
            "type": "basic"
        }
    ]
}
```

### 右手粘贴

```json
{
    "description": "PC-Style Paste (Shift+Insert) for JIS/PC keyboard",
    "manipulators": [
        {
            "from": {
                "key_code": "insert",
                "modifiers": {
                    "mandatory": ["shift"],
                    "optional": ["any"]
                }
            },
            "to": [
                {
                    "key_code": "v",
                    "modifiers": ["left_command"]
                }
            ],
            "type": "basic"
        }
    ]
}
```

### 其他

1. 点击Add predefined rule

2. 在弹出窗口点Import more rules from the internet(Open a web browser)

3. 在浏览器中搜索：PC-Style Shortcuts

4. 找到一个内容比较多的PC-Style Shortcuts，点Import导入

   一键直达：https://ke-complex-modifications.pqrs.org/#pc_shortcuts

5. 根据自己需要选择快捷键来Enable
