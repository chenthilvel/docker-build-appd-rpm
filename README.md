# docker-build-appd-rpm
Docker Image to package AppDynamics AppServerAgent & MachineAgent as an RPM using [fpm](https://github.com/chenthilvel/docker-fpm).

----------

## Usage
### 1. Download AppServerAgent & MachineAgent zip files from https://download.appdynamics.com/download/ and place them in a directory.
```
    mkdir ~/AppD
    cp AppServerAgent*.zip ~/AppD/
    cp MachineAgent*.zip ~/AppD/
```
### 2. Run the container with the directory as a mount, version of AppD zip files
 + Run the container with the required version

```
    docker run -v ~/AppD:/mnt -e VER=4.2.14.0 --name appd_rpm chenthilvel/build-appd-rpm
```
 + Post docker run, RPM would be available in your local directory.
 
### 3. Upload RPM to Nexus Repository
+ Run the container with Upload flag set to 1 and provide the Nexus repository to upload the RPM along with Nexus Host and authentication details.
```
    docker run -v ~/AppD:/mnt -e VER=4.2.14.0 -e UPL=1 -e REPO=<YOUR_REPO_NAME> -e USER_PASS="<USER_NAME>:<PASSWORD>" -e NEXUS_HOST="<NEXUS_HOSTNAME_OR_IP>" --name appd_rpm chenthilvel/build-appd-rpm
```
### Clean up after saving the RPM
```
    docker rm appd_rpm
    docker rmi chenthilvel/build-appd-rpm
```
