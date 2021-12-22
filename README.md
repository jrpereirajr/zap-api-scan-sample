## zap-api-scan-sample
An example on how to scan your REST APIs on IRIS using the OWASP Zed Attack Proxy (ZAP) API vulnerabilities scanner.
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
This project uses  three capabilities of ZAP to provide reports: plain text, HTML and Markdown.

The plain text just shows which tests passed and which failed, as well a summary at the end. A code for details about the OWASP vulnerability is also presented for each test.
```
-------------------------------------------
ZAP API Scan for: /crud
-------------------------------------------
2021-11-29 03:44:16,920 Could not find custom hooks file at /home/zap/.zap_hooks.py 
2021-11-29 03:44:32,869 Number of Imported URLs: 8
Total of 19 URLs
PASS: Directory Browsing [0]
PASS: Vulnerable JS Library [10003]
PASS: Cookie No HttpOnly Flag [10010]
...
PASS: Loosely Scoped Cookie [90033]
WARN-NEW: Content Security Policy (CSP) Header Not Set [10038] x 6 
        http://host.docker.internal:52773/crud/persons/all (401 Unauthorized)
        http://host.docker.internal:52773/crud/ (401 Unauthorized)
        http://host.docker.internal:52773/crud/_spec (401 Unauthorized)
        http://host.docker.internal:52773/crud/persons/id (401 Unauthorized)
        http://host.docker.internal:52773/crud/persons/id (401 Unauthorized)
...
FAIL-NEW: 0     FAIL-INPROG: 0  WARN-NEW: 3     WARN-INPROG: 0  INFO: 0 IGNORE: 0       PASS: 74
-------------------------------------------
Markdown: /irisdev/app/zap-pool/report-md/6607713456438727.md
HTML: /irisdev/app/zap-pool/report-html/6607713456438727.html
```
At the bottom of the plain text report, the path for HTML and Markdown reports are presented. These reports are similar and have much more details, like vulnerability description and a quick help on how to fix it, for instance:

---
### [ Content Security Policy (CSP) Header Not Set ](https://www.zaproxy.org/docs/alerts/10038/)

##### Medium (High)

### Description

Content Security Policy (CSP) is an added layer of security that helps to detect and mitigate certain types of attacks, including Cross Site Scripting (XSS) and data injection attacks. These attacks are used for everything from data theft to site defacement or distribution of malware. CSP provides a set of standard HTTP headers that allow website owners to declare approved sources of content that browsers should be allowed to load on that page — covered types are JavaScript, CSS, HTML frames, fonts, images and embeddable objects such as Java applets, ActiveX, audio and video files.

* URL: http://host.docker.internal:52773/crud/persons/id
  * Method: `DELETE`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``

...

* URL: http://host.docker.internal:52773/crud/persons/id
  * Method: `PUT`
  * Parameter: ``
  * Attack: ``
  * Evidence: ``

Instances: 6

### Solution

Ensure that your web server, application server, load balancer, etc. is configured to set the Content-Security-Policy header, to achieve optimal browser support: "Content-Security-Policy" for Chrome 25+, Firefox 23+ and Safari 7+, "X-Content-Security-Policy" for Firefox 4.0+ and Internet Explorer 10+, and "X-WebKit-CSP" for Chrome 14+ and Safari 6+.

---

## How does it work?
ZAP has several ways to perform security tests, such as scripts or API. This project used execution by scripts executed in an official docker image of ZAP.

So, in order to let the IRIS container execute scripts in the ZAP container, a shared volume was set up in docker-compose.yaml file. In this volume, IRIS writes scripts which are detected and executed by the ZAP container. In the same way, the ZAP container writes out the output in the same shared volume, so the IRIS container can read them.

As an improvement in this project, I’m planning to use the ZAP API in place of file sharing. An API for executing tests and presenting reports directly in the browser is also planned.

## GitHub Action

You can configure a GitHub action to perform API scans on every push to the repository. Check out [this example](https://github.com/jrpereirajr/zap-api-scan-sample/blob/master/.github/workflows/owasp-zap-api-scan.yaml) to see how to do it. You can also get more information in (this article)[https://community.intersystems.com/post/zap-api-scan-github-action].

## Articles

English: 
*   https://community.intersystems.com/post/why-how-whats-zap-api-scan-sample
*   https://community.intersystems.com/post/zap-api-scan-github-action

Português: https://pt.community.intersystems.com/post/por-que-como-o-que-%C3%A9-zap-api-scan-sample

## Video

[![](https://img.youtube.com/vi/k7tlUXGPPb8/0.jpg)](https://www.youtube.com/watch?v=k7tlUXGPPb8)

## Dream team

* [Henrique Dias](https://community.intersystems.com/user/henrique-dias-2)
* [José Roberto Pereira](https://community.intersystems.com/user/jos%C3%A9-roberto-pereira-0)
