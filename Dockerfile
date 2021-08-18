FROM ubuntu:18.04
# COPY node_modules /var/lib/node_modules
# RUN mkdir -p /var/lib
# WORKDIR /var/lib

# Install Node.js, Yarn and required dependencies
RUN apt-get update \
  && apt-get install -y curl gnupg build-essential \
  && curl --silent --location https://deb.nodesource.com/setup_15.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get remove -y --purge cmdtest \
  && apt-get update \
  && apt-get install -y nodejs yarn \
  # remove useless files from the current layer
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/apt/lists.d/* \
  && apt-get autoremove \
  && apt-get clean \
  && apt-get autoclean

RUN apt-get update \
  && apt-get install -y libglib2.0-0\
           libnss3\
           libnspr4\
           libatk1.0-0\
           libatk-bridge2.0-0\
           libcups2\
           libdbus-1-3\
           libxcb1\
           libdrm2\
           libxkbcommon0\
           libx11-6\
           libxcomposite1\
           libxdamage1\
           libxext6\
           libxfixes3\
           libxrandr2\
           libgbm1\
           libgtk-3-0\
           libpango-1.0-0\
           libcairo2\
           libgdk-pixbuf2.0-0\
           libasound2\
           libatspi2.0-0 \
           libxshmfence1 \
           libgles2 \
           xvfb \
           chromium-browser \
           chromium-chromedriver



COPY package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/
WORKDIR /opt/app

# Add our custom Chromium binary
ADD ./bin/custom-chromium /opt/app/custom-chromium
RUN chmod 755 /opt/app/custom-chromium

# Symlink the Chromium binary to `google-chrome` and `chromium-browser`
RUN ln -s /opt/app/custom-chromium /opt/app/google-chrome
RUN ln -s /opt/app/custom-chromium /opt/app/chromium-browser

# COPY . /opt/app
