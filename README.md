virt-manager-web
=================

A minimal container that runs `virt-manager` inside a GUI-enabled base image (based on [jlesage/baseimage-gui](https://github.com/jlesage/docker-baseimage-gui)) and exposes a web-accessible VNC session.

Why
---
I have a NAS which has Debian installed. The ultimate problem with it is that I am not willing to install other systems which have Hypervisor functionality. Libvirt is accessible over SSH, but I need a way to access it on other machines, like a Windows one or, eventually, a remote system.

Quick start
-----------
Make a new Docker Compose file with the contents as such;
```yaml
services:
  virt-manager-web:
    image: ghcr.io/404oops/virt-manager-web:latest
    container_name: virt-manager-web
    restart: unless-stopped
    ports:
      - "6901:6901"
    volumes:
      - /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock:rw
      # Change ^^^ if your server's libvirt socket file differs from above
```
Then run the container;
```bash
docker-compose up -d
```
Otherwise run it via the CLI:
```bash
docker run --name virt-manager-web \
  --restart unless-stopped \
  -p 6901:6901 \
  -v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock:rw \
  ghcr.io/404oops/virt-manager-web:latest
```

Then open http://localhost:6901 in your browser to access the GUI.

Security note
-------------
This setup bind-mounts your host libvirt socket (`/var/run/libvirt/libvirt-sock`) into the container. Passing through anything else is stupid, because you're passing through a handler that the container interfaces with.