pipeline {
    agent any

    stages {
        stage("Checkout") {
            steps {
                git branch: 'feature/LM-8246_LoadTestingFramework', credentialsId: 'df5b81c3-2bfe-4938-a421-5f55f996e76a', url: 'https://github.com/NateshR/LikeMinds-Stampede/'
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

    post {
        always {
            cleanWs()
        }
    }
}
