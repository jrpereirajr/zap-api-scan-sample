## zap-api-scan-sample
An example on how to scan your REST APIs on IRIS using the OWASP Zed Attack Proxy (ZAP) API vulnerabilities scanner.

UNDER DEVELOPMENT

## Project goal
This project aims to show you a basic example on how to run a ZAP API scanner to specific REST APIs or all ones in a namespace. Thus, you can integrate such scanning into your ObjectScript project, like the IRIS %UnitTest.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation for development with Docker
Clone/git pull the repo into any local directory:
```
$ git clone https://github.com/jrpereirajr/zap-api-scan-sample.git
$ cd zap-api-scan-sample
```
Open the terminal in this directory and run:
```
$ docker-compose up -d --build
```
**Note**: as in this version a file transfer is used in order to let containers to communicate to each other, it’s necessary to grant some privileges for writing in the shared volume:
```
$ chmod 777 -R zap-pool
```
