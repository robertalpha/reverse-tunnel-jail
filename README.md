# The simplest/smallest and secure reverse-tunnel SSH Server
This is a very simple alpine based SSHD server, listening on port 22 to receive a single incoming reverse tunnel connection. This is for the sole purpose of opening a reverse tunnel in a secure and convenient way.

## Security features:
* The root user account is disabled for ssh access.
* The only authentication enabled over ssh is key based authentication. Repeat: Password based authentication is disabled.
* The container expects a ENV variable named "AUTHORIZED_KEYS" containing your SSH public key in it. If this ENV var is found empty, this container does not start. This prevents it becoming an open-(ssh)-relay. 
* The user tunuser is ONLY allowed to open a reverse tunnel on port 2022. No other port is allowed.
* The user tunuser cannot open an interactive shell without being disconnected immediatly. 
* Only non-interactive sessions allowed using -N parameter.
* User tunuser has /bin/false environment (no terminal command will work)

So simply pass your ssh public key as env var AUTHORIZED_KEYS to the container at run time, and you are good to go. You can actually pass multiple SSH public keys by putting them in one file, and then letting the entire file load as a string in this ENV variable. For example:

# Start container with a key: 
Running the command:
```docker run -e AUTHORIZED_KEYS="$(cat ~/.ssh/id_rsa.pub)" robertnoyb/restricted-reverse-tunnel```

gives output:
```
Populating /home/tunuser/.ssh/authorized_keys with the value from AUTHORIZED_KEYS env variable ...
Running. To test setup run:
 ssh -TN -R 2022:localhost:8022  tunuser@172.17.0.2
this tunnels you hosts port 8022 to the container's port 2022
Server listening on 0.0.0.0 port 22.

```

Now to test, tunnel your host port 8022 to the container port 2022 using ssh (ip address could be different in your case):
```
ssh -TN -R 2022:localhost:8022  tunuser@172.17.0.2
```

# Credits
* Thanks to Eficode Praqma for sharing the code for their "The simplest/smallest SSH Server" container, allowing me to fork build upon. That project is found here: https://github.com/Praqma/alpine-sshd
* Thanks for the feedback @Janoz https://github.com/Janoz-NL