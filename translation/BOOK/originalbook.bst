%% originalbook.bst
%%
%% A deliberately small BibTeX style for this translation.  Each database
%% record carries two project-specific fields:
%%
%%   natbiblabel = {Author(year)}
%%   fulltext    = {The complete, approved English reference text.}
%%
%% The explicit, zero-padded sortorder field is the sole sort key.  It keeps
%% the approved order stable even when \nocite{*} occurs after body citations.

ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    fulltext
    howpublished
    institution
    journal
    key
    month
    natbiblabel
    note
    number
    organization
    pages
    publisher
    school
    series
    sortorder
    title
    type
    volume
    year
  }
  {}
  {}

INTEGERS { nameptr namesleft numnames }
STRINGS  { s t fallback.text }

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{ff~}{vv~}{ll}{, jj}" format.name$ 't :=
      nameptr #1 >
        { namesleft #1 >
            { ", " * t * }
            { numnames #2 >
                { "," * }
                'skip$
              if$
              t "others" =
                { " et~al." * }
                { " and " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

%% Append a nonempty value to the emergency, field-based fallback text.
FUNCTION {append.fallback}
{ 't :=
  t empty$
    { skip$ }
    { fallback.text empty$
        { t 'fallback.text := }
        { fallback.text ". " * t * 'fallback.text := }
      if$
    }
  if$
}

FUNCTION {fallback.label}
{ year empty$
    { cite$ "(n.d.)" * }
    { cite$ "(" * year * ")" * }
  if$
}

FUNCTION {get.natbib.label}
{ natbiblabel empty$
    { "empty natbiblabel in " cite$ *
      "; using citation key as the author label" * warning$
      fallback.label
    }
    { natbiblabel }
  if$
}

%% This path is only a safety net.  Approved records should always use the
%% fulltext field, whose contents are written without case or punctuation
%% changes.
FUNCTION {fallback.fulltext}
{ author empty$
    { editor empty$
        { cite$ 'fallback.text := }
        { editor format.names 'fallback.text := }
      if$
    }
    { author format.names 'fallback.text := }
  if$
  title empty$
    { skip$ }
    { title append.fallback }
  if$
  journal empty$
    { booktitle empty$
        { skip$ }
        { booktitle append.fallback }
      if$
    }
    { journal append.fallback }
  if$
  series empty$
    { skip$ }
    { series append.fallback }
  if$
  volume empty$
    { skip$ }
    { "vol.~" volume * append.fallback }
  if$
  number empty$
    { skip$ }
    { "no.~" number * append.fallback }
  if$
  publisher empty$
    { institution empty$
        { school empty$
            { organization empty$
                { howpublished empty$
                    { skip$ }
                    { howpublished append.fallback }
                  if$
                }
                { organization append.fallback }
              if$
            }
            { school append.fallback }
          if$
        }
        { institution append.fallback }
      if$
    }
    { publisher append.fallback }
  if$
  address empty$
    { skip$ }
    { address append.fallback }
  if$
  edition empty$
    { skip$ }
    { edition " edition" * append.fallback }
  if$
  chapter empty$
    { skip$ }
    { "chapter " chapter * append.fallback }
  if$
  pages empty$
    { skip$ }
    { "pp.~" pages * append.fallback }
  if$
  month empty$
    { skip$ }
    { month append.fallback }
  if$
  year empty$
    { skip$ }
    { year append.fallback }
  if$
  note empty$
    { skip$ }
    { note append.fallback }
  if$
  fallback.text add.period$
}

FUNCTION {get.fulltext}
{ fulltext empty$
    { "empty fulltext in " cite$ *
      "; constructing a fallback from standard BibTeX fields" * warning$
      fallback.fulltext
    }
    { fulltext }
  if$
}

FUNCTION {output.record}
{ newline$
  "\bibitem[" write$
  get.natbib.label write$
  "]{" write$
  cite$ write$
  "}" write$
  newline$
  get.fulltext write$
  newline$
  newline$
}

FUNCTION {article}       { output.record }
FUNCTION {book}          { output.record }
FUNCTION {booklet}       { output.record }
FUNCTION {conference}    { output.record }
FUNCTION {inbook}        { output.record }
FUNCTION {incollection}  { output.record }
FUNCTION {inproceedings} { output.record }
FUNCTION {manual}        { output.record }
FUNCTION {mastersthesis} { output.record }
FUNCTION {misc}          { output.record }
FUNCTION {phdthesis}     { output.record }
FUNCTION {proceedings}   { output.record }
FUNCTION {techreport}    { output.record }
FUNCTION {unpublished}   { output.record }
FUNCTION {default.type}  { output.record }

READ

FUNCTION {presort}
{ sortorder empty$
    { "empty sortorder in " cite$ *
      "; using the citation key as a fallback sort key" * warning$
      cite$ 'sort.key$ :=
    }
    { sortorder 'sort.key$ := }
  if$
}

ITERATE {presort}
SORT

FUNCTION {begin.bib}
{ preamble$ empty$
    { skip$ }
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{99}" write$ newline$
  "\providecommand{\natexlab}[1]{#1}" write$ newline$
  newline$
}

FUNCTION {end.bib}
{ "\end{thebibliography}" write$ newline$ }

EXECUTE {begin.bib}
ITERATE {call.type$}
EXECUTE {end.bib}
