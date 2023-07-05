pipeline {
    agent any

    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Terraform init"){
            steps{
                script{
                    echo 'terraform init'
                    // sh 'terraform init'
                }
            }
        }

        stage("Terraform action"){
            steps{
                script{
                    echo 'terraform ${action} --auto-approve'
                    // sh 'terraform ${action} --auto-approve'
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
