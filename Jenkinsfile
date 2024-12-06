pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devopsified-go-app'
    }

    stages {
        stage('Clone Code') {
            steps {
                git branch: 'main', url: 'https://github.com/DhanushNadar/go-web-app.git'
            }
        }
        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                    sh '''
                    docker build . -t ${dockerHubUser}/${DOCKER_IMAGE}:V_${BUILD_NUMBER}
                    sed -i -e "s|^\\s*tag:.*|  tag: V_${BUILD_NUMBER}|" helm/go-app-chart/values.yaml
                    '''
                }
            }
        }
        stage('Test') {
            steps {
                sh 'go test'
            }
        }
        stage('Push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPass', usernameVariable: 'dockerHubUser')]) {
                    sh '''
                    docker login -u ${dockerHubUser} -p ${dockerHubPass}
                    docker push ${dockerHubUser}/${DOCKER_IMAGE}:V_${BUILD_NUMBER}
                    '''
                }
            }
        }
        stage('Deploy by pushing the code to Github') {
            steps {
                withCredentials([string(credentialsId: 'github', variable: 'GITHUB_TOKEN')]) {
                    sh '''
                    git config --global user.email "${EMAIL_ID}"
                    git config --global user.name "${USER_NAME}"
                    git add .
                    git commit -m "updated the latest version V_${BUILD_NUMBER}"
                    git push https://${GITHUB_TOKEN}@github.com/DhanushNadar/go-web-app.git HEAD:main
                    '''
                }
            }
        }
    }
}
