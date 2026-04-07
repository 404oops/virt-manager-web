virt-manager-web
=================

A minimal container that runs `virt-manager` inside a GUI-enabled base image (based on [jlesage/baseimage-gui](https://github.com/jlesage/docker-baseimage-gui)) and exposes a web-accessible VNC session.

Why
---
I have a NAS which has Debian installed. The ultimate problem with it is that I am not willing to install other systems which have Hypervisor functionality built in. I installed Libvirt on it, which is accessible over SSH, but I need a way to access it seamlessly on machines like a Windows client or, eventually, a remote system, like a café PC.

Quick start
-----------
> [!IMPORTANT]
> If you see an error that says "Could not detect a default hypervisor. Make sure the appropriate QEMU/KVM virtualization and libvirt packages are installed to manage virtualization on this host.", hit "File" on the top left, then "Add Connection", select "Custom URI..." and then put `qemu:///system?socket=/var/run/libvirt/libvirt-sock` into the field.
With Docker Compose:
```yaml
services:
  virt-manager-web:
    image: ghcr.io/404oops/virt-manager-web:latest
    container_name: virt-manager-web
    restart: unless-stopped
    ports:
      - 5800:5800 # Web port
      - 5900:5900 # VNC port
    environment:
      - WEB_AUTHENTICATION=0
      - KEEP_APP_RUNNING=1
      - LIBVIRT_DEFAULT_URI=qemu:///system?socket=/var/run/libvirt/libvirt-sock
    volumes:
      - /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock:rw
```
And then run
```bash
docker-compose up -d
```
Or run it via the CLI:
```bash
docker run --name virt-manager-web \
  --restart unless-stopped \
  -p 5800:5800 \ # Web port
  -p 5900:5900 \ # VNC port
  -v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock:rw \
  ghcr.io/404oops/virt-manager-web:latest
```
Then open the web GUI at:
```text
http://localhost:5800
```
If you want VNC access instead, use port `5900`.

Security note
-------------
This setup bind-mounts your host libvirt socket (`/var/run/libvirt/libvirt-sock`) into the container. Passing through anything else is stupid, because you're passing through a handler that the container interfaces with.