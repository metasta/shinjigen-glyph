#!/bin/sh -

cat <<-'__EOL__'
	\documentclass[21pt]{jsarticle}
	\usepackage{ipamjm}
%	\usepackage{multicol}
	\parindent=0pt
	\newcommand{\Tx}[2]{\kern-1zw\hbox to 1zw{{\tiny\texttt{#1\hfill#2}}}}
	\newcommand{\Bx}[1]{\kern-1zw\hbox to 1zw{{\tiny\texttt{\hfill#1\hfill}}}}
	\newcommand{\TBOX}[2]{\raisebox{0.850zw}{\Tx{#1}{#2}}}
	\newcommand{\BBOX}[1]{\raisebox{-0.25zw}{\Bx{#1}}}
	\newcommand{\mjglyph}[3]{\MJMZM{#2}\TBOX{#3}{#1}\BBOX{MJ#2}}
	\newcommand{\noglyph}[2]{■\TBOX{#2}{#1}}
	\newenvironment{dl}{\scriptsize\begin{list}{}{}}{\end{list}}
	\newcommand{\li}[2]{\item #1 \hspace{0.5em} #2}
	\begin{document}
%	\begin{multicols}{2}
	__EOL__

awk -F '	' '
 BEGIN {
  init_buf = "\\begin{dl}\n"
  text_buf = init_buf
  parent_prev = "0"
 }
 {
  if($5 != parent_prev){ text_buf = output_buf(text_buf) }
  output_kanji($1, $2, $6)
  text_buf = append_buf(text_buf, $1, $7)
  parent_prev = $5
 }
 END {
  output_buf(text_buf)
 }
 function append_buf(buf, no, text){
  if(text != ""){
   gsub("_","\\_", text)
   return buf"\\li{"no"}{"text"}\n"
  }
  return buf
 }
 function output_buf(buf){
  if(buf != init_buf){ print buf"\\end{dl}" }
  print ""
  return init_buf
 }
 function output_kanji(no, mj, type){
  if(match(mj, /[0-9]+/)){
   glyph = "\\mjglyph{"no"}{"substr(mj, RSTART, RLENGTH)"}{"type"}"
  } else {
   glyph = "\\noglyph{"no"}{"type"}"
  }
  if(type == "親字" || type == "新字"){
   gsub(type,"",glyph)
   print "{\\Huge【"glyph"】}"
  } else {
   print "{\\Huge"glyph"}"
  }
 }'

cat <<-'__EOL__'
%	\end{multicols}
	\end{document}
	__EOL__
