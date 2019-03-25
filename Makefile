CONV=pandoc
HTMLFLAGS=-f markdown -t html -c resume.css
PDFFLAGS=-f markdown --template=${LATEX_TEMPLATE} -H ${LATEX_HEADER} \
	 -V colorlinks=true -V linkcolor=magenta

PP=python2 resume.py
PPFLAGS=--no-gravatar

SRCS=resume.md cv.md
PDFS=${SRCS:.md=.pdf}
HTML=${SRCS:.md=.html}
LATEX_TEMPLATE=template.tex
LATEX_HEADER=header.tex

DATE:=${shell date '+%d-%m-%Y %H:%m'}

USER=hamlinb
HOST=ada.cs.pdx.edu
DIR=/home/hamlinb/solaris/public_html

all: pdf html push upload

push: ${SRCS}
	-git add ${SRCS}
	-git commit -m "Contents updated ${DATE}" && git push

upload: pdf html
	scp resume.html resume.css resume.pdf cv.html cv.css cv.pdf ${USER}@${HOST}:${DIR}/
	ssh ${USER}@${HOST} chmod 644 ${DIR}/resume.* ${DIR}/cv.*

nopush: pdf html

pdf: ${PDFS}
html: ${HTML}

%.html: %.md
	${PP} html ${PPFLAGS} < $< | ${CONV} ${HTMLFLAGS} -o $@

%.pdf: %.md ${LATEX_TEMPLATE} ${LATEX_HEADER}
	${PP} tex ${PPFLAGS} < $< | ${CONV} ${PDFFLAGS} -o $@

ifeq (${OS},Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix
  RM = rm -f
endif

clean:
	${RM} ${HTML} ${PDFS}
