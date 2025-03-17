FROM nvidia/cuda:12.8.1-cudnn-devel-ubuntu20.04

RUN  apt update && \
      DEBIAN_FRONTEND=noninteractive TZ=Asia/Shanghai \
      apt install -y tzdata openssh-server

RUN mkdir -p /var/run/sshd && \
      sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
      cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
      echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
      mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

RUN cd /root && wget -q https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh \
      && bash ./Anaconda3-2024.10-1-Linux-x86_64.sh -b -f -p /root/anaconda3 \
      && rm -f ./Anaconda3-2024.10-1-Linux-x86_64.sh \
      && echo "PATH=/root/anaconda3/bin:/usr/local/bin:$PATH" >> /etc/profile \
      && echo "source /etc/profile" >> /root/.bashrc \
      && echo "if [ -f /etc/autodl-motd ]; then source /etc/autodl-motd; fi" >> /root/.bashrc

RUN /root/anaconda3/bin/python -m pip install \
      torch torchvision torchaudio \
      --index-url https://download.pytorch.org/whl/cu118

RUN /root/anaconda3/bin/python -m pip install \
      vllm[audio] transformers moviepy librosa

RUN /root/anaconda3/bin/python -m pip install --no-cache-dir --upgrade \
      jupyterlab \
      ipywidgets \
      matplotlib \
      jupyterlab_language_pack_zh_CN
