FROM python:3.9.7-buster AS base

RUN apt-get update && apt-get -y upgrade \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install cloudpickle \
                 keras \
                 paho-mqtt \
                 tensorflow

# install pytorch
FROM base AS cpu
RUN pip3 install torch==1.9.1+cpu \
                 torchvision==0.10.1+cpu \
		 torchaudio==0.9.1 \
		 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install monai

FROM base AS gpu
RUN pip3 install torch==1.9.1+cu111 \
                 torchvision==0.10.1+cu111 \
		 torchaudio==0.9.1 \
		 -f https://download.pytorch.org/whl/torch_stable.html
RUN pip3 install monai
