pipeline {
    agent any

    environment {
        JENKINS_HOME_ON_HOST = "/var/lib/jenkins"                                                // Jenkins Home 目录，用于 Jenkins 以容器方式启动的情况
        WORKSPACE_ON_HOST = env.WORKSPACE.replace("/var/lib/jenkins", env.JENKINS_HOME_ON_HOST)  // 宿主机工作目录
        SERVICE_NAME = "golang-ci"                                                               // 服务名称
        REGISTRY_HOST = ""                                                                       // 镜像仓库地址
        IMAGE_NAME = "${env.REGISTRY_HOST}/${env.SERVICE_NAME}"                                  // 镜像名称
    }

    stages {
        stage("pre-build") {
            steps {
                script {
                    echo "打印构建信息"
                    sh "export"

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
    }
}
