pipeline {
    agent any
    stages {
        stage('checkout code from SCM') {
            steps {
                echo 'Pulling Code from GIT Repo'
            }
        }
        stage('MAVEN Build') {
            steps {
                echo 'Build the application using MAVEN'
            }
        }
    }
}

