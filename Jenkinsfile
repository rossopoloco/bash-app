pipeline {
    agent any

    environment {
        AWS_CREDENTIALS = 'aws-creds-id'
        TF_WORKING_DIR = 'infra'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Terraform Version Checkout') {
            steps {
                dir("${TF_WORKING_DIR}"){
                    sh '''
                    terraform version
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    withCredentials([
                        usernamePassword(
                            credentialsId: "${AWS_CREDENTIALS}",
                            usernameVariable: 'TMP_AWS_ACCESS_KEY_ID',
                            passwordVariable: 'TMP_AWS_SECRET_ACCESS_KEY'
                        )
                    ]) {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$TMP_AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$TMP_AWS_SECRET_ACCESS_KEY
                            terraform init -input=false -reconfigure
                        '''
                    }
                }
            }
        }


        stage('Terraform Plan') {
            steps {
                dir("${TF_WORKING_DIR}") {
                    withCredentials([
                        usernamePassword(
                            credentialsId: "${AWS_CREDENTIALS}",
                            usernameVariable: 'TMP_AWS_ACCESS_KEY_ID',
                            passwordVariable: 'TMP_AWS_SECRET_ACCESS_KEY'
                        )
                    ]) {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$TMP_AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$TMP_AWS_SECRET_ACCESS_KEY
                            terraform plan -out=tfplan -input=false
                            terraform show -no-color tfplan > plan.txt
                        '''
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
                    withCredentials([
                        usernamePassword(
                            credentialsId: "${AWS_CREDENTIALS}",
                            usernameVariable: 'TMP_AWS_ACCESS_KEY_ID',
                            passwordVariable: 'TMP_AWS_SECRET_ACCESS_KEY'
                        )
                    ]) {
                        sh '''
                            export AWS_ACCESS_KEY_ID=$TMP_AWS_ACCESS_KEY_ID
                            export AWS_SECRET_ACCESS_KEY=$TMP_AWS_SECRET_ACCESS_KEY
                            terraform apply -input=false tfplan
                        '''
                    }
                }
            }
        }
    }

    post {
        success {
            echo '✅ Terraform apply 成功！'
        }
        failure {
            echo '❌ 流水线失败！'
        }
    }
}
