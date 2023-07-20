pipeline {
    agent any
   
    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Create a variables file") {
            steps {
                script {
                    writeFile file: 'terraform_test.tfvars', 
                    text: '''project_id=${PROJECT_ID}
region=${LOCATION}
cluster_name=${CLUSTER_NAME}
                    '''
                }
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
