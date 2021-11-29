## zap-api-scan-sample
An example on how to scan your REST APIs on IRIS using the OWASP Zed Attack Proxy (ZAP) API vulnerabilities scanner.

UNDER DEVELOPMENT
## Project goal
As security is a very important topic, we need to keep track of how our applications are going about security by conducting security tests periodically.

Besides that, keeping your security rules updated is a challenge, as new threats are commonly discovered. So it seems to be a good idea to rely on widely used tools to keep track of security in your applications. OWASP ZAP is one such tool.

This project aims to show you a basic example on how to run a ZAP API scanner to specific REST APIs or all ones in a namespace. Thus, you can integrate such scanning into your ObjectScript project, like the IRIS %UnitTest.
## OWASP ZAP
The [Open Web Application Security Project® (OWASP)](https://owasp.org/), is a foundation which helps people improve security in their software. It has several community-led open-source software projects. One of such projects it’s the [Zed Attack Proxy](https://owasp.org/www-project-zap/) or just ZAP.

ZAP is an open source web app scanner, maintained by security specialists around the World. It has [tons of functionalities](https://www.zaproxy.org/docs/), but here I am going to show you just its [API scanner](https://www.zaproxy.org/docs/docker/api-scan/).
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
## Scanning your APIs
This sample lets you scan each REST API or all of them at once.

For instance, if you would like to scan the API */crud*, run this command:
```
Do ##class(dc.sample.zap.filepool.ZapOpenApiScanService).%New().Print("/crud")
```
If you would like to scan all REST APIs in a namespace - USER, for instance, run this command:
```
Do ##class(dc.sample.zap.filepool.ZapOpenApiScanService).%New().PrintAllWebApps("USER")
```
If you suppress the namespace, the current one is used.
## Scanner results
## How does it work?


