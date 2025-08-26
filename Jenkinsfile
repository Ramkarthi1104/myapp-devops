pipeline {
    agent any
 
    tools {
        maven 'maven-3.9'   // configured in Jenkins global tools
        jdk 'jdk-17'
    }
 
    environment {
        DOCKER_HUB = "mydockerhub/myapp"   // change with your DockerHub repo
    }
 
    stages {
        stage('Checkout') {
            steps {
git branch: 'main', url: 'https://github.com/Ramkarthi1104/myapp-devops.git'
            }
        }
 
        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }
 
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('MySonarQube') {
                    sh 'mvn sonar:sonar'
                }
            }
        }
 
        stage('Quality Gate') {
            steps {
                timeout(time: 3, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
 
        stage('Docker Build & Push') {
            steps {
                script {
def app = docker.build("${DOCKER_HUB}:${BUILD_NUMBER}")
docker.withRegistry('https://index.docker.io/v1/', 'dockerhub-credentials') {
                        app.push()
                        app.push("latest")
                    }
                }
            }
        }
    }
 
    post {
        failure {
            mail to: 'karthikeyan.ramasamy@hcltech.com',
                 subject: "Build Failed",
                 body: "Check Jenkins job: ${env.BUILD_URL}"
        }
    }
}
