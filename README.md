# nuclide-remote
Nuclide-remote in a Docker container enables remote editing using Nuclide. 
Further documentation can be found at:
http://nuclide.io/docs/remote/

## Running

Communication between Nuclide and Nuclide-remote happens over 2 ports:
- ssh/23: needed to start nuclide remote inside Docker container
- 9090: Nuclide communication channel

### Example

Lets set up access to a project at `/home/test/hello-world` on a remote host on `192.100.01.10`.
We run ssh over port 9091 and use 9090 for communication.

On remote host start Docker container:

    sudo docker run -d -p 9090:9090 -p 9091:22 -v /home/test/hello-world:/hello-world marcel/nuclide-remote

On the local machine start Nuclide and select *Packages/Connect..* and enter connection information:

- Username: *root*
- Server: *192.100.01.10*
- Initial Directory: */hello-world*
- Password: *nuclide*
- SSH Port: *9091*
- Remote Server Command: *nuclide-start-server -p 9090*

After pressing ok the remote directory will show up in navigator and will be ready for editing.

