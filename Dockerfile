ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/scipy-notebook:hub-3.1.1
FROM $BASE_CONTAINER

ENV TRANSFORMERS_CACHE=/tmp/.cache
ENV TOKENIZERS_PARALLELISM=true

LABEL maintainer="增加tf,pytorch,jax,transformers <lishuai061@126.com>"

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
# SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# USER root
# 换channel
RUN conda config --remove-key channels && \
    conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ && \
    conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/ && \
    conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/ && \
    conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/msys2/ && \
    conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/menpo/ && \
    conda config --add channels http://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/ && \
    conda config --set show_channel_urls yes && \
    conda config --set auto_activate_base false && \
    pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple && \
    conda clean --all -f -y

# USER ${NB_UID}
# Install Tensorflow,torch,jax,transformers
RUN mamba install --quiet --yes \
    'tensorflow-cpu' \
    'pytorch' \ 
    'torchvision' \
    'torchaudio' \
    'pytorch-lightning' \
    'jax' \
    'jaxlib' \
    'optax' \
    'transformers' \
    'datasets' \
    'nltk' \
    'gradio' \
    'sentencepiece' \
    'seqeval' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

USER ${NB_UID}

WORKDIR "${HOME}"