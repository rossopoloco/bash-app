pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = 'aws-creds-id'  // 这里填你在 Jenkins 配置的 AWS 凭证 ID
        TF_WORKING_DIR = 'infra'     // Terraform 代码目录，视你的项目结构调整
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    sh 'terraform init -input=false'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "${AWS_CREDENTIALS}"
                    ]]) {
                        sh 'terraform plan -out=tfplan -input=false'
                        sh 'terraform show -no-color tfplan > plan.txt'
                        archiveArtifacts artifacts: 'plan.txt'
                    }
                }
            }
        }

        stage('Approval') {
            steps {
                input message: "是否批准执行 terraform apply？"
            }
        }

        stage('Terraform Apply') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: "${AWS_CREDENTIALS}"
                    ]]) {
                        sh 'terraform apply -input=false tfplan'
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform apply 成功！'
            // 这里可以添加邮件或Slack通知
        }
        failure {
            echo '流水线失败！'
            // 失败通知
        }
    }
}
