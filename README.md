puppet-pixelated
================

**Pixelated is in an early stage of development! Things may not work to their full extent yet**

This puppet module provides a simple way to add Pixelated to a running [LEAP Platform](https://leap.se/en/docs/platform).
It sets up the [Pixelated Dispatcher](https://github.com/pixelated/pixelated-dispatcher), a multi-user instance of the
[Pixelated User-Agent](https://github.com/pixelated/pixelated-user-agent).

### High level Architecture
#### Pixelated Platform

![High-level Architecture](https://pixelated-project.org/assets/images/pixelated-platform.png)


## 1 Creating a LEAP Provider

Pixelated is built on top of LEAP, so in order to have a Pixelated Platform, you need to have a LEAP Platform.

In this example, we use a single node setup. Please refer to <https://leap.se/en/docs/platform/tutorials/single-node-email> for help with setting up a LEAP provider.
We assume that you have the LEAP platform and the configuration for your LEAP node on your local workstation. If you followed the tutorial you should have the following directories:

* `~/leap/leap_plaform`: the LEAP platform itself
* `~/leap/example`: the configuration for your LEAP provider node

Ideally you have run `leap deploy` and `leap test` to set up the node on a server and verify that the installation actually works.


### 2.1 Adding Pixelated to your existing LEAP configuration

We have puppet scripts that takes care of (almost) everything. The scripts will install the pixelated-dispatcher and the pixelated-user-agent.

Add the pixelated-platform files to `files/puppet` inside your LEAP configuration folder.

```bash
    cd ~/leap/example
    mkdir -p files/puppet/modules
```


The documentation for the installation of the LEAP Platform suggests that you make the configuration folder (`~/leap/example` is the name they suggest) versioned using Git to make it easier to track and undo any changes on the configuration. If you followed this suggestion of the tutorial, the easiest way to get the Pixelated platform is to add it as a submodule.

```bash
    git submodule add https://github.com/pixelated/puppet-pixelated.git files/puppet/modules/pixelated
    git submodule update --init
```

If you haven't added version control to your LEAP configuration, you can simply clone the Pixelated platform files into your node configuration.

```bash
    git clone https://github.com/pixelated/puppet-pixelated.git files/puppet/modules/pixelated
```

Include the `::pixelated::dispatcher` class in the `custom` class, which gets automatically applied by the leap_platform.

```bash
   mkdir -p files/puppet/modules/custom/manifests
   echo 'class custom { include ::pixelated::dispatcher }' > files/puppet/modules/custom/manifests/init.pp
```


### 2.2 Installing Pixelated on the LEAP provider node

With Pixelated added to the configuration simply re-run the LEAP deployment.

    leap deploy
    leap test

When this completes Pixelated should be ready and available on port 8080 on your LEAP provider.

**Bug Alert:** Sometimes the dispatcher does not start automatically. If you get a "connection refused" when trying to access Pixelated, please start the dispatcher manually.

    leap ssh node1       # log into LEAP node
    /etc/init.d/pixelated-dispatcher-proxy start


# 3 Troubleshooting

The dispatcher uses Docker to run the user agents for the individual users, i.e. the user agent is not directly visible in the process list because it runs inside a docker container. To view the currently running instances log into the Pixelated provider, using `leap ssh node1` for example, and use the Docker commandline

    root@node1:~# docker ps
    CONTAINER ID        IMAGE                                   COMMAND                CREATED             STATUS              PORTS                      NAMES
    070171caaa1d        pixelated/pixelated-user-agent:latest   "/bin/bash -l -c '/u   4 hours ago         Up 3 hours          127.0.0.1:5000->4567/tcp   erik

In the last column you can see the user name. It is possible to access the log files for this instance as follows:

    docker logs <username>

Have fun!
