pipeline {
   agent {
       docker{
           image "python:3.5.1"
       }
   }

   stages {
      stage('Setup') {
         steps {
            sh "apt-get install -r requirements.txt"
         }
      }
      stage("Test"){
          steps{
              sh 'robot -d .logs/test'
          }
      }
   }
}