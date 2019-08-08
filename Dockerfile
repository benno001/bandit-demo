FROM python:3.7.4-buster

RUN useradd -ms /bin/bash bandit

USER bandit
WORKDIR /home/bandit

# Retrieve a vulnerable python sample and install requirements
RUN git clone https://github.com/portantier/vulpy
WORKDIR /home/bandit/vulpy
RUN pip install --user bandit==1.6.2 && pip install --user -r requirements.txt

# Add locally installed python packages to path
ENV PATH /usr/local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/bandit/.local/bin

# Initialise DB for both 'bad' and 'good'
WORKDIR /home/bandit/vulpy/good
RUN python db_init.py

WORKDIR /home/bandit/vulpy/bad
RUN python db_init.py

WORKDIR /home/bandit

ENTRYPOINT [ "/bin/bash" ]