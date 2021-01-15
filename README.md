# Installation Guide for LTLers


#### Updates on 15 Jan, 2021.
Now we have provide a script for installing and running glances automatically. Please download [install_and_run_docker_glances.sh](https://github.com/cambridgeltl/glances/blob/develop/install_and_run_docker_glances.sh) and run is with a "sudo" user. 

The basic pipeline of these script is the following:
	(1) install docker.
	(2) install nvidia-docker
	(3) pull glances-docker image from docker-hub
	(4) run the container as an linux service

After the running this scripting, you should able to see the exported resource data through: http://your_machine_ip:9091/.

----

There are two ways to have the glances installed in your machine and start monitoring: 

- Install it using pip and run it in the backend (ideally as a service),
- Build an image and run it as a docker container and again have it running in the backend as a service.

## Installation using pip 

### 1. Make sure you have gcc installed, if not, install it first

```shell
sudo apt install gcc
```

### 2. Install glances

```
pip install git+https://github.com/cambridgeltl/glances
```

### 3. Either

#### a. Run glances in backend with 'nohup'

```
nohup glances --export prometheus -q >> glances.log 2>&1 &
```

The [ --export prometheus ] option is to expose machine status to a port 9091

> If there is no any response, probably the default config file was not initialised normally, you can download it and move it to the default config folder:
>
> ```shell
> wget https://raw.githubusercontent.com/cambridgeltl/glances/develop/conf/glances.conf
> mkdir /home/USERNAME/.config/glances/
> mv glances.conf /home/USERNAME/.config/glances/
> ```
>
> Then try running glances again.

#### b. Run glances as a service, so that it starts up automatically each time you reboot the machine (RECOMMENDED):

- Create a file called /etc/systemd/system/glances.service using the contents of [our template](https://github.com/cambridgeltl/glances/blob/develop/glances.service)

- Enable and start the service:

  ```shell
  systemctl enable glances
  systemctl start glances
  ```

  Now the service will start automatically each time you boot the computer. 

### 4. Done. Check if it works.

You can direct check if it works by see http://hostname:9091 via a browser, which may show something like this:

```shell
# HELP python_gc_objects_collected_total Objects collected during gc
# TYPE python_gc_objects_collected_total counter
python_gc_objects_collected_total{generation="0"} 6676.0
python_gc_objects_collected_total{generation="1"} 963.0
python_gc_objects_collected_total{generation="2"} 36.0
....
```



## Installation using docker

### 1. Make sure you have docker installed; if not, install it 

#### a. NOTE: please remember to run the [post-installation steps](https://docs.docker.com/engine/install/linux-postinstall/) and add your user to the docker group.

### 2. Make sure you have [nvidia-docker2](https://github.com/NVIDIA/nvidia-docker) installed; if not, install it

#### a. Suggestion: this is a good moment to check if your Nvidia drivers are up to date. If not, please update them to the latest version. Please remember to use the nvidia-xxx-dev package.

### 3. Clone the glances project files from our lab Github pages: 

```shell
git clone https://github.com/cambridgeltl/glances
```

### 4. Under the project folder, build the glances docker images using the following script:

```shell
bash build_image.sh
```

this script will build a docker image in your local repository.

### 5. Either

#### a. Run the image as a container in your machine:

```shell
bash run_image.sh
```

> Note that you must start the container each time you boot your machine.

#### b. Set up the container to run as a service, so that it starts up automatically each time you reboot the machine (RECOMMENDED):

- Create a file called /etc/systemd/system/glances-docker.service using the contents of [our template](https://github.com/cambridgeltl/glances/blob/develop/glances-docker.service)
- Enable and start the service:

 ```shell
systemctl enable glances-docker
systemctl start glances-docker
 ```

Now the service will start automatically each time you boot the computer. 

> NOTE: systemd will restart the container if you manually kill it. If for whatever reason you need to stop the container, always do it with

```shell
systemctl stop glances-docker
```

### 6. Done. Go to http://hostname:9091 and check if you can see the exported data.
