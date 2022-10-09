# chrome使用技巧

## 关闭Chrome94中的非活动检测

chrome://settings/content/idleDetection

## 关闭跨域安全检查

增加启动参数：--disable-web-security

## 关闭指定网站的弹出阻止

增加启动参数：--disable-popup-blocking http://localhost:8080

## 访问http自动跳转https问题

在地址栏输入：chrome://net-internals/#hsts

遭到最下面的 Delete domain security policies，在Domain中输入域名后点击Delete，之后这个域名就不会自动跳转https了