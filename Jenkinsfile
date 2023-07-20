pipeline {
    agent any
   
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
                    sh """terraform ${action} --auto-approve \
                    -var 'project_id=${PROJECT_ID}' \
                    -var 'region=${LOCATION}' \
                    -var 'cluster_name=${CLUSTER_NAME}' \
                    -var 'namespace_name=${namespace_name}' \
                    """
                }
            }
        }
    }
}
