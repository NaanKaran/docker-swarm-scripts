
# Intallation Steps #

## DockerDefault ##
Download any one from below url

```powershell
https://download.docker.com/win/static/stable/x86_64/
```

## Solution: Use an Alternative Source ##
Since dockermsft.azureedge.net is not found, you should switch to Docker’s official repository, which provides stable binaries for Windows Server. Here’s how to proceed with your Docker installation on Windows Server 2022:

### 1. Download Docker from Docker Hub ###
Use a current, stable version from download.docker.com:

``` powershell
Invoke-WebRequest -Uri "https://download.docker.com/win/static/stable/x86_64/docker-24.0.7.zip" -OutFile "docker.zip"
```

This fetches Docker 24.0.7, released in 2023, compatible with Windows Server 2022. For the latest version, check Docker’s official download page.

### 1. Extract the Files ###
```powershell

Expand-Archive -Path "docker.zip" -DestinationPath "C:\Program Files\Docker"
```

### 3. Update the PATH ###

Make Docker commands accessible:

```powershell

[Environment]::SetEnvironmentVariable("Path", "$($env:Path);C:\Program Files\Docker", [System.EnvironmentVariableTarget]::Machine)
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::Machine)

```

### 4. Register and Start Docker Service ###

```powershell

cd "C:\Program Files\Docker"
.\dockerd --register-service
Start-Service Docker
```
### 5. Verify Installation ###

```powershell

docker version
docker run hello-world
If docker version shows Client and Server details and hello-world runs, you’re set.
```


## Install GPMD ##

```powershell
Invoke-WebRequest -Uri "https://github.com/NaanKaran/docker-swarm-scripts/archive/refs/heads/master.zip" -OutFile "docker-swarm-scripts.zip"

```