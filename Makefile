CONV=pandoc
HTMLFLAGS=-f markdown -t html -c resume.css
PDFFLAGS=-f markdown --template=${LATEX_TEMPLATE} -H header.tex

PP=python resume.py
PPFLAGS=--no-gravatar

CHMOD=chmod 644

SRCS=resume.md
PDFS=${SRCS:.md=.pdf}
HTML=${SRCS:.md=.html}
LATEX_TEMPLATE=template.tex

all: pdf html
pdf: ${PDFS}
html: ${HTML}

%.html: %.md
	${PP} html ${PPFLAGS} < $< | ${CONV} ${HTMLFLAGS} -o $@
	${CHMOD} $@

%.pdf: %.md ${LATEX_TEMPLATE}
	${PP} tex ${PPFLAGS} < $< | ${CONV} ${PDFFLAGS} -o $@
	${CHMOD} $@

ifeq (${OS},Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix
  RM = rm -f
endif

clean:
	${RM} ${HTML} ${PDFS}
