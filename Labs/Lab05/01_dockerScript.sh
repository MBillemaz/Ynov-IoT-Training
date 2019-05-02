docker run -it -p 9090:9090 -p 1883:1883 -p 5683:5683/udp -v mytb-data:/data -v mytb-logs:/var/log/thingsboard --name mytb thingsboard/tb-postgres
