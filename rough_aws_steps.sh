# Rough Steps for running the SNV caller comparison
# C. Savonen 2019 - CCDL for ALSF

# Step 0) Start an AWS instance

# Step 1) Log on to a running AWS instance with Ubuntu
ssh -i <FILE_PATH_TO>.pem ubuntu@<IP_ADDRESS>

# Step 2) Checkout the git for the OpenPBTA-analysis
git clone https://github.com/AlexsLemonade/OpenPBTA-analysis.git

# Step 3) Install Docker
sudo snap install docker

# Step 4) Give your instance permissions to use Docker
sudo chmod 666 /var/run/docker.sock

# Step 5) Pull your Docker image
docker pull ccdlopenpbta/open-pbta:latest

# Step 6) Download the data
cd OpenPBTA-analysis
bash download-data.sh

# Step 7) Run the container
docker run -it --rm --mount type=volume,dst=/home/rstudio/kitematic,volume-driver=local,volume-opt=type=none,volume-opt=o=bind,volume-opt=device=/home/ubuntu -e PASSWORD=eevee ccdlopenpbta/open-pbta:latest

# Step 8) Print the container ID
docker ps

# Step 9) Open up command line for container
docker exec -it <CONTAINER_ID> bash

# Step 10) Run the script with nohup so it doesn't need constant input
cd ../home/rstudio/kitematic/OpenPBTA-analysis
nohup sh analyses/snv-callers/run_caller_analysis.sh &

# Step 11) Zip up results
zip -r snv_consensus_results_10312019_v6.zip analyses/snv-callers/results/
zip -r snv_consensus_plots_10312019_v6.zip analyses/snv-callers/plots/

# Step 12) Copy results locally
scp -i <FILE_PATH_TO>.pem ubuntu@<IP_ADDRESS>:./OpenPBTA-analysis/snv_consensus_results_10312019_v6.zip ./
scp -i <FILE_PATH_TO>.pem ubuntu@<IP_ADDRESS>:./OpenPBTA-analysis/snv_consensus_plots_10312019_v6.zip ./
