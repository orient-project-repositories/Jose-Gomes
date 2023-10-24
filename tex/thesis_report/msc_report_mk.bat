@echo off

set file_main=msc_report

latex %file_main%
latex %file_main%
bibtex %file_main%
latex %file_main%
bibtex %file_main%
latex %file_main%

dvips %file_main%.dvi
ps2pdf %file_main%.ps %file_main%.pdf

pause
