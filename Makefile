CONV=pandoc
PDFOPTS=-f markdown
HTMLOPTS=-f markdown -t html

NAME=resume

all: pdf html

pdf: ${NAME}.pdf

html: ${NAME}.html

${NAME}.pdf: ${NAME}.md
	${CONV} ${PDFOPTS} ${NAME}.md -o ${NAME}.pdf

${NAME}.html: ${NAME}.md
	${CONV} ${HTMLOPTS} ${NAME}.md -o ${NAME}.html
