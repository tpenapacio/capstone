# CHT Superset 

CHT Superset ingests 2wt data in the form of a csv file and manipulates it to be display relevant statistics and aggregated patient information in a dashboard using Superset, an open-source data visualization framework. 

Additionally, we augment the data to include other informative information

# Organization 

1. superset
   
This repo is from https://github.com/apache/superset. Handles launching dashboard and creating visuals 

3. data
   
This repo contains all data used for visualization.
  a. 2wt_numeric.csv and 2wt_location.csv were created using data augmentation scripts
  b. all other data is real data collected by Caryl

5. code
   
This contains all code used to reformat and augment data

# Instructions

To view dashboard, navigate to superset directory and run 

'''
docker compose -f docker-compose-image-tag.yml up
'''

Then go to this link 

http://localhost:8088/superset/dashboard/11/

and enter with username: admin and password: admin
