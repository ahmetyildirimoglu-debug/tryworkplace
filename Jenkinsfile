pipeline {
    agent any
    stages {
        stage('System Check') {
            steps {
                sh 'python3 /home/vagrant/sentinel/scripts/sentinel_monitor.py'
            }
        }
        stage('Docker Check') {
            steps {
                sh 'docker ps'
            }
        }
    }
}
