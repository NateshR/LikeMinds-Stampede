pipeline {
    agent any
   
    stages {
        stage("Checkout") {
            steps {
                checkout scm
            }
        }

        stage("Build Kettle Docker Image") {
            when {
                expression {
                    return enable_kettle
                }
            }

            stages{
                stage("Checkout code") {
                    steps {
                        script {
                            dir('likeminds-authentication') {
                                git credentialsId: 'df5b81c3-2bfe-4938-a421-5f55f996e76a', url: 'https://github.com/NateshR/LikeMinds-Authentication/'
                                sh 'echo "Kettle code cloned"'
                            }
                        }
                    }
                }

                stage("Building Application Docker Image"){
                    steps{
                        script{
                            sh 'gcloud auth configure-docker asia.gcr.io'

                            docker.withRegistry('https://asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-authentication') {

                                def customImage = docker.build("kettle:${env.BUILD_NUMBER}", "-f /var/lib/jenkins/workspace/likeminds-stampede/likeminds-authentication/Dockerfile.kettle-beta -t asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-authentication/kettle:${BUILD_NUMBER} /var/lib/jenkins/workspace/likeminds-stampede/likeminds-authentication/")

                                /* Push the container to the custom Registry */
                                customImage.push()
                            }

                            sh 'echo "Image Creation done"'
                        }
                    }
                }

                // stage("Pushing Application Docker Image to Google Artifact Registry"){
                //     steps{
                //         script{
                //             sh 'gcloud auth configure-docker asia.gcr.io'
                //             sh 'docker push asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-authentication/kettle:${BUILD_NUMBER}'
                //             sh 'echo "Image Pushed to GCP"'
                //         }
                //     }
                // }

                stage("Checkout dir") {
                    steps {
                        script {
                            sh 'cd ..'
                            sh 'echo "Directory Checked Out"'
                        }
                    }
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
                    sh """terraform ${action} --auto-approve \
                    -var 'project_id=${PROJECT_ID}' \
                    -var 'region=${LOCATION}' \
                    -var 'cluster_name=${CLUSTER_NAME}' \
                    -var 'namespace_name=${namespace_name}' \
                    -var 'enable_kettle=${enable_kettle}' \
                    -var 'kettle_app_name=${kettle_app_name}' \
                    -var 'kettle_app_docker_image=${kettle_app_docker_image}' \
                    -var 'enable_swarm=${enable_swarm}' \
                    -var 'swarm_app_name=${swarm_app_name}' \
                    -var 'swarm_app_docker_image=${swarm_app_docker_image}' \
                    -var 'enable_caravan=${enable_caravan}' \
                    -var 'caravan_app_name=${caravan_app_name}' \
                    -var 'caravan_app_docker_image=${caravan_app_docker_image}' \
                    -var 'enable_caravan_celery=${enable_caravan_celery}' \
                    -var 'caravan_celery_app_name=${caravan_celery_app_name}' \
                    -var 'caravan_celery_app_docker_image=${caravan_celery_app_docker_image}' \
                    -var 'enable_caravan_rabbitmq=${enable_caravan_rabbitmq}' \
                    -var 'caravan_rabbitmq_app_name=${caravan_rabbitmq_app_name}' \
                    -var 'caravan_rabbitmq_app_docker_image=${caravan_rabbitmq_app_docker_image}'
                    """
                }
            }
        }
    }
}
