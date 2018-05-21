(TeX-add-style-hook
 "SpatFrontier"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("scrartcl" "11pt" "parskip" "abstracton" "notitlepage")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("caption" "margin=10pt" "font=small" "labelfont=bf" "labelsep=endash") ("biblatex" "style=authoryear" "backend=bibtex" "natbib=true" "firstinits=true" "uniquename=true" "backref=false" "doi=false" "isbn=false" "url=false" "maxnames=2" "maxbibnames=10" "dashed=true") ("hyperref" "pdftex" "colorlinks=true" "citecolor=red" "urlcolor=magenta" "pdfstartview=FitH")))
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperref")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperimage")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "hyperbaseurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "nolinkurl")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "url")
   (add-to-list 'LaTeX-verbatim-macros-with-braces-local "path")
   (add-to-list 'LaTeX-verbatim-macros-with-delims-local "path")
   (TeX-run-style-hooks
    "latex2e"
    "scrartcl"
    "scrartcl11"
    "amssymb"
    "amsmath"
    "amsthm"
    "graphics"
    "graphicx"
    "longtable"
    "setspace"
    "makeidx"
    "subfig"
    "marvosym"
    "microtype"
    "booktabs"
    "tabularx"
    "authblk"
    "lipsum"
    "siunitx"
    "lmodern"
    "makecell"
    "rotating"
    "pdflscape"
    "fullpage"
    "dcolumn"
    "tikz"
    "animate"
    "extarrows"
    "pgf"
    "pgfplots"
    "relsize"
    "caption"
    "biblatex"
    "hyperref")
   (TeX-add-symbols
    "rm"
    "sf"
    "tt"
    "bf"
    "it"
    "sl"
    "sc"
    "onepc"
    "fivepc"
    "tenpc"
    "legend")
   (LaTeX-add-labels
    "fig:gdppc"
    "fig:isoquants"
    "sub:spf"
    "productionfrontier"
    "specification"
    "likelihood"
    "sub:unisn"
    "convolution"
    "conditioning"
    "eq:sn"
    "fig:sn"
    "SNunivariate"
    "eq:"
    "eq:centeredparameters"
    "sub:multisn"
    "stocstruc"
    "ll"
    "eq:fullomega"
    "eq:TE"
    "sec:Applications"
    "eq:CD"
    "tab:results"
    "fig:TEfrontierdiff"
    "tab:resultssectors"
    "fig:sectoralsfe")
   (LaTeX-add-environments
    "MYenumerate")
   (LaTeX-add-bibliographies
    "ref")
   (LaTeX-add-amsthm-newtheorems
    "proposition"
    "definition"
    "assumption"
    "lemma"))
 :latex)

