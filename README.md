# ruoyi
使用CI/CD部署若依前后端分离版
1.编写 Ansible Playbook，实现若依框架的自动化环境构建与销毁，涵盖 Nginx 代理、后端 Tomcat、Redis、前端 Nginx Web 和 MySQL 配置，支持一键部署与清理。同时，基于 Jenkins 和 GitLab SCM，构建自动化 CI/CD 流程，前后端打包分别在各自节点执行，提升系统开发与部署效率。
2.CI/CD 自动化流程：基于 Jenkins 和 GitLab SCM Pipeline，构建自动化的 CI/CD 流程，用于若依管理系统的持续集成与部署。
3.前后端分离的 CI/CD 实现：通过 GitLab + GitLab Runner，实现前后端的分离构建与部署，确保前端与后端分别在对应的节点执行打包和部署，提升开发与部署效率。
### 基于Jenkins SCM pipeline实现若依项目架构图
![image](https://github.com/user-attachments/assets/6080437e-a7c4-4e32-b5d0-7e9a496f5bbf)
### 基于GItlab的runner实现若依项目架构图
![image](https://github.com/user-attachments/assets/1abc3bfe-03fc-49b6-bef6-56ffb6136101)
##### 目前所有脚本剧本，涉及到文件的在file中，涉及到模板的在template中
1.Nginx：安装部署nginx剧本、若依代理剧本、若依web剧本、摧毁nginx剧本
2.Tomcat：安装部署tomcat剧本、若依环境剧本、摧毁tomcat剧本
3.Java环境：安装部署java环境
4.Redis：安装部署redis剧本、摧毁redis剧本
5.Mysql：安装部署mysql剧本、数据库初始化+若依环境脚本、摧毁mysql剧本
6.Jenkinsfile流水线文件
7.Gitlab-runner流水线文件
8.nginx代理配置文件、nginx-web配置文件、jdk1.8安装包、tomcat安装包、tomcat server.xml配置文件、tomcat控制启动脚本、redis安装包、redis配置文件（redis.conf）、mysql安装包、mysql控制启动脚本、mysql配置文件(my.cnf)、需要注入数据的.sql文件、各种环境脚本

#### 所有主机需要进行的操作
1.A记录解析
2.受ansible控制的主机都需要创建ansible账号密码、sudo提权ansible账号
3.ansible主机root账号与所有受控机做ssh免密

### 若依前后端分离版代码
##### 前端代码需要修改的地方
ruoyi/ruoyi-ui/vue.config.js：修改后端API接口
![image](https://github.com/user-attachments/assets/edb1aebd-b2da-4a70-80b4-97b868ced480)

##### 后端代码需要修改的地方
ruoyi/ruoyi-admin/src/main/resources/application.yml：修改前端上传文件目录、redis接口
![image](https://github.com/user-attachments/assets/8460219a-2a94-4934-a0e1-dfeb71b5e677)
![image](https://github.com/user-attachments/assets/c101bf47-68f5-441b-ac1a-acdb6f50c7b1)


ruoyi/ruoyi-admin/src/main/resources/application-druid.yml：修改mysql数据库接口
![image](https://github.com/user-attachments/assets/d50ba904-702f-4758-b8fe-138bc77887dd)

ruoyi/ruoyi-admin/pom.xml：指定后端打包类型
![image](https://github.com/user-attachments/assets/0a3cdaa7-dc5b-4ef7-adc7-89d5a041cf0c)

### 三、Jenkisn
#### Jenkins主机
1.java环境、maven后端环境
2.nodejs、npm前端环境
3.ansible环境（ansible分发项目代码到前后端）
4.Jenkins账号sudo提权（执行ansible的一些指令）
#### Jenkins前端
1.与gitlab端的jenkins账号ssh免密凭据
![image](https://github.com/user-attachments/assets/85a9e9b0-145a-4e58-b7be-4888d92fc7fe)
![image](https://github.com/user-attachments/assets/d1ffcd94-f89a-4b3c-a61d-441f601fc6cd)


2.创建ruoyi_pipeline项目，配置webhook触发、选择pipeline SCM
![image](https://github.com/user-attachments/assets/381d2495-dcf8-4d97-b808-6436688e812b)

3.Jenkinsfile文件
![image](https://github.com/user-attachments/assets/f3c89ab2-ed0b-4b7c-8b3a-333f33b44269)


### 四、Gitlab主机
##### 1.创建ruoyi-group群组
![image](https://github.com/user-attachments/assets/61a8d02b-f5b6-4d24-8d06-b5ad8e279326)

##### 2.创建ruoyi仓库
![image](https://github.com/user-attachments/assets/2e81e561-a983-4740-8aae-2569c81fb5b3)

##### 3.ruoyi仓库与Jenkins的ruoyi_pipeline项目做webhook触发
![image](https://github.com/user-attachments/assets/9f85c391-de0c-4256-a2e0-74360948cf8e)


### 五、Gitlab-runner部署若依项目
![image](https://github.com/user-attachments/assets/e1af69c5-8ff8-49e4-bd42-77e588478974)

在主机上注册runner（前提：已经安装好runner和高版本git）
![image](https://github.com/user-attachments/assets/d8eb4991-3490-4755-aba7-5c0efe5d7667)

nginx-web要安装前端打包工具
yum install -y nodejs npm
tomcat要配置maven环境、jdk环境（略）
suuus程序员端拉取仓库后写若依项目代码、.gitlab-ci.yml文件
![image](https://github.com/user-attachments/assets/3125ed26-a018-4617-8268-c6d66ec0b8cf)

###### 编写.gitlab-ci.yml
![image](https://github.com/user-attachments/assets/7d150316-8357-4a15-9005-304127c25e22)

###### Suuus程序员上传suuus-dev分支后
管理员合并suuus-dev分支到main分支，触发runner运行
![image](https://github.com/user-attachments/assets/4b78835c-8bc9-4e65-9fa9-020d64ead695)

### gitlab-runner 遇到的问题
不知道为什么总会出现一些莫名其妙的问题
1.npm命令找不到（每次运行runner前重新安装npm、nodejs又可以了）
2.文件找不到（已经打包好的代码目录找不到，但在主机查看明明就是有的，一直重试重试重试，又可以了....）

### 六、剧本展示
详细请看以.yaml结尾的

### 七、配置文件注意点
##### 错误：访问时，一直显示正在加载系统资源,请耐心等待
![image](https://github.com/user-attachments/assets/a785460d-bd59-4df5-90cc-81c0e614b7e5)
解决后端跨域问题
当前端请求后端接口时，浏览器出于同源策略的限制，会拒绝跨域请求。如果没有正确配置后端跨域支持或 Nginx 跨域代理，可能会导致前端无法正常访问后端接口。
![image](https://github.com/user-attachments/assets/edf51af1-a53e-4e39-aaaa-34721a2ced77)


##### 错误：访问正常，但是一旦刷新就会404错误
解决：nginx-web确保所有未匹配到静态资源的请求都重定向到index.html
![image](https://github.com/user-attachments/assets/3d0eb08e-8959-48a0-b4e4-d08fe0ad7a36)
