<img src="https://raw.githubusercontent.com/onc-healthit/inferno/master/public/images/inferno_logo.png" width="300px" />

[![Build Status](https://travis-ci.org/onc-healthit/inferno.svg?branch=master)](https://travis-ci.org/onc-healthit/inferno)

deqm-test-client is a fork of the Inferno project specifically tailored for testing FHIR servers ability to perform functions relevent to quality reporting.

Inferno is an open source tool that tests whether patients can access their health data through a standard interface.
It makes HTTP(S) requests to test your server's conformance to authentication, authorization, and FHIR content standards and reports the results back to you.

## Using deqm-test-client

If you are new to FHIR or SMART-on-FHIR, you may want to review the [Inferno Quick Start Guide](https://github.com/onc-healthit/inferno/wiki/Quick-Start-Guide).

## Installation and Deployment

### Docker Installation From Image
1. Install [Docker](https://www.docker.com/) for the host platform as well as the [docker-compose](https://docs.docker.com/compose/install/) tool (which may be included in the distribution, as is the case for Windows and MacOS).
2. Run `docker run <image>`

### Docker Installation From Source

Docker is the recommended installation method for Windows devices and can also be used on Linux and MacOS hosts.

1. Install [Docker](https://www.docker.com/) for the host platform as well as the [docker-compose](https://docs.docker.com/compose/install/) tool (which may be included in the distribution, as is the case for Windows and MacOS).
2. Download the [latest release of the `inferno` project](https://github.com/projecttacoma/deqm-test-client) to your local computer on a directory of your choice.
3. Open a terminal in the directory where the project was downloaded (above).
4. Run the command `docker-compose up` to start the server. This will automatically build the Docker image and launch both the ruby server (using unicorn) and an NGINX web server.
5. Navigate to http://localhost:8080 to find the running application.

If the docker image gets out of sync with the underlying system, such as when new dependencies are added to the application, you need to run `docker-compose up --build` to rebuild the containers.

Check out the [Troubleshooting Documentation](https://github.com/onc-healthit/inferno/wiki/Troubleshooting) for help.


## License

Copyright 2019 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
```
http://www.apache.org/licenses/LICENSE-2.0
```
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
