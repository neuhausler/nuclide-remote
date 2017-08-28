# nuclide-remote
The Nuclide-remote Docker container enables remote editing with Nuclide. 
Further documentation about Nuclide can be found at:
https://nuclide.io/docs/features/remote/

### Version

Supports version 0.249.0 of Nuclide IDE. Can be adjusted in Dockerfile.

### Connectivity

Communication between Nuclide and Nuclide-remote uses 2 ports:
- ssh/23: needed to start nuclide remote inside Docker container
- 9090: the Nuclide communication channel

### Example

Setup access to a project at `/home/test/hello-world` on a remote host on `192.100.01.10`.
Ssh will be run over port `9091` and `9090` will be used by Nuclide for communication.

On the remote host start this Docker container. Prebuilt image `marcel/nuclide-remote` available on Docker-Hub:

    sudo docker run -d -p 9090:9090 -p 9091:22 -v /home/test/hello-world:/hello-world marcel/nuclide-remote

On the local machine start Nuclide, select *Packages/Connect..* and enter the connection information:

- Username: `root`
- Server: `192.100.01.10`
- Initial Directory: `/hello-world`
- Password: `nuclide`
- SSH Port: `9091`
- Remote Server Command: `nuclide-start-server -p 9090`

After pressing ok the remote directory will show up in navigator and will be ready for editing.

