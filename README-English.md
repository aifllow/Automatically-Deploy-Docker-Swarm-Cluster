Here is the translated README:

# Automatically-Deploy-Docker-Swarm-Cluster

# Docker Swarm Initialization Script

This Bash script is used to install Docker, initialize Docker Swarm, create an overlay network, and add worker nodes to the Swarm.

## Usage

You can run the script with the following parameters:

    ./script.sh <public IP address> <network name> [<Swarm port>] [<worker node IP address>...]

Parameter explanation:

  * `<public IP address>`: The public IP address used for Swarm.
  * `<network name>`: The name of the overlay network to create.
  * `<Swarm port>`: The port number of Swarm, this is an optional parameter, default is 2377.
  * `<worker node IP address>...`: The public IP address of the worker nodes to be added to the Swarm, this is an optional parameter, you can provide multiple.

## Script Description

The script mainly completes the following steps:

  1. Install Docker: The script will automatically detect the system type and try to install Docker. Supported system types include CentOS, Ubuntu, and Debian. If the system type is not among these, the script will prompt the user to manually install Docker.

  2. Verify IP address: The script will verify the validity of the provided public IP address and worker node IP address. If the IP address does not meet the format requirements or the value of each field is not between 0-255, the script will prompt an error.

  3. Initialize Docker Swarm: The script will initialize Docker Swarm using the provided public IP address and port number. If the initialization fails, the script will prompt an error.

  4. Create overlay network: The script will create a new overlay network, the network name is provided by the user. If creating the network fails, the script will prompt an error.

  5. Add worker nodes to Swarm: The script will add each worker node IP address provided to the Swarm. If adding the worker node fails, the script will prompt an error.

  6. Swarm token: The script will get the Swarm token and write it to a file for subsequent use. If obtaining the Swarm token fails, the script will prompt an error.

## Error Handling

The script contains an error handling function that can print error information and terminate script execution when an error is encountered.

## Precautions

  * Running the script requires administrative privileges, because installing Docker and operating Swarm both require administrative privileges.
  * If you encounter any problems while using the script, it is recommended to first check the network connection and the validity of the IP address.
  * When adding worker nodes to Swarm, please ensure that the worker nodes can access the public IP address and port number of Swarm.

Hope this script can help you manage and operate Docker Swarm more conveniently.
