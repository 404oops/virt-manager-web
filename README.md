virt-manager-web
=================

A minimal container that runs `virt-manager` inside a GUI-enabled base image (based on [jlesage/baseimage-gui](https://github.com/jlesage/docker-baseimage-gui)) and exposes a web-accessible VNC session.

Why
---
I have a NAS which has Debian installed. The ultimate problem with it is that I am not willing to install other systems which have Hypervisor functionality. Libvirt is accessible over SSH, but I need a way to access it on other machines, like a Windows one or, eventually, a remote system.

Quick start
-----------
Build and run with Docker Compose:
```bash
docker-compose up --build -d
```
Then open the web GUI at:
```text
http://localhost:5800
```

If you want VNC access instead, use port `5900`.

Or run it via the CLI:
```bash
docker run --name virt-manager-web \
  --restart unless-stopped \
  -p 5800:5800 \
  -p 5900:5900 \
  -v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock:rw \
  ghcr.io/404oops/virt-manager-web:latest
```

Security note
-------------
This setup bind-mounts your host libvirt socket (`/var/run/libvirt/libvirt-sock`) into the container. Passing through anything else is stupid, because you're passing through a handler that the container interfaces with.