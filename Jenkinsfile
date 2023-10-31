pipeline {
    agent any
    
    tools {
        terraform 'terraform'
    }
    stages {
        stage ("checkout from GIT") {
            steps {
                git branch: 'main', credentialsId: 'e3a147f9-8175-43e8-8640-421cb057905e', url: 'https://github.com/emir06900/vs-aws'
            }
        }
        stage ("terraform init") {
            steps {
                sh 'terraform init'
            }
        }
        stage ("terraform fmt") {
            steps {
                sh 'terraform fmt'
            }
        }
        stage ("terraform validate") {
            steps {
                sh 'terraform validate'
            }
        }
        stage ("terrafrom plan") {
            steps {
                sh 'terraform plan'
            }
        }
        stage ("terraform apply") {
            steps {
                sh 'terraform apply --auto-approve'
                IF %ERRORLEVEL% EQU 1 (exit /B 0) ELSE (exit /B 1)'''
            }
        }
    }
}