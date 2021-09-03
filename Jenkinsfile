pipeline {
    agent any

    environment {
        JENKINS_HOME_ON_HOST = "/var/lib/jenkins"                                                // Jenkins Home 目录，用于 Jenkins 以容器方式启动的情况
        WORKSPACE_ON_HOST = env.WORKSPACE.replace("/var/lib/jenkins", env.JENKINS_HOME_ON_HOST)  // 宿主机工作目录
        SERVICE_NAME = "golang-ci"                                                               // 服务名称
        REGISTRY_HOST = "example.com"                                                            // 镜像仓库地址
        IMAGE_NAME = "${env.REGISTRY_HOST}/${env.SERVICE_NAME}"                                  // 镜像名称
        SONAR_HOST_URL = "example.com"                                                           // Sanor 代码扫描工具地址
        SONAR_LOGIN = "login_token"                                                              // Sanor 代码扫描工具登录 token
    }

    stages {
        stage("pre-build") {
            steps {
                script {
                    echo "打印构建信息"
                    sh "export"

                    // 构建成功通知钉钉
                    env.START_TIME = Calendar.getInstance().getTime().format("yyyy-MM-dd HH:mm:ss",TimeZone.getTimeZone("GMT+8:00"))
                    env.GIT_COMMIT_MSG = sh (script: 'git log -1 --pretty=%B ${GIT_COMMIT}', returnStdout: true).trim()
                    env.GIT_COMMIT_EMAIL = sh (script: 'git show -s --pretty=%ae ${GIT_COMMIT}', returnStdout: true).trim()
                    env.ROBOT_ID = "{Your dingtalk robot id}"

                    // 使用当前日期 + git 提交号前8位作为镜像 TAG
                    env.IMAGE_TAG = Calendar.getInstance().getTime().format("yyyyMMdd-HHmmss",TimeZone.getTimeZone("GMT+8:00")) + "-" + env.GIT_COMMIT.substring(0, 8) 

                    if (env.BRANCH_NAME == env.TAG_NAME) { 
                        env.IMAGE_TAG = env.TAG_NAME
                        echo "当前TAG：" + env.TAG_NAME
                    }
                    else {
                        echo "当前分支：" + env.BRANCH_NAME
                    }

                    echo "当前提交：" + env.GIT_COMMIT
                    echo "宿主机工作目录：" + env.WORKSPACE_ON_HOST
                    echo "容器工作目录：" + env.WORKSPACE
                    echo "镜像名称：" + env.IMAGE_NAME + ":" + env.IMAGE_TAG
                }
            }
        }

        stage("build") {
            steps {
                script {
                    echo "开始构建"

                    sh "cat build.sh | sed 's|\${PWD}|${env.WORKSPACE_ON_HOST}|g' > build_in_jenkins.sh"

                    sh "sh build_in_jenkins.sh"
                }
            }
        }

        stage("package") {
            steps {
                script {
                    echo "开始打包"

                    sh "sh pack.sh"
                }
            }
        }

        stage("deploy") {
            steps {
                script {
                    echo "开始发布"
                    
                    sh "sh deploy.sh"
                }
            }
        }

        stage("sonar-scan") {
            steps {
                script {
                    echo "开始 sonar 代码扫描"
                    
                    sh "cat scan.sh | sed 's|\${PWD}|${env.WORKSPACE_ON_HOST}|g' > scan_in_jenkins.sh"

                    sh "sh scan_in_jenkins.sh"
                }
            }
        }  

        stage("api-test") {
            steps {
                script {
                    echo "开始接口自动化测试"
                    
                    sh "cat api_test.sh | sed 's|\${PWD}|${env.WORKSPACE_ON_HOST}|g' > api_test_in_jenkins.sh"

                    sh "sh api_test_in_jenkins.sh"
                    
                    // 需要安装 Jenkins HTML Publisher 插件
                    publishHTML target: [
                            allowMissing: false,
                            alwaysLinkToLastBuild: false,
                            keepAll: true,
                            reportDir: 'test/api',
                            reportFiles: 'api_report.html',
                            reportName: 'APIReport'
                        ]
                }
            }
        } 

        // 需要安装 Jenkins 钉钉插件: https://jenkinsci.github.io/dingtalk-plugin/
        stage("dingtalk") {
            steps {
                script {
                    env.END_TIME = Calendar.getInstance().getTime().format("yyyy-MM-dd HH:mm:ss",TimeZone.getTimeZone("GMT+8:00"))
                }
                echo "钉钉通知"
            }
            post {
                success {
                    dingtalk (
                        robot: "${ROBOT_ID}",
                        type: "MARKDOWN",
                        title: "Jenkins 通知",
                        text: [
                            "# [${SERVICE_NAME}](${JOB_URL})",
                            "---",
                            "- 任务：[#${BUILD_ID}](${BUILD_URL})",
                            "- 版本：${IMAGE_TAG}",
                            "- 状态：<font color='#52C41A'>成功</font>",
                            "- 开始时间：${START_TIME}",
                            "- 结束时间：${END_TIME}",
                            "- 提交人：${GIT_COMMIT_EMAIL}",
                            "- 备注：${GIT_COMMIT_MSG}"
                        ]
                    )
                }
            }
        }
    }
}
