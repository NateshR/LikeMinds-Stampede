pipeline {
    agent any

    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Middle Operation") {
            steps {
                // Build docker image from the code
                // Push docker image to artifact registry
                // Update docker image tag in terraform config files
                // Proceed to deploy code using terraform
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
