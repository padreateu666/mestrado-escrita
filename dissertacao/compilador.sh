# Compilar o arquivo principal com pdflatex
pdflatex -shell-escape principal.tex

# Gerar a bibliografia com bibtex
bibtex principal

# Se você estiver usando nomenclaturas, gere o índice
makeindex principal.nlo -s nomencl.ist -o principal.nls

# Compilar novamente para incluir referências e o índice
pdflatex -shell-escape principal.tex
pdflatex -shell-escape principal.tex

# Abrir o PDF gerado (substitua 'atril' por seu visualizador de PDF preferido)
atril principal.pdf &

# Remover arquivos temporários gerados durante a compilação
rm -f *.aux *.bbl *.blg *.nlo *.nls *.lot *.lof *.toc *.out *.bak *.xml *.ilg *.log