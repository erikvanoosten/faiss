FROM nvidia/cuda:8.0-devel-ubuntu16.04
MAINTAINER Pierre Letessier <pletessier@ina.fr>

RUN apt-get update -y
RUN apt-get install -y libopenblas-dev python3-dev swig git python3-pip wget

RUN pip3 install matplotlib numpy

COPY . /opt/faiss

WORKDIR /opt/faiss

ENV BLASLDFLAGS /usr/lib/libopenblas.so.0

RUN mv example_makefiles/makefile.inc.Linux.py3 ./makefile.inc

RUN make tests/test_blas -j $(nproc) && \
    make -j $(nproc) && \
    make tests/demo_sift1M -j $(nproc)

RUN make py

RUN cd gpu && \
    make -j $(nproc) && \
    make test/demo_ivfpq_indexing_gpu && \
    make py

# RUN ./tests/test_blas && \
#     tests/demo_ivfpq_indexing


# RUN wget ftp://ftp.irisa.fr/local/texmex/corpus/sift.tar.gz && \
#     tar xf sift.tar.gz && \
#     mv sift sift1M

# RUN tests/demo_sift1M
