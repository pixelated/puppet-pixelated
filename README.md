Pixelated-Platform
==================

**Pixelated is in early development stage! Things may not work to their full extent yet**

It is the objective of the Pixelated Platform to provide a simple to install and maintain mail server based on the LEAP Platform.

* The Pixelated Platform holds the installation scripts for the Pixelated components.
* In this repository, you also find the Pixelated Threat Model (currently in development)

### High level Architecture
#### Pixelated Platform

![Highlevel Architecture](https://pixelated-project.org/assets/images/pixelated-platform.png)


## Installing the Pixelated Platform

Pixelated is built on top of LEAP, so in order to have a Pixelated Platform, you need to have a LEAP Platform. There are 2 ways of installing the Pixelated Platform:

1. Setup your own ["Pixelated Provider"](https://github.com/pixelated-project/pixelated-platform#how-to-setup-your-own-pixelated-platform), which is a LEAP provider with the Pixelated Platform already setup on it (recommended), or
2. Having an installation of a [LEAP provider](https://github.com/pixelated-project/pixelated-platform#installing-a-leap-provider) and adding the Pixelated Platform to it


## 1. Setup your own Pixelated Platform

If you don't already have a LEAP Provider that you want to turn into a Pixelated Provider, we provide a script that does all the configuration of the LEAP Platform and the Pixelated Platform. All you need to setup your own Pixelated Platform is root access to a debian wheezy box. 


### 1.1 Vagrant/VirtualBox

You can try setting up a virtual machine on your computer to try out the Pixelated Platform. For this you'll need [vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/).

After you have installed both tools, you can clone pixelated-platform repository and use the Vagrantfile provided there by running these commands in a terminal (this is probably the easiest option):

```bash
$ git clone https://github.com/pixelated-project/pixelated-platform.git
$ cd pixelated-platform

$ vagrant up
```

With this you'll have a virtual machine running the necessary version of Debian to proceed with the installation of the LEAP provider and the Pixelated Platform.

### 1.2 Installation

To run the installation, you'll need to ssh into the machine and become root.

If you are using the vagrant/VirtualBox combination mentioned above, run:
```bash
vagrant ssh
sudo bash
```

If you set up your Debian box by another method (using a physical machine, a cloud provider, etc), you'll need to ssh into the box using it's ip.

The only thing left is to execute the bootstrap script *convert-to-pixelated.sh*:

```bash
wget https://raw.githubusercontent.com/pixelated-project/pixelated-platform/master/convert-to-pixelated.sh && chmod +x convert-to-pixelated.sh && ./convert-to-pixelated.sh
```

*This might take quite a while!*

This script will automate the installation of the LEAP Provider and the Pixelated Platform. During the installation, it'll prompt you the information requested when running the `leap new .` command from [Bootstrap the provider](https://leap.se/en/docs/platform/tutorials/single-node-email#bootstrap-the-provider) section of the LEAP tutorial. Go there for more information about this step.

After the script finishes running, you should have your brand new provider all set up. You can proceed creatting accounts and using them.

To create a mail account on your new provider, open [https://localhost/](https://localhost/) and sign up.
To use the account, open [https://localhost:8080/](https://localhost:8080) and log into your new account.




## 2. Installing on a LEAP provider

Please refer to <https://leap.se/en/docs/platform/tutorials/single-node-email> for help with setting up a LEAP provider.

For the following we assume that you have the LEAP platform and the configuration for your LEAP node on your local workstation. If you followed the tutorial to the letter you should have the following directories:

* `~/leap/leap_plaform`: the LEAP platform itself
* `~/leap/example`: the configuration for your LEAP provider node

Ideally you have run `leap deploy` and `leap test` to set up the node on a server and verify that the installation actually works.


### 2.1 Adding Pixelated to your existing LEAP configuration

We have puppet scripts that takes care of (almost) everything. The scripts will install the pixelated-dispatcher and the pixelated-user-agent.

Add the pixelated-platform files to `files/puppet` inside your LEAP configuration folder.

The documentation for the installation of the LEAP Platform suggests that you make the configuration folder (`~/leap/example` is the name they suggest) versioned using Git to make it easier to track and undo ant changes on the configuration. If you followed this suggestion of the tutorial, the easiest way to get the Pixelated platform is to add it as a submodule.

```bash
    cd ~/leap/example
    git submodule add https://github.com/pixelated-project/pixelated-platform.git files/puppet
```

If you haven't added version control to your LEAP configuration, you can simply clone the Pixelated platform files into your node configuration.

```bash
    cd ~/leap/example
    git clone https://github.com/pixelated-project/pixelated-platform.git files/puppet
```

Adding the Pixelated Platform repo to `files/puppet` will add all the necessary configuration to turn your LEAP Provider into a Pixelated Provider.

**Bug Alert:** Currently there is a bug with the setup. You have to manually add the "monitor" service to the services section in `nodes/node1.json`. After the edits the file should look like this:

    {
      "ip_address": "XXX.XXX.XXX.XXX",
      "services": [
        "couchdb",
        "mx",
        "soledad",
        "webapp",
        "monitor"
      ],
      "tags": "production"
    }

### 2.2 Installing Pixelated on the LEAP provider node

With Pixelated added to the configuration simply re-run the LEAP deployment.

    leap deploy
    leap test
    
When this completes Pixelated should be ready and available on port 8080 on your LEAP provider.    
    
**Bug Alert:** Sometimes the dispatcher does not start automatically. If you get a "connection refused" when trying to access Pixelated, please start the dispatcher manually.

    leap ssh node1       # log into LEAP node
    /etc/init.d/pixelated-dispatcher-proxy start
    


# Troubleshooting

The dispatcher uses Docker to run the user agents for the individual users, i.e. the user agent is not directly visible in the process list because it runs inside a docker container. To view the currently running instances log into the Pixelated provider, using `leap ssh node1` for example, and use the Docker commandline

    root@node1:~# docker ps
    CONTAINER ID        IMAGE                                   COMMAND                CREATED             STATUS              PORTS                      NAMES
    070171caaa1d        pixelated/pixelated-user-agent:latest   "/bin/bash -l -c '/u   4 hours ago         Up 3 hours          127.0.0.1:5000->4567/tcp   erik           
    
In the last column you can see the user name. It is possible to access the log files for this instance as follows:

    docker logs <username>

Have fun!
