# 若依前后端分离版CI/CD部署
#### 注意：仓库中并没有对应的安装包，所以你要自己获取以下安装包
##### apache-tomcat-9.0.96.tar.gz、jdk-8u201-linux-x64.tar.gz、mysql-5.7.40-el7-x86_64.tar.gz、redis-stable.tar.gz
#### 如果你实在找不到就邮箱联系我吧。xiyita0509@163.com
### 项目描述

1.编写 Ansible Playbook，实现若依框架的自动化环境构建与销毁，涵盖 Nginx 代理、后端 Tomcat、Redis、前端 Nginx Web 和 MySQL 配置，支持一键部署与清理。同时，基于 Jenkins 和 GitLab SCM，构建自动化 CI/CD 流程，前后端打包分别在各自节点执行，提升系统开发与部署效率。

2.CI/CD 自动化流程：基于 Jenkins 和 GitLab SCM Pipeline，构建自动化的 CI/CD 流程，用于若依管理系统的持续集成与部署。

3.前后端分离的 CI/CD 实现：通过 GitLab + GitLab Runner，实现前后端的分离构建与部署，确保前端与后端分别在对应的节点执行打包和部署，提升开发与部署效率。

### 基于Jenkins SCM pipeline实现若依项目架构图
![image](https://github.com/user-attachments/assets/6271fa8d-95dc-4d14-b5f4-052ee751d0ff)

### 基于GItlab的runner实现若依项目架构图
![image](https://github.com/user-attachments/assets/5c235a93-5d23-40ee-a4c8-57098708bea0)


## 项目实现过程
### 一、主机安排
nginx代理 192.168.50.142

nginx前端 192.168.50.144:81/82

tomcat后端 192.168.50.147/148:8080

redis 192.168.50.138

mysql 192.168.50.128

Jenkins+ansible 192.168.50.161

Gitlab 192.168.50.162

编程人员xiyita 192.168.50.161

所有主机需要进行的操作
1.A记录解析

2.受ansible控制的主机都需要创建ansible账号密码、sudo提权ansible账号

3.ansible主机root账号与所有受控机做ssh免密

### 二、编程人员需要提交给gitlab
xiyita用户账号与gitlab端的xiyita用户账号ssh免密

### （1）ansible-playbook剧本
1.Nginx：安装部署nginx剧本、若依代理剧本、若依web剧本、摧毁nginx剧本

2.Tomcat：安装部署tomcat剧本、若依环境剧本、摧毁tomcat剧本

3.Java环境：安装部署java环境

4.Redis：安装部署redis剧本、摧毁redis剧本

5.Mysql：安装部署mysql剧本、数据库初始化+若依环境脚本、摧毁mysql剧本

6.Jenkinsfile流水线文件

7.Gitlab-runner流水线文件

8.nginx代理配置文件、nginx-web配置文件、jdk1.8安装包、tomcat安装包、tomcat server.xml配置文件、tomcat控制启动脚本、redis安装包、redis配置文件（redis.conf）、mysql安装包、mysql控制启动脚本、mysql配置文件(my.cnf)、需要注入数据的.sql文件、各种环境脚本

### 若依前后端分离版代码
#### 前端代码需要修改的地方
###### ruoyi/ruoyi-ui/vue.config.js：修改后端API接口
![image](https://github.com/user-attachments/assets/146595d4-c9de-4335-8c0f-3d559825c76b)

#### 后端代码需要修改的地方
###### ruoyi/ruoyi-admin/src/main/resources/application.yml：修改前端上传文件目录、redis接口
![image](https://github.com/user-attachments/assets/035400db-d7f1-44e7-a370-e29b8f6dcda9)
![image](https://github.com/user-attachments/assets/a1bc2b30-e700-4978-bb3a-e9ee8ac6598e)

###### ruoyi/ruoyi-admin/src/main/resources/application-druid.yml：修改mysql数据库接口
![image](https://github.com/user-attachments/assets/04608d09-dd87-4b41-a8c4-f627f6f1fb13)

###### ruoyi/ruoyi-admin/pom.xml：指定后端打包类型
![image](https://github.com/user-attachments/assets/61ee517e-dde6-40e2-8f50-7f46af32b33f)

### 三、Jenkisn
#### Jenkins主机
###### 1.java环境、maven后端环境
###### 2.nodejs、npm前端环境
###### 3.ansible环境（ansible分发项目代码到前后端）
###### 4.Jenkins账号sudo提权（执行ansible的一些指令）
#### Jenkins前端
###### 1.与gitlab端的jenkins账号ssh免密凭据
![image](https://github.com/user-attachments/assets/0797138c-480a-4bf6-b7ef-288f64435243)
![image](https://github.com/user-attachments/assets/0583d2c0-9528-4a5f-ad89-6c2bf9d32e06)

###### 2.创建ruoyi_pipeline项目，配置webhook触发、选择pipeline SCM
![image](https://github.com/user-attachments/assets/b73ad74c-2502-4246-9dae-f5d976b8f688)

###### 3.Jenkinsfile文件
![image](https://github.com/user-attachments/assets/dfa8818d-4d94-46a6-a0b3-b6ae9e9f0a8a)


### 四、Gitlab主机
###### 1.创建ruoyi-group群组
![image](https://github.com/user-attachments/assets/7814cc16-de3f-4e45-9544-87a82fce9ea1)

###### 2.创建ruoyi仓库
![image](https://github.com/user-attachments/assets/980be774-b10f-4ca3-923c-d7ae7f5835d5)

###### 3.ruoyi仓库与Jenkins的ruoyi_pipeline项目做webhook触发
![image](https://github.com/user-attachments/assets/612c966b-feba-49ea-a76f-6b710758fc00)


### 五、Gitlab-runner部署若依项目
![image](https://github.com/user-attachments/assets/81d600f2-8b8c-48c9-9cea-41cd5a4b0b4b)

###### 在主机上注册runner（前提：已经安装好runner和高版本git）
![image](https://github.com/user-attachments/assets/9714b845-6b71-47bb-843d-45a4315e0c11)

###### nginx-web要安装前端打包工具
###### yum install -y nodejs npm
###### tomcat要配置maven环境、jdk环境（略）
###### suuus程序员端拉取仓库后写若依项目代码、.gitlab-ci.yml文件
![image](https://github.com/user-attachments/assets/f0595f66-6dc2-4cd6-9d15-e88e48323370)
]

###### 编写.gitlab-ci.yml
![image](https://github.com/user-attachments/assets/ec183f4c-0e54-4a96-bd0d-6877b7ec86f0)

###### Suuus程序员上传suuus-dev分支后
###### 管理员合并suuus-dev分支到main分支，触发runner运行
![image](https://github.com/user-attachments/assets/ee791ecd-165e-43ee-9d56-95f721adddb0)

#### gitlab-runner遇到的问题
###### 不知道为什么总会出现一些莫名其妙的问题
###### 1.npm命令找不到（每次运行runner前重新安装npm、nodejs又可以了）
###### 2.文件找不到（已经打包好的代码目录找不到，但在主机查看明明就是有的，一直重试重试重试，又可以了....）

### 六、剧本展示
###### 详细请看以.yml结尾的文件

### 七、配置文件注意点
#### 错误：访问时，一直显示正在加载系统资源,请耐心等待
![image](https://github.com/user-attachments/assets/be798cb3-a767-4596-bb6d-6fd0e7676d2d)
###### 解决后端跨域问题
###### 当前端请求后端接口时，浏览器出于同源策略的限制，会拒绝跨域请求。如果没有正确配置后端跨域支持或 Nginx 跨域代理，可能会导致前端无法正常访问后端接口。
![image](https://github.com/user-attachments/assets/3e6b5be0-995c-46b8-aac1-636c8415e0d3)


#### 错误：访问正常，但是一旦刷新就会404错误
###### 解决：nginx-web确保所有未匹配到静态资源的请求都重定向到index.html
![image](https://github.com/user-attachments/assets/c2782184-78ea-49b3-9c94-e0e065e9342c)

