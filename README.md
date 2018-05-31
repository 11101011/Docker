Dockerfile for OpenFOAM-2.2.0 image with phaseFieldFoam
-------------------------------------------------------

Build and run the image with:

   docker build -t "nero235:openFOAM2xx" .

   docker run -ti nero235:openFOAM2xx /bin/bash


Make sure to edit GID and UID to match local user IDs (non-root) of the host running the container. 
Otherwise, you won't be able to share files between host and container through mounted volumes.
