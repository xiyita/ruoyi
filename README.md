# 若依前后端分离版CI/CD部署
### 项目描述

1.编写 Ansible Playbook，实现若依框架的自动化环境构建与销毁，涵盖 Nginx 代理、后端 Tomcat、Redis、前端 Nginx Web 和 MySQL 配置，支持一键部署与清理。同时，基于 Jenkins 和 GitLab SCM，构建自动化 CI/CD 流程，前后端打包分别在各自节点执行，提升系统开发与部署效率。

2.CI/CD 自动化流程：基于 Jenkins 和 GitLab SCM Pipeline，构建自动化的 CI/CD 流程，用于若依管理系统的持续集成与部署。

3.前后端分离的 CI/CD 实现：通过 GitLab + GitLab Runner，实现前后端的分离构建与部署，确保前端与后端分别在对应的节点执行打包和部署，提升开发与部署效率。
