# 修改root用户密码

```shell
# 进入控制台，时间较长需等待
gitlab-rails console -e production

# 获取root账号
user=User.where(id:1).first

# 修改密码
user.password='新密码'
user.password_confirmation='新密码'

# 保存
user.save!

# 退出
exit
```

# 配置邮件发送服务

## 编辑配置

编辑/etc/gitlab/gitlab.rb，填入或修改下面内容

```shell
 gitlab_rails['smtp_enable'] = true
 gitlab_rails['smtp_address'] = "smtp.163.com"
 gitlab_rails['smtp_port'] = 465
 gitlab_rails['smtp_user_name'] = "用户名@163.com"
 gitlab_rails['smtp_password'] = "授权码"
 gitlab_rails['smtp_domain'] = "smtp.163.com"
 gitlab_rails['smtp_authentication'] = "login"
 gitlab_rails['smtp_enable_starttls_auto'] = true
 gitlab_rails['smtp_tls'] = true
 gitlab_rails['gitlab_email_from'] = '用户名@163.com'

```

## 刷新配置

```shell
gitlab-ctl reconfigure
gitlab-ctl restart
```

## 测试配置

```shell
# 进入控制台
gitlab-rails console

# 发测试邮件
Notify.test_email('你的收件邮箱', '测试邮件标题', '测试邮件正文').deliver_now
```
