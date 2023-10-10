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
                    return params.enable_kettle
                }
                expression {
                    return params.action == 'apply'
                }
            }
            steps {
                echo 'Kettle Selected'
                script {
                    dir('likeminds-authentication') {
                        git credentialsId: 'df5b81c3-2bfe-4938-a421-5f55f996e76a', url: 'https://github.com/NateshR/LikeMinds-Authentication/'
                        sh 'echo "Kettle code cloned"'

                        sh 'gcloud auth configure-docker asia.gcr.io'
                        docker.build("kettle:${env.BUILD_NUMBER}", "-f /var/lib/jenkins/workspace/likeminds-stampede/likeminds-authentication/Dockerfile.kettle-beta -t asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-authentication/kettle:${BUILD_NUMBER} /var/lib/jenkins/workspace/likeminds-stampede/likeminds-authentication/")
                        sh 'echo "Kettle Image Creation done"'

                        sh 'docker push asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-authentication/kettle:${BUILD_NUMBER}'
                        sh 'echo "Kettle Image Pushed to GCP"'
                    }
                }  
            }
        }

        stage("Build Swarm Docker Image") {
            when {
                expression {
                    return params.enable_swarm
                }
                expression {
                    return params.action == 'apply'
                }
            }
            steps {
                echo 'Swarm Selected'
                script {
                    dir('likeminds-swarm') {
                        git credentialsId: 'df5b81c3-2bfe-4938-a421-5f55f996e76a', url: 'https://github.com/NateshR/LikeMinds-Swarm/'
                        sh 'echo "Swarm code cloned"'

                        sh 'gcloud auth configure-docker asia.gcr.io'
                        docker.build("swarm:${env.BUILD_NUMBER}", "-f /var/lib/jenkins/workspace/likeminds-stampede/likeminds-swarm/Dockerfile.swarm-load -t asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-swarm/swarm:${BUILD_NUMBER} /var/lib/jenkins/workspace/likeminds-stampede/likeminds-swarm/")
                        sh 'echo "Swarm Image Creation done"'

                        sh 'docker push asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-swarm/swarm:${BUILD_NUMBER}'
                        sh 'echo "Swarm Image Pushed to GCP"'
                    }
                }  
            }
        }

        stage("Build Caravan Docker Image") {
            when {
                expression {
                    return params.enable_caravan
                }
                expression {
                    return params.action == 'apply'
                }
            }
            steps {
                echo 'Caravan Selected'
                script {
                    dir('likeminds-caravan') {
                        git credentialsId: 'df5b81c3-2bfe-4938-a421-5f55f996e76a', url: 'https://github.com/NateshR/Togther/'
                        sh 'echo "Caravan code cloned"'

                        sh '''
                        gcloud compute ssh likeminds-nonprod-migration-vm --zone=asia-south1-a --internal-ip --command="sudo chown -R jenkins /home/apps/caravan-load/"
                        gcloud compute ssh likeminds-nonprod-migration-vm --zone=asia-south1-a --internal-ip --command="cd /home/apps/caravan-load/Togther && git checkout development && git pull"
                        gcloud compute ssh likeminds-nonprod-migration-vm --zone=asia-south1-a --internal-ip --command="chmod +x /home/apps/caravan-load/Togther/Migrationfile-caravan-load.sh"
                        gcloud compute ssh likeminds-nonprod-migration-vm --zone=asia-south1-a --internal-ip --command=". /home/apps/caravan-load/Togther/Migrationfile-caravan-load.sh"
                        gcloud compute ssh likeminds-nonprod-migration-vm --zone=asia-south1-a --internal-ip --command="cd /home/apps/caravan-load/Togther && git checkout ."
                        '''
                        sh 'echo "Caravan Migration done"'

                        sh 'gcloud auth configure-docker asia.gcr.io'
                        docker.build("caravan:${env.BUILD_NUMBER}", "-f /var/lib/jenkins/workspace/likeminds-stampede/likeminds-caravan/Dockerfile.caravan-load -t asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-caravan/caravan:${BUILD_NUMBER} /var/lib/jenkins/workspace/likeminds-stampede/likeminds-caravan/")
                        sh 'echo "Caravan Image Creation done"'

                        sh 'docker push asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-caravan/caravan:${BUILD_NUMBER}'
                        sh 'echo "Caravan Image Pushed to GCP"'
                    }
                }
            }
        }

        stage("Build Caravan Celery Docker Image") {
            when {
                expression {
                    return params.enable_caravan_celery
                }
                expression {
                    return params.action == 'apply'
                }
            }
            steps {
                echo 'Caravan Celery Selected'
                script {
                    dir('likeminds-caravan-celery') {
                        git credentialsId: 'df5b81c3-2bfe-4938-a421-5f55f996e76a', url: 'https://github.com/NateshR/Togther/'
                        sh 'echo "Caravan Celery code cloned"'

                        sh 'gcloud auth configure-docker asia.gcr.io'
                        docker.build("caravan-celery:${env.BUILD_NUMBER}", "-f /var/lib/jenkins/workspace/likeminds-stampede/likeminds-caravan-celery/Dockerfile.caravan-celery-load -t asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-caravan-celery/caravan-celery:${BUILD_NUMBER} /var/lib/jenkins/workspace/likeminds-stampede/likeminds-caravan-celery/")
                        sh 'echo "Caravan Celery Image Creation done"'

                        sh 'docker push asia.gcr.io/likeminds-nonprod-prj-24e1/github.com/nateshr/likeminds-stampede/likeminds-caravan-celery/caravan-celery:${BUILD_NUMBER}'
                        sh 'echo "Caravan Celery Image Pushed to GCP"'
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
                    -var 'kettle_app_docker_image=${kettle_app_docker_image}:${BUILD_NUMBER}' \
                    -var 'kettle_cpu=${kettle_cpu}' \
                    -var 'kettle_memory=${kettle_memory}' \
                    -var 'enable_swarm=${enable_swarm}' \
                    -var 'swarm_app_name=${swarm_app_name}' \
                    -var 'swarm_app_docker_image=${swarm_app_docker_image}:${BUILD_NUMBER}' \
                    -var 'swarm_cpu=${swarm_cpu}' \
                    -var 'swarm_memory=${swarm_memory}' \
                    -var 'enable_caravan=${enable_caravan}' \
                    -var 'caravan_app_name=${caravan_app_name}' \
                    -var 'caravan_app_docker_image=${caravan_app_docker_image}:${BUILD_NUMBER}' \
                    -var 'caravan_cpu=${caravan_cpu}' \
                    -var 'caravan_memory=${caravan_memory}' \
                    -var 'enable_caravan_celery=${enable_caravan_celery}' \
                    -var 'caravan_celery_app_name=${caravan_celery_app_name}' \
                    -var 'caravan_celery_app_docker_image=${caravan_celery_app_docker_image}:${BUILD_NUMBER}' \
                    -var 'caravan_celery_cpu=${caravan_celery_cpu}' \
                    -var 'caravan_celery_memory=${caravan_celery_memory}' \
                    -var 'enable_caravan_rabbitmq=${enable_caravan_rabbitmq}' \
                    -var 'caravan_rabbitmq_app_name=${caravan_rabbitmq_app_name}' \
                    -var 'caravan_rabbitmq_app_docker_image=${caravan_rabbitmq_app_docker_image}'
                    """
                }
            }
        }
    }
}
