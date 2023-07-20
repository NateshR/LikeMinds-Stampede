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
                    -var 'enable_kettle=${enable_ketttle}' \
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
