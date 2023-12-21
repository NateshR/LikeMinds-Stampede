# LikeMinds Stampede

This repo contains the Jenkins file and Terraform configuration files to provision an GKE cluster on GCP containing all the existing services at LikeMinds for the purpose of performing Load Tests.

## What is this project?

This project helps us to deploy the replica of all the existing microservices, here at **LikeMinds**, and perform load test on all the APIs to compute cost and API performance.

## How to setup locally

- Setup Jenkins locally using this [doc](https://www.jenkins.io/doc/book/installing/).
- Clone this repo locally.
- Run `Jenkins` file in the repo using Jenkins dashboard.

## References

- [Engineering Document](https://likemindscommunity.atlassian.net/wiki/spaces/PRT/pages/1973354513/Load+Testing+Framework)
- [Load Test Guide](https://likemindscommunity.atlassian.net/wiki/spaces/PRT/pages/2036171142/Steps+to+Load+Test)
