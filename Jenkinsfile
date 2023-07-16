pipeline {
    agent any
    tools {
       terraform 'terraform'
    }
    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Authenticate with GCloud") {
            steps {
                script {
                    sh 'gcloud container clusters get-credentials ${CLUSTER_NAME} --region ${LOCATION} --project ${PROJECT_ID} --internal-ip'
                }
            }
        }


        stage("Terraform init"){
            steps{
                script{
                    sh 'terraform init'
                }
            }
        }

        stage("Terraform action"){
            steps{
                script{
                    sh 'terraform ${action} --auto-approve'
                }
            }
        }
    }
}
