Pixelated-Platform
==================

**Pixelated is in early development stage! Things may not work to their full extent yet**

It is the objective of the Pixelated Platform to provide a simple to install and maintain mail server based on the LEAP Platform.

* The Pixelated Platform holds the installation scripts for the Pixelated components.
* In this repository, you also find the Pixelated Threat Model (currently in development)

![Highlevel Architecture](https://pixelated-project.org/drawings/architecture-overview.jpg)


## Installing the Pixelated Platform

### Installing a LEAP provider

You need a running LEAP provider to use Pixelated. Please refer to <https://leap.se/en/docs/platform/tutorials/single-node-email> for help with setting up a LEAP provider.

For the following we assume that you have the LEAP platform and the configuration for your LEAP node on your local workstation. If you followed the tutorial to the letter you should have the following directories:

* `~/leap/leap_plaform`: the LEAP platform itself
* `~/leap/example`: the configuration for your LEAP provider node

Ideally you have run `leap deploy` and `leap test` to set up the node on a server and verify that the installation actually works.


### Adding Pixelated to your existing LEAP configuration

We have puppet scripts that takes care of (almost) everything. The scripts will install the pixelated-dispatcher and the pixelated-user-agent.

Add the pixelated-platform files to `files/puppet` inside your LEAP configuration folder.

If you have put your LEAP configuration under Git control as suggested in the tutorial, the easiest way to get the Pixelated platform is to add it as a submodule.

    cd ~/leap/example
    git submodule add https://github.com/pixelated-project/pixelated-platform.git files/puppet

If you haven't added version control to your LEAP configuration, you can simply clone the Pixelated platform files into your node configuration.

    cd ~/leap/example
    git clone https://github.com/pixelated-project/pixelated-platform.git files/puppet


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

**Bug Alert:** Currently the Puppet script requires a `/home/leap` directory to exist on the LEAP provider. Please add this manually:

    leap ssh node1        # log into LEAP node
    mdkir /home/leap


### Installing Pixelated on the LEAP provider node

With Pixelated added to the configuration simply re-run the LEAP deployment.

    leap deploy
    leap test
    
When this completes Pixelated should be ready and available on port 8080 on your LEAP provider.    
    
**Bug Alert:** Sometimes the dispatcher does not start automatically. If you get a "connection refused" when trying to access Pixelated, please start the dispatcher manually.

    leap ssh node1       # log into LEAP node
    /etc/init.d/pixelated-dispatcher-proxy start
    
    
### Trouble-shooting

The dispatcher uses Docker to run the user agents for the individual users, i.e. the user agent is not directly visible in the process list because it runs inside a docker container. To view the currently running instances log into the Pixelated provider, using `leap ssh node1` for example, and use the Docker commandline

    root@node1:~# docker ps
    CONTAINER ID        IMAGE                                   COMMAND                CREATED             STATUS              PORTS                      NAMES
    070171caaa1d        pixelated/pixelated-user-agent:latest   "/bin/bash -l -c '/u   4 hours ago         Up 3 hours          127.0.0.1:5000->4567/tcp   erik           
    
In the last column you can see the user name. It is possible to access the log files for this instance as follows:

    docker logs <username>
    
    
    
    

