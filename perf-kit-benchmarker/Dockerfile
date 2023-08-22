FROM ubuntu
RUN apt-get update && apt-get install -y python3-pip python3-dev git
RUN git clone https://github.com/GoogleCloudPlatform/PerfKitBenchmarker
WORKDIR /PerfKitBenchmarker
RUN pip3 install -r /PerfKitBenchmarker/requirements.txt
