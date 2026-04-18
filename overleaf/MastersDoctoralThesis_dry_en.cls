%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Masters/Doctoral Thesis 
% Class File
% Version 1.6 (27/8/17)
%
% This class was downloaded from:
% http://www.LaTeXTemplates.com
%
% Authors:
% Vel (vel@latextemplates.com)
% Johannes Böttcher
%
% Notes:
% 1) This class file defines the structure and layout of the template file (main.tex).
% 2) It has been written in such a way that under most circumstances you should not need
% to edit it; updating it to a newer version will be harder. If you do make changes, please change the name of
% the file and add comments to make your changes more visible.
%
% Class license:
% LPPL v1.3c (http://www.latex-project.org/lppl)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------------------------
%	CLASS DEFINITION AND PARAMETERS
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}[1996/12/01]
\newcommand{\classname}{MastersDoctoralThesis_dry_en}
\ProvidesClass{\classname}[2026/04/09 custom dry English thesis class]
\providecommand{\baseclass}{book}
\RequirePackage{etoolbox}
\RequirePackage{xparse}
\newbool{nolistspace}
\newbool{chapteroneline}
\newbool{listtoc}
\newbool{toctoc}
\newbool{parskip}
\newbool{hyperrefsupport}
\booltrue{hyperrefsupport}
\newbool{headsepline}
\newbool{consistentlayout}

\DeclareOption{nohyperref}{\boolfalse{hyperrefsupport}}
\DeclareOption{nolistspacing}{\booltrue{nolistspace}}
\DeclareOption{liststotoc}{\booltrue{listtoc}}
\DeclareOption{chapterinoneline}{\booltrue{chapteroneline}}
\DeclareOption{toctotoc}{\booltrue{toctoc}}
\DeclareOption{parskip}{\booltrue{parskip}}
\DeclareOption{headsepline}{\booltrue{headsepline}}
\DeclareOption{consistentlayout}{\booltrue{consistentlayout}}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\baseclass}}

\ProcessOptions\relax

\LoadClass{\baseclass}

%  Simple interface for the user  to customize the chapter titles 
\ProvideDocumentCommand{\abovechapterskip}{}{\vspace*{20pt}}
\ProvideDocumentCommand{\chapterbelowskip}{}{\vspace*{40pt}}
\ProvideDocumentCommand{\chapterinbetweenskip}{}{\vspace*{20pt}}
\ProvideDocumentCommand{\autodot}{}{}
\ProvideDocumentCommand{\mdtChapapp}{}{}
\ProvideDocumentCommand{\chapteralign}{}{\raggedright}
\ProvideDocumentCommand{\chapterfont}{}{\Huge\bfseries}
\ProvideDocumentCommand{\chapterprefixfont}{}{\LARGE\bfseries}
\DeclareDocumentCommand{\@makechapterhead}{ m }{%
	\abovechapterskip
	{\parindent \z@ \chapteralign \normalfont
		\interlinepenalty\@M%
		\ifnum \c@secnumdepth >\m@ne
		\if@mainmatter
			\chapterfont \thechapter\autodot\enspace #1\par\nobreak
		\else
			\chapterfont #1\par\nobreak
		\fi
		\else
			\chapterfont #1\par\nobreak
		\fi
		\chapterbelowskip
	}
	\thispagestyle{\chapter@p@gestyle}
}


% Addchap provides unnumbered chapters with an entry in the table of contents as well as an updated header
\ProvideDocumentCommand{\addchap}{ s o m }{%
	\chapter*{#3}%
	\markboth{}{}%
	\IfBooleanTF{#1}{%
	}{%
		\IfNoValueTF{#2}{%
			\addchaptertocentry{#3}%
			\markboth{\MakeMarkcase{#3}}{\MakeMarkcase{#3}}%
		}{%
			\addchaptertocentry{#2}%
			\markboth{\MakeMarkcase{#2}}{\MakeMarkcase{#2}}%
		}%
	}%
}%

\ProvideDocumentCommand{\addsec}{ s o m }{%
	\section*{#3}%
	\markright{}%
	\IfBooleanTF{#1}{%
	}{%
		\IfNoValueTF{#2}{%
			\addcontentsline{toc}{section}{#3}%
			\markright{\MakeMarkcase{#3}}%%
		}{%
			\addcontentsline{toc}{section}{#2}%
			\markright{\MakeMarkcase{#2}}%
		}%
	}%
}%

%----------------------------------------------------------------------------------------
%	CLASS OPTIONS
%----------------------------------------------------------------------------------------

\ifbool{parskip}{\RequirePackage{parskip}} % If the parskip option is passed to the class, require the parskip package 


\ifbool{listtoc}{% If the liststotoc option has been passed to the class, add the lists to the table of contents
	\patchcmd{\listoftables}{\@starttoc{lot}}{%
		\addchaptertocentry{\listtablename}\@starttoc{lot}%
	}{}{}%
	\patchcmd{\listoffigures}{\@starttoc{lof}}{%
		\addchaptertocentry{\listfigurename}\@starttoc{lof}%
	}{}{}%
}

\ifbool{toctoc}{% If the toctotoc options has been passed to the class, add the table of contents to the table of contents
	\patchcmd{\tableofcontents}{\@starttoc{toc}%
}{%
	\addchaptertocentry{\contentsname}\@starttoc{toc}}{}{}%
}

\patchcmd{\tableofcontents}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\tableofcontents}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoffigures}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoffigures}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoftables}{\MakeUppercase}{\MakeMarkcase}{}{}
\patchcmd{\listoftables}{\MakeUppercase}{\MakeMarkcase}{}{}

% If the option `nolistspacing' is given, the spacing in the different lists is reduced to single spacing. This option is only useful, if the spacing of the document has been changed to onehalfspacing or doublespacing.
\ifbool{nolistspace}{
	\patchcmd{\listoffigures}{%
		\@starttoc{lof}
	}{%
		\begingroup%
		\singlespace\@starttoc{lof}\endgroup%
	}{}{}%
	\patchcmd{\listoftables}{%
		\@starttoc{lot}
	}{%
		\begingroup%
		\singlespace\@starttoc{lot}\endgroup%
	}{}{}%
	\patchcmd{\tableofcontents}{%
		\@starttoc{toc}
	}{%
		\begingroup%
		\singlespace\@starttoc{toc}\endgroup%
	}{}{}%
}{}


%----------------------------------------------------------------------------------------
%	REQUIRED PACKAGES
%----------------------------------------------------------------------------------------



\RequirePackage[english]{babel} % Document language and automatic names in English

\RequirePackage{scrbase} % Necessário para lidar com nomes de seções/elementos do documento dependentes do idioma

\RequirePackage{scrhack} % Carrega correções para vários pacotes

\RequirePackage{setspace} % Necessário para alterar o espaçamento entre linhas

\RequirePackage{longtable} % Necessário para tabelas que se estendem por várias páginas (usado nas páginas de símbolos, abreviações e constantes físicas)

\RequirePackage{siunitx} % Necessário para os comandos \SI

\RequirePackage{graphicx} % Necessário para incluir imagens
\graphicspath{{Figures/}{./}} % Especifica onde procurar as imagens incluídas

\RequirePackage{booktabs} % Necessário para regras de tabela melhores

\RequirePackage{caption} % Necessário para personalizar as legendas
\captionsetup{justification=justified,font=small,labelfont=bf,margin=0pt,singlelinecheck=false}

%----------------------------------------------------------------------------------------
%	DEFINE CUSTOM THESIS INFORMATION COMMANDS
%----------------------------------------------------------------------------------------

\NewDocumentCommand{\thesistitle} { o m }{%
 \IfValueTF{#1}{\def\shorttitle{#1}}{\def\shorttitle{#2}}%
 \def\@title{#2}%
 \def\ttitle{#2}%
}
\DeclareDocumentCommand{\author}{m}{\newcommand{\authorname}{#1}\renewcommand{\@author}{#1}}
\NewDocumentCommand{\supervisor}{m}{\newcommand{\supname}{#1}}
\NewDocumentCommand{\examiner}{m}{\newcommand{\examname}{#1}}
\NewDocumentCommand{\degree}{m}{\newcommand{\degreename}{#1}}
\NewDocumentCommand{\addresses}{m}{\newcommand{\addressname}{#1}}
\NewDocumentCommand{\university}{m}{\newcommand{\univname}{#1}}
\NewDocumentCommand{\department}{m}{\newcommand{\deptname}{#1}}
\NewDocumentCommand{\group}{m}{\newcommand{\groupname}{#1}}
\NewDocumentCommand{\faculty}{m}{\newcommand{\facname}{#1}}
\NewDocumentCommand{\subject}{m}{\newcommand{\subjectname}{#1}}
\NewDocumentCommand{\keywords}{m}{\newcommand{\keywordnames}{#1}}

\newcommand{\checktoopen}{%
   \clearpage
   \ifdef{\phantomsection}{\phantomsection}{}%
}

\NewDocumentCommand{\bhrule}{}{\typeout{--------------------}}
\NewDocumentCommand{\tttypeout}{m}{\bhrule\typeout{\space #1}\bhrule}

\newcommand{\HRule}{\rule{.9\linewidth}{.6pt}} % Novo comando para fazer as linhas na página de título
\newcommand{\decoRule}{\rule{.8\textwidth}{.4pt}} % Novo comando para uma linha a ser usada sob figuras

\setcounter{tocdepth}{3} % A profundidade até a qual as seções do documento são impressas no sumário
\ProvideDocumentCommand{\addchaptertocentry}{ m }{%
	\addcontentsline{toc}{chapter}{#1}%
}

%----------------------------------------------------------------------------------------
%	CORES
%----------------------------------------------------------------------------------------

\usepackage[dvipsnames]{xcolor}
\usepackage{amssymb}
\usepackage{bm}       % Para símbolos matemáticos em negrito


%----------------------------------------------------------------------------------------
%	MARGENS
%----------------------------------------------------------------------------------------

\RequirePackage{geometry}
\geometry{
	headheight=4ex,
	includehead,
	includefoot
}

\raggedbottom

%----------------------------------------------------------------------------------------
%	PENALIDADES
%----------------------------------------------------------------------------------------

\doublehyphendemerits=10000 % Sem hífens consecutivos em linhas
\brokenpenalty=10000 % Sem palavras quebradas entre colunas/páginas
\widowpenalty=9999 % Quase sem viúvas no final da página
\clubpenalty=9999 % Quase sem órfãs no início da página
\interfootnotelinepenalty=9999 % Quase nunca quebrar notas de rodapé

%----------------------------------------------------------------------------------------
%	CABEÇALHOS E RODAPÉS
%----------------------------------------------------------------------------------------

\RequirePackage[markcase=used]{scrlayer-scrpage}
\providepairofpagestyles{thesisSimple}{%
	\clearpairofpagestyles%
	\automark[chapter]{chapter}
	\ihead{\headmark}% Cabeçalho interno
	\ohead[\pagemark]{\pagemark}% Cabeçalho externo
}
\ifoot{}% Rodapé interno
\ofoot{}% Rodapé externo
\pagestyle{thesisSimple}
\providepairofpagestyles[thesisSimple]{thesis}{%
	\automark*[section]{}%
}
\providepairofpagestyles[thesisSimple]{review}{%
	\ofoot[\shorttitle/\authorname]{\shorttitle/\authorname}
	\ifoot[\today]{\today}
}
\pagestyle{thesis}
\ifbool{headsepline}{\KOMAoption{headsepline}{true}}{}
\PreventPackageFromLoading[\ClassError{\classname}{Package `fancyhdr' is
incompatible\MessageBreak with this class}{The pagesyles are defined 
	using package `scrlayer-scrpage', please consult the\MessageBreak 
	KOMA-script documentation for details.}]{fancyhdr}


\newcommand{\blank@p@gestyle}{empty}
\newcommand{\chapter@p@gestyle}{plain}
\NewDocumentCommand{\blankpagestyle}{ m }{%
	\ClassWarning{\classname}{\string\blankpagestyle\space is
	obsolete,\MessageBreak use \string\setblankpagestyle \space  instead}\renewcommand{\blank@p@gestyle}{}{#1}
}
\NewDocumentCommand{\setblankpagestyle}{ m }{\renewcommand{\blank@p@gestyle}{#1}}
\NewDocumentCommand{\setchapterpagestyle}{ m }{\renewcommand{\chapter@p@gestyle}{#1}}

\DeclareDocumentCommand\cleardoublepage{}{\clearpage}



%----------------------------------------------------------------------------------------
%	PÁGINA DO RESUMO
%----------------------------------------------------------------------------------------

\DeclareDocumentCommand{\abstractauthorfont}{}{}
\DeclareDocumentCommand{\abstracttitlefont}{}{}
\newcommand{\abstractname}{Abstract}
\providecaptionname{american,australian,british,canadian,english,newzealand,UKenglish,USenglish}{\byname}{by}
\ifbool{consistentlayout}{
	\DeclareDocumentEnvironment{abstract}{ O{} }{%
		\addchap*{\abstractname}%
		{\chapteralign\normalsize\abstractauthorfont \authorname \par}% Nome do autor
		\vspace{\baselineskip}
		{\chapteralign\parbox{.7\linewidth}{\chapteralign\normalsize\itshape\abstracttitlefont\@title}\par}% Título da tese
		\bigskip\noindent\ignorespaces
	}%
	{}% fim do alt-resumo
}{%
	\DeclareDocumentEnvironment{abstract}{ O{\null\vfill} }{
		\checktoopen
		\tttypeout{\abstractname}
		#1% adicionado para permitir que o resumo tenha mais de uma página
		\thispagestyle{plain}
		\begin{center}
			{\normalsize \MakeUppercase{\univname} \par}% Nome da universidade em maiúsculas
			\bigskip
			{\huge\textit{\abstractname} \par}
			\bigskip
			{\normalsize\bfseries \@title \par}% Título da tese
			\medskip
			{\normalsize \byname{} \authorname \par}% Nome do autor
			\bigskip
		\end{center}
	}
	{
		\vfill\null
	}
}


%----------------------------------------------------------------------------------------
%	PÁGINA DE AGRADECIMENTOS
%----------------------------------------------------------------------------------------

\usepackage{xcolor}
\colorlet{mdtRed}{red!50!black}
\newcommand{\acknowledgementname}{Acknowledgements}
\providecaptionname{american,australian,british,canadian,english,newzealand,UKenglish,USenglish}{\acknowledgementname}{Acknowledgements}
\providecaptionname{german,ngerman,austrian,naustrian}{\acknowledgementname}{Danksagung}

\providecaptionname{brazil,brazilian,portuges,portuguese}{\acknowledgementname}{Acknowledgements}

\ifbool{consistentlayout}{
	\DeclareDocumentEnvironment{acknowledgements}{}{%
		\tttypeout{\acknowledgementname}
		\addchap*{\acknowledgementname}
	}
}
{
	\DeclareDocumentEnvironment{acknowledgements}{}{%
		\checktoopen
		\tttypeout{\acknowledgementname}
		\thispagestyle{plain}
		\begin{center}{\huge\textit{\acknowledgementname}\par}\end{center}
	}
	{
		\vfil\vfil\null
	}
}


%----------------------------------------------------------------------------------------
%	DEDICATÓRIA
%----------------------------------------------------------------------------------------

\ifbool{consistentlayout}{
	\DeclareDocumentCommand{\dedicatory}{
		m O{\vspace*{.7\textheight} }  }{
			\checktoopen\tttypeout{Dedicatória}
			\markboth{}{}
			#2
			{\hfill\parbox{.4\textwidth}{\flushright#1\par}}
		}
}{
	\newcommand\dedicatory[1]{
		\checktoopen
		\tttypeout{Dedicatória}
		\null\vfil
		\thispagestyle{plain}
		\begin{center}{\Large\slshape #1}\end{center}
		\vfil\null
	}
}



%----------------------------------------------------------------------------------------

\ifbool{hyperrefsupport}{% Se a opção nohyperref não foi especificada
\AtEndPreamble{\RequirePackage{hyperref}
\hypersetup{pdfpagemode={UseOutlines},
bookmarksopen=true,
bookmarksopenlevel=0,
hypertexnames=false,
colorlinks=true,% Defina como false para desativar a coloração dos links
citecolor=black,% A cor das citações
linkcolor=black,% A cor das referências a elementos do documento (seções, figuras, etc)
pdfstartview={FitV},
unicode,
breaklinks=true,
}

\pdfstringdefDisableCommands{% Se houver uma quebra de linha explícita em um título de seção (ou qualquer coisa impressa nos marcadores do pdf), ela é substituída por um espaço
	\let\\\space%
}
	}
}{% nada
}

%----------------------------------------------------------------------------------------
\AtBeginDocument{\setstretch{1.15}}
\AtBeginEnvironment{tabular}{\setstretch{1.1}}
\AtBeginEnvironment{longtable}{\setstretch{1.1}}
\captionsetup[figure]{belowskip=10pt}

%\pagecolor[rgb]{0.8,0.8,0.8} %grey


\endinput
% lazyLizardTracer
