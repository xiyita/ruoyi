pipeline {
    agent any
    stages {
        stage('git_code') {
            steps {
                echo '从gitlab中获取代码'
                git branch: 'main', changelog: false, credentialsId: '048b1025-0fcc-4f55-ac05-d99361d27821', poll: false, url: 'gitlab@192.168.50.162:ruoyi-team/ruoyi.git'
            }
        }
        stage('pack_front') {
            steps {
                echo '打包前端'
                sh 'pwd'
                dir('./ruoyi/ruoyi-ui/') {
                    sh 'npm install --registry=http://registry.npmmirror.com'
                    sh 'npm run build:prod'
                }

            }
        }
        stage('pack_backend') {
            steps {
                echo '打包后端'
                sh 'pwd'
                dir('./ruoyi/') {
                    sh '/usr/local/maven-3.9.4/bin/mvn clean package -DskipTest'
                }
            }
        }
        stage('test_code') {
            steps {
                echo '测试运行项目...'
                sleep 2
            }
        }
        stage('run_code') {
            steps {
                echo '发布前端代码'
                dir('./ruoyi/ruoyi-ui/') {
                    sh 'sudo ansible nginx -m synchronize -a "src=./dist/ dest=/var/www/ruoyi"'
                    sh 'sudo ansible nginx -m file -a "path=/var/www/ruoyi owner=ruoyi group=ruoyi recurse=yes"'
                }
                echo '发布后端代码'
                dir('./ruoyi/') {
                    sh 'sudo ansible tomcat -m synchronize -a "src=./ruoyi-admin/target/ruoyi-admin.war dest=/var/www/ruoyi/ROOT.war"'
                }
            }
        }
    }
}

