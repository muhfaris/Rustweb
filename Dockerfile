FROM ubuntu
MAINTAINER muh faris " "
COPY sources.list /etc/apt/
RUN apt-get update && \
apt-get install \
curl \
git \
python \
ssh \
rustc \
cmake \
nodejs \
python2.7 \
default-jre \
-qqy \
&& curl https://sh.rustup.rs -sSf | sh -s -- -y 
ENV PATH=/root/.cargo/bin:$PATH

RUN rustup install stable \
&& rustup default stable \
&& rustup target add wasm32-unknown-emscripten

RUN curl https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz -O \
&& tar -xzf emsdk-portable.tar.gz \
&& rm emsdk-portable.tar.gz 

RUN cd /emsdk-portable
RUN ./emsdk-portable/emsdk update 
RUN ./emsdk-portable/emsdk install latest \
&& ./emsdk-portable/emsdk activate latest

#Adding directories to PATH:
ENV PATH=/emsdk-portable:/emsdk-portable/clang/e1.37.21_64bit:/emsdk-portable/node/4.1.1_64bit/bin:/emsdk-portable/emscripten/1.37.21:$PATH

#Setting environment variables:
ENV EMSDK=/emsdk-portable
ENv EM_CONFIG=/root/.emscripten
ENv BINARYEN_ROOT=/emsdk-portable/clang/e1.37.21_64bit/binaryen
ENv EMSCRIPTEN=/emsdk-portable/emscripten/1.37.21

#ENTRYPOINT ["emcc","-v"]
