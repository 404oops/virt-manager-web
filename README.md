virt-manager-web
=================

A minimal container that runs `virt-manager` and exposes it through GTK Broadway (HTML5 backend) directly in your browser.

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
http://localhost:8085
```

Or run it via the CLI:
```bash
docker run --name virt-manager-web \
  --restart unless-stopped \
  -p 8085:8085 \
  -v /var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock:rw \
  ghcr.io/404oops/virt-manager-web:latest
```

> [!IMPORTANT]
> When logging in, you'll see an error that the Virtual Machine Manager can't communicate with the daemon. To mitigate this, open "File", then "Add Connection", select "Custom URI..." and then put `qemu:///system?socket=/var/run/libvirt/libvirt-sock` into the field.

Broadway notes
--------------
- GTK Broadway has different behavior than local GTK/X11. Some key combinations and drag/drop operations can feel different depending on browser.
- If you expose this beyond localhost, place it behind TLS and authentication (for example via reverse proxy), because Broadway itself does not provide strong built-in access control.

Security note
-------------
This setup bind-mounts your host libvirt socket (`/var/run/libvirt/libvirt-sock`) into the container. Passing through anything else is stupid, because you're passing through a handler that the container interfaces with.