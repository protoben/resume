CONV=pandoc
HTMLFLAGS=-f markdown -t html -c resume.css
PDFFLAGS=-f markdown --template=${LATEX_TEMPLATE} -H header.tex

PP=python resume.py
PPFLAGS=--no-gravatar

SRCS=resume.md
PDFS=${SRCS:.md=.pdf}
HTML=${SRCS:.md=.html}
LATEX_TEMPLATE=template.tex

DATE:=${shell date '+%d-%m-%Y %H:%m'}

all: pdf html
	git add ${PDFS} ${HTML}
	git commit -m "Remake pdf/html ${DATE}"
	git push

nopush: pdf html

pdf: ${PDFS}
html: ${HTML}

%.html: %.md
	${PP} html ${PPFLAGS} < $< | ${CONV} ${HTMLFLAGS} -o $@

%.pdf: %.md ${LATEX_TEMPLATE}
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
