pipeline {
    agent any
    tools {
        maven "mvn"
        
    }
    
    environment {
        registryCredential = 'ecr:us-east-1:awscreds'
        appRegistry = "473962871244.dkr.ecr.us-east-1.amazonaws.com/test"
        vprofileRegistry = "https://473962871244.dkr.ecr.us-east-1.amazonaws.com"
    }

    stages {
        stage('Fetch code') {
            steps {
               git branch: 'master', url: 'https://github.com/mohamedmohsen20/netty-example.git'
            }

        }

        stage('Build'){
            steps{
               sh 'mvn install -DskipTests'
            }

            post {
               success {
                  echo 'Now Archiving it...'
                  archiveArtifacts artifacts: '**/target/*.jar'
               }
            }
        }

        stage('UNIT TEST') {
            steps{
                sh 'mvn test'
            }
            
        }
        
        stage('checkstyle Anaysis'){
            steps{
                sh 'mvn checkstyle:checkstyle'
            }
        }
            stage('build && SonarQube analysis') {
            environment {
             scannerHome = tool 'sonar'
          }
            steps {
                withSonarQubeEnv('sonar') {
                 sh '''${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=test \
                   -Dsonar.projectName=test \
                   -Dsonar.projectVersion=1.0 \
                   -Dsonar.sources=src/ \
                   -Dsonar.java.binaries=target/classes/ '''
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 1, unit: 'HOURS') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
      
        stage('Build App Image') {
            steps {
       
                script {
                dockerImage = docker.build( appRegistry + ":$BUILD_NUMBER", ".")
                }

            }
        }
    
        stage('Upload App Image') {
          steps{
            script {
              docker.withRegistry( "https://473962871244.dkr.ecr.us-east-1.amazonaws.com", 'ecr:us-east-1:awscreds' ) {
                dockerImage.push("$BUILD_NUMBER")
                dockerImage.push('latest')
              }
            }
          }
     }
        
    stage('Deploy to ecs') {
          steps {
        withAWS(credentials: 'awscreds', region: 'us-east-1') {
          sh 'aws ecs update-service --cluster test  --service testsvc --force-new-deployment'
        }
      }
     }
        
       
    }
    
    
    post {
       // only triggered when blue or green sign
       success {
           slackSend message: "Deployment Done"
       }
    } 
   
}
