# 24nov16abu
# (c) Software Lab. Alexander Burger

# *JS "*JS" *Style *Menu *Tab *ID

(mapc allow '(*JS *Menu *Tab *ID "!ping"))
(setq *Menu 0  *Tab 1)
(off "*JS")

(de htPrin (Prg Ofs)
   (default Ofs 1)
   (for X Prg
      (if (atom X)
         (ht:Prin (eval X Ofs))
         (eval X Ofs) ) ) )

(de htJs ()
   (for X "*JS"
      (prin " " (car X) "=\"")
      (ht:Prin (cdr X))
      (prin "\"") ) )

(de htStyle (Attr)
   (cond
      ((atom Attr)
         (prin " class=\"")
         (ht:Prin Attr)
         (prin "\"") )
      ((and (atom (car Attr)) (atom (cdr Attr)))
         (prin " " (car Attr) "=\"")
         (ht:Prin (cdr Attr))
         (prin "\"") )
      (T (mapc htStyle Attr)) ) )

(de dfltCss (Cls)
   (htStyle
      (cond
         ((not *Style) Cls)
         ((atom *Style) (pack *Style " " Cls))
         ((and (atom (car *Style)) (atom (cdr *Style)))
            (list Cls *Style) )
         ((find atom *Style)
            (replace *Style @ (pack @ " " Cls)) )
         (T (cons Cls *Style)) ) ) )

(de tag (Nm Attr Ofs Prg)
   (prin "<" Nm)
   (and Attr (htStyle @))
   (prin ">")
   (if (atom Prg)
      (ht:Prin (eval Prg Ofs))
      (for X Prg
         (if (atom X)
            (ht:Prin (eval X Ofs))
            (eval X Ofs) ) ) )
   (prin "</" Nm ">") )

(de <tag> (Nm Attr . Prg)
   (tag Nm Attr 2 Prg) )

(de <js> ("JS" . "Prg")
   (let "*JS" (append "*JS" "JS")
      (run "Prg") ) )

(de style (X S)
   (nond
      (X S)
      (S X)
      ((pair X)
         (cond
            ((atom S) (pack S " " X))
            ((and (atom (car S)) (atom (cdr S)))
               (list X S) )
            ((find atom S)
               (replace S @ (pack @ " " X)) )
            (T (cons X S)) ) )
      ((or (pair (car X)) (pair (cdr X)))
         (cond
            ((atom S) (list S X))
            ((and (atom (car S)) (atom (cdr S)))
               (if (= (car X) (car S))
                  X
                  (list S X) ) )
            (T
               (cons X (delete (assoc (car X) S) S)) ) ) )
      (NIL
         (for Y X
            (setq S (style Y S)) ) ) ) )

(de <style> ("X" . "Prg")
   (let *Style (style "X" *Style)
      (run "Prg") ) )

(de nonblank (Str)
   (or Str `(pack (char 160) (char 160))) )

### XHTML output ###
(de html (Upd Ttl Css Attr . Prg)
   (httpHead NIL Upd)
   (ht:Out *Chunked
      (prinl "<!DOCTYPE html>")
      (prinl "<html lang=\"" (or *Lang "en") "\">")
      (prinl "<head>")
      (prinl "<meta name=\"viewport\" content=\"width=device-width\"/>")
      (and (fin Ttl) (<tag> 'title NIL @) (prinl))
      (mapc prinl Ttl)
      (and *Host *Port (prinl "<base href=\"" (baseHRef) "\"/>"))
      (when Css
         (if (atom Css)
            ("css" Css)
            (mapc "css" Css)
            (when (fin Css)
               (prinl "<style type=\"text/css\">")
               (prinl @)
               (prinl "</style>") ) ) )
      (and *SesId (javascript NIL "SesId=\"" @ "\""))
      (mapc javascript *JS)
      (when (=0 Upd)
         (javascript NIL
            "document.addEventListener('visibilitychange', function() {if (!document.hidden) window.location.replace(location.href)})" ) )
      (prinl "</head>")
      (tag 'body Attr 2 Prg)
      (prinl "</html>") ) )

(de "css" (Css)
   (prinl "<link rel=\"stylesheet\" type=\"text/css\" href=\"" (srcUrl Css) "\"/>") )

(de javascript (JS . @)
   (when *JS
      (when JS
         (prinl "<script type=\"text/javascript\" src=\"" (srcUrl JS) "\"></script>") )
      (when (rest)
         (prinl "<script type=\"text/javascript\">" @ "</script>") ) ) )

(de ping (Min)
   (timeout (setq *Timeout (* Min `(* 60 1000))))
   (respond) )

(de <ping> (Min)
   (javascript NIL "onload=ping(" Min ")") )

(de <div> (Attr . Prg)
   (tag 'div Attr 2 Prg)
   (prinl) )

(de <span> (Attr . Prg)
   (tag 'span Attr 2 Prg) )

(de <br> Prg
   (htPrin Prg 2)
   (prinl "<br/>") )

(de -- ()
   (prinl "<br/>") )

(de ---- ()
   (prinl "<br/><br/>") )

(de <hr> ()
   (prinl "<hr/>") )

(de <nbsp> (N)
   (do (or N 1) (prin "&nbsp;")) )

(de <small> Prg
   (tag 'small NIL 2 Prg) )

(de <big> Prg
   (tag 'big NIL 2 Prg) )

(de <em> Prg
   (tag 'em NIL 2 Prg) )

(de <strong> Prg
   (tag 'strong NIL 2 Prg) )

(de <h1> (Attr . Prg)
   (tag 'h1 Attr 2 Prg)
   (prinl) )

(de <h2> (Attr . Prg)
   (tag 'h2 Attr 2 Prg)
   (prinl) )

(de <h3> (Attr . Prg)
   (tag 'h3 Attr 2 Prg)
   (prinl) )

(de <h4> (Attr . Prg)
   (tag 'h4 Attr 2 Prg)
   (prinl) )

(de <h5> (Attr . Prg)
   (tag 'h5 Attr 2 Prg)
   (prinl) )

(de <h6> (Attr . Prg)
   (tag 'h6 Attr 2 Prg)
   (prinl) )

(de <p> (Attr . Prg)
   (tag 'p Attr 2 Prg)
   (prinl) )

(de <pre> (Attr . Prg)
   (tag 'pre Attr 2 Prg)
   (prinl) )

(de <ol> (Attr . Prg)
   (tag 'ol Attr 2 Prg)
   (prinl) )

(de <ul> (Attr . Prg)
   (tag 'ul Attr 2 Prg)
   (prinl) )

(de <li> (Attr . Prg)
   (tag 'li Attr 2 Prg)
   (prinl) )

(de <href> (Str Url Tar)
   (prin "<a href=\""
      (sesId
         (ifn (pre? "+" Url)
            Url
            (setq Tar "_blank")
            (pack (cdr (chop Url))) ) )
      "\"" )
   (and Tar (prin " target=\"" Tar "\""))
   (and *Style (htStyle @))
   (prin ">")
   (ht:Prin Str)
   (prin "</a>") )

(de <img> (Src Alt Url DX DY)
   (when Url
      (prin "<a href=\""
         (sesId
            (ifn (pre? "+" Url)
               Url
               (pack (cdr (chop Url)) "\" target=\"_blank") ) )
         "\">" ) )
   (prin "<img src=\"" (sesId Src) "\"")
   (when Alt
      (prin " alt=\"")
      (ht:Prin Alt)
      (prin "\"") )
   (and DX (prin " width=\"" DX "\""))
   (and DY (prin " height=\"" DY "\""))
   (and *Style (htStyle @))
   (prin "/>")
   (and Url (prin "</a>")) )

(de <this> (Var Val . Prg)
   (prin "<a href=\""
      (urlMT (sesId *Url) *Menu *Tab *ID
         (pack "&" Var "=" (ht:Fmt Val) "\"") ) )
   (and *Style (htStyle @))
   (prin ">")
   (htPrin Prg 2)
   (prin "</a>") )

(de <table> (Attr Ttl "Head" . Prg)
   (tag 'table Attr 1
      (quote
         (and Ttl (tag 'caption NIL 1 Ttl))
         (when (find cdr "Head")
            (tag 'tr NIL 1
               (quote
                  (for X "Head"
                     (tag 'th (car X) 2 (cdr X)) ) ) ) )
         (htPrin Prg 2) ) )
   (prinl) )

(de <row> (Attr . Prg)
   (tag 'tr NIL 1
      (quote
         (let (L Prg  H (up "Head"))
            (while L
               (let (X (++ L)  A (car (++ H))  N 1)
                  (while (== '- (car L))
                     (inc 'N)
                     (++ L)
                     (++ H) )
                  (tag 'td
                     (style Attr
                        (style
                           (and (> N 1) (cons "colspan" N))
                           (if (== 'align A) '(align (align . right)) A) ) )
                     1
                     (quote
                        (if (atom X)
                           (ht:Prin (eval X 1))
                           (eval X 1) ) ) ) ) ) ) ) ) )

(de <th> (Attr . Prg)
   (tag 'th Attr 2 Prg) )

(de <tr> (Attr . Prg)
   (tag 'tr Attr 2 Prg) )

(de <td> (Attr . Prg)
   (tag 'td Attr 2 Prg) )

(de <grid> (X . Lst)
   (tag 'table 'grid 1
      (quote
         (while Lst
            (tag 'tr NIL 1
               (quote
                  (use X
                     (let L (and (sym? X) (chop X))
                        (do (or (num? X) (length X))
                           (let
                              (C
                                 (cond
                                    ((pair X) (++ X))
                                    ((= "." (++ L)) 'align) )
                                 E (++ Lst) )
                              (unless (== '- E)
                                 (when (== '- (car Lst))
                                    (let N 1
                                       (for (P Lst (and P (== '- (++ P))))
                                          (inc 'N) )
                                       (push 'N "colspan")
                                       (setq C (if C (list C N) N)) ) )
                                 (tag 'td C 1
                                    (quote
                                       (if (atom E)
                                          (ht:Prin (eval E 1))
                                          (eval E 1) ) ) ) ) ) ) ) ) ) ) ) ) )
   (prinl) )

(de <trident> Lst
   (<table> '(width . "100%") NIL NIL
      (<tr> NIL
         (<td> '((width . "33%") (align . left))
            (eval (car Lst) 1) )
         (<td> '((width . "34%") (align . center))
            (eval (cadr Lst) 1) )
         (<td> '((width . "33%") (align . right))
            (eval (caddr Lst) 1) ) ) ) )

(de <spread> Lst
   (<table> '(width . "100%") NIL '((norm) (align))
      (<row> NIL
         (eval (car Lst) 1)
         (run (cdr Lst) 1) ) ) )

(de tip ("X" "Txt")
   (<span> (cons 'title (glue "^J" "X")) "Txt") )

(de <tip> ("X" . "Prg")
   (let *Style (style (cons 'title (glue "^J" "X")) *Style)
      (run "Prg") ) )

# Layout
(zero "LayX" "LayY")

(de <layout> "Lst"
   (let P (and (=T (car "Lst")) (++ "Lst"))
      (recur ("Lst" "LayX")
         (use "LayY"
            (for "L" "Lst"
               (let
                  ("Args" (mapcar eval (cddar "L"))
                     "DX" (eval (caar "L"))
                     "DY" (eval (cadar "L"))
                     "Cls" (unless (sub? ":" (car "Args")) (++ "Args"))
                     "Style"
                     (cons 'style
                        (glue "; "
                           (cons
                              "position:absolute"
                              (pack "top:" "LayY" (if P "%" "px"))
                              (pack "left:" "LayX" (if P "%" "px"))
                              (cond
                                 ((=0 "DX") "min-width:100%")
                                 ("DX" (pack "width:" "DX" (if P "%" "px"))) )
                              (cond
                                 ((=0 "DY") "min-height:100%")
                                 ("DY" (pack "height:" "DY" (if P "%" "px"))) )
                              "Args" ) ) ) )
                  (prog1
                     (if "Cls" (list "Cls" "Style") "Style")  # -> '@'
                     (eval (cadr "L")) )
                  (recurse (cddr "L") (+ "LayX" "DX"))
                  (inc '"LayY" "DY") ) ) ) ) ) )

(de <button> (Url Str)
   (<div> "button"
      (prin "<a href=\"" (sesId Url) "\"")
      (and *Style (htStyle @))
      (prin ">")
      (<span> "button2" Str)
      (prin "</a>") ) )

# Menus
(de urlMT (Url Menu Tab Id Str)
   (pack Url "?"  "*Menu=+" Menu  "&*Tab=+" Tab  "&*ID=" (ht:Fmt Id) Str) )

(de <menu> Lst
   (let (M 1  N 1  E 2  U)
      (recur (Lst N E)
         (<ul> NIL
            (for L Lst
               (nond
                  ((car L) (<li> NIL (htPrin (cdr L) 2)))
                  ((=T (car L))
                     (nond
                        ((setq U (eval (cadr L) E))
                           (<li> (pack 'cmd N)
                              (ht:Prin (eval (car L) E)) ) )
                        ((pair U)
                           (<li> (pack (if (= U *Url) 'act 'cmd) N)
                              (<tip> "-->"
                                 (<href> (eval (car L) E)
                                    (urlMT U *Menu (if (= U *Url) *Tab 1)
                                       (eval (caddr L))
                                       (eval (cadddr L)) ) ) ) ) )
                        (NIL
                           (<href> (eval (car L) E) (car U) (cdr U)) ) ) )
                  ((bit? M *Menu)
                     (<li> (pack 'sub N)
                        (<tip> ,"Open submenu"
                           (<href>
                              (eval (cadr L) E)
                              (urlMT *Url (| M *Menu) *Tab *ID) ) ) )
                     (setq M (>> -1 M))
                     (recur (L)
                        (for X (cddr L)
                           (when (=T (car X))
                              (recurse X)
                              (setq M (>> -1 M)) ) ) ) )
                  (NIL
                     (<li> (pack 'top N)
                        (<tip> ,"Close submenu"
                           (<href>
                              (eval (cadr L) E)
                              (urlMT *Url (x| M *Menu) *Tab *ID) ) )
                        (setq M (>> -1 M))
                        (recurse (cddr L) (inc N) (inc E)) ) ) ) ) ) ) ) )

(de <bar> Lst
   (use U
      (<ul> NIL
         (for (I . M) Lst
            (if (= I *Menu)
               (<li> "top"
                  (<href>
                     (eval (car M) 1)
                     (urlMT *Url 0 *Tab *ID) )
                  (<ul> NIL
                     (for L (cdr M)
                        (if (setq U (eval (cadr L) 1))
                           (<li> (if (= U *Url) "act" "cmd")
                              (<href> (eval (car L) 1)
                                 (urlMT U 0 (if (= U *Url) *Tab 1)
                                    (eval (caddr L))
                                    (eval (cadddr L)) ) ) )
                           (<li> "cmd"
                              (ht:Prin (eval (car L) 1)) ) ) ) ) )
               (<li> "sub"
                  (<href>
                     (eval (car M) 1)
                     (urlMT *Url I *Tab *ID) ) ) ) ) ) ) )

(de bar? (Attr)
   (ifn (and *JS (gt0 *Menu))
      Attr
      (cons
         (cons
            "onclick"
            (pack "if (!Btn.length) window.location.href='" (urlMT (sesId *Url) 0 *Tab *ID) "'") )
         (if (pair (cdr Attr)) Attr (cons Attr)) ) ) )

# Update link
(de updLink ()
   (<tip> ,"Update"
      (<span> 'step (<href> "@" (urlMT *Url *Menu *Tab *ID))) ) )

# Tabs
(de <tab> Lst
   (<table> 'tab NIL NIL
      (for (N . L) Lst
         (if (= N *Tab)
            (<td> 'top (ht:Prin (eval (car L) 1)))
            (<td> 'sub
               (<href> (eval (car L) 1) (urlMT *Url *Menu N *ID)) ) ) ) )
   (htPrin (get Lst *Tab -1) 2) )

### DB Linkage ###
(de mkUrl (Lst)
   (pack (++ Lst) "?"
      (make
         (while Lst
            (and
               (sym? (car Lst))
               (= `(char '*) (char (car Lst)))
               (link (++ Lst) "=") )
            (link (ht:Fmt (++ Lst)))
            (and Lst (link "&")) ) ) ) )

(de <$> (Str Obj Msg Tab)
   (cond
      ((not Obj) (ht:Prin Str))
      ((=T Obj) (<href> Str (pack Msg Str)))
      ((send (or Msg 'url>) Obj (or Tab 1))
         (<href> Str (mkUrl @)) )
      (T (ht:Prin Str)) ) )

# Links to previous and next object
(de stepBtn (Var Cls Hook Msg)
   (default Msg 'url>)
   (<span> 'step
      (use (Rel S1 S2)
         (if (isa '+Joint (setq Rel (meta *ID Var)))
            (let Lst (get *ID Var (; Rel slot))
               (setq
                  S2 (lit (cadr (memq *ID Lst)))
                  S1 (lit (car (seek '((L) (== *ID (cadr L))) Lst))) ) )
            (let
               (K
                  (cond
                     ((isa '+Key Rel)
                        (get *ID Var) )
                     ((isa '+Fold Rel)
                        (cons (fold (get *ID Var)) *ID) )
                     (T
                        (cons
                           (get *ID Var)
                           (conc
                              (mapcar '((S) (get *ID S)) (; Rel aux))
                              *ID ) ) ) )
                  Q1 (init (tree Var Cls Hook) K NIL)
                  Q2 (init (tree Var Cls Hook) K T) )
               (unless (get *ID T)
                  (step Q1 T)
                  (step Q2 T) )
               (setq
                  S1 (list 'step (lit Q1) T)
                  S2 (list 'step (lit Q2) T) ) ) )
         (if (and (eval S1) (send Msg @ *Tab))
            (<tip> ,"Next object of the same type"
               (<href> "<<<" (mkUrl @)) )
            (prin "&lt;&lt;&lt;") )
         (prin "&nbsp;--&nbsp;")
         (if (and (eval S2) (send Msg @ *Tab))
            (<tip> ,"Next object of the same type"
               (<href> ">>>" (mkUrl @)) )
            (prin "&gt;&gt;&gt;") ) ) ) )

# Character Separated Values
(off "*CSV")

(de csv ("Nm" . "Prg")
   (call "rm" "-f" (tmp "Nm" ".csv"))
   (let "*CSV" (pack "+" (tmp "Nm" ".csv"))
      (run "Prg") )
   (<href> "CSV" (tmp "Nm" ".csv")) )

(de <0> @
   (when "*CSV"
      (out @
         (prin (next))
         (while (args)
            (prin "^I" (next)) )
         (prinl "^M") ) ) )

(de <%> @
   (prog1
      (pass pack)
      (ht:Prin @)
      (prinl "<br/>")
      (<0> @) ) )

(de <!> ("Lst")
   (when "*CSV"
      (out @
         (prin (eval (cadar "Lst")))
         (for "S" (cdr "Lst")
            (prin "^I" (eval (cadr "S"))) )
         (prinl "^M") ) )
   "Lst" )

(de <+> (Str Obj Msg Tab)
   (if (sub? "^J" Str)
      (let L (split (chop Str) "^J")
         (<span> (cons 'title Str) (ht:Prin (car L)))
         (and "*CSV" (out @ (prin (glue " " L) "^I"))) )
      (<$> Str Obj Msg Tab)
      (and "*CSV" (out @ (prin Str "^I"))) ) )

(de <-> (Str Obj Msg Tab)
   (if (sub? "^J" Str)
      (let L (split (chop Str) "^J")
         (<span> (cons 'title Str) (ht:Prin (car L)))
         (<0> (glue " " L)) )
      (<$> Str Obj Msg Tab)
      (<0> Str) ) )

### HTML form ###
(de <post> (Attr Url . Prg)
   (prin
      "<form enctype=\"multipart/form-data\" action=\""
      (sesId Url)
      (and *JS "\" onkeydown=\"return formKey(event)\" onkeypress=\"return formKey(event)\" onsubmit=\"return doPost(this)")
      "\" method=\"post\">" )
   (prin "<noscript><input type=\"hidden\" name=\"*JS\" value=\"\"/></noscript>")
   (tag 'fieldset Attr 2 Prg)
   (prinl "</form>") )

(de htmlVar ("Var")
   (prin "name=\"")
   (if (pair "Var")
      (prin (car "Var") ":" (cdr "Var"))
      (prin "Var") )
   (prin "\"") )

(de htmlVal ("Var")
   (if (pair "Var")
      (cdr (assoc (cdr "Var") (val (car "Var"))))
      (val "Var") ) )

(de <label> (Attr . Prg)
   (tag 'label Attr 2 Prg) )

(de <field> (N "Var" Max Flg)
   (prin "<input type=\"text\" ")
   (htmlVar "Var")
   (prin " value=\"")
   (ht:Prin (htmlVal "Var"))
   (prin "\" size=\"")
   (if (lt0 N)
      (prin (- N) "\" style=\"text-align: right;\"")
      (prin N "\"") )
   (and Max (prin " maxlength=\"" Max "\""))
   (when *JS
      (prin " onchange=\"return fldChg(this)\"")
      (htJs) )
   (dfltCss "field")
   (and Flg (prin " disabled=\"disabled\""))
   (prinl "/>") )

(de <hidden> ("Var" Val)
   (prin "<input type=\"hidden\" ")
   (htmlVar "Var")
   (prin " value=\"")
   (ht:Prin Val)
   (prinl "\"/>") )

(de <passwd> (N "Var" Max Flg)
   (prin "<input type=\"password\" ")
   (htmlVar "Var")
   (prin " value=\"")
   (ht:Prin (htmlVal "Var"))
   (prin "\" size=\"" N "\"")
   (and Max (prin " maxlength=\"" Max "\""))
   (when *JS
      (prin " onchange=\"return fldChg(this)\"")
      (htJs) )
   (dfltCss "passwd")
   (and Flg (prin " disabled=\"disabled\""))
   (prinl "/>") )

(de <upload> (N "Var" Flg)
   (prin "<input type=\"file\" ")
   (htmlVar "Var")
   (prin " value=\"")
   (ht:Prin (htmlVal "Var"))
   (prin "\" size=\"" N "\"")
   (when *JS
      (prin " onchange=\"return fldChg(this)\"")
      (htJs) )
   (dfltCss "upload")
   (and Flg (prin " disabled=\"disabled\""))
   (prinl "/>") )

(de <rgb> ("Var" Flg)
   (prin "<input type=\"color\" ")
   (htmlVar "Var")
   (prin " value=\"")
   (ht:Prin (htmlVal "Var"))
   (prin "\"")
   (when *JS
      (prin " onchange=\"return fldChg(this)\"")
      (htJs) )
   (dfltCss "rgb")
   (and Flg (prin " disabled=\"disabled\""))
   (prinl "/>") )

(de <area> (Cols Rows "Var" Flg)
   (prin "<textarea ")
   (htmlVar "Var")
   (prin " cols=\"" Cols "\" rows=\"" Rows "\" wrap=\"off\"")
   (when *JS
      (prin " onchange=\"return fldChg(this)\"")
      (htJs) )
   (dfltCss "area")
   (and Flg (prin " disabled=\"disabled\""))
   (prin ">")
   (ht:Prin (htmlVal "Var"))
   (prinl "</textarea>") )

(de <select> (Lst "Var" Flg)
   (prin "<select ")
   (htmlVar "Var")
   (when *JS
      (prin " onchange=\"return fldChg(this)\"")
      (htJs) )
   (dfltCss "select")
   (prin ">")
   (for "X" Lst
      (let "V" (if (atom "X") "X" (car "X"))
         (prin "<option")
         (when (pair "X")
            (and (pair (cdr "X")) (htStyle (car @)))
            (and (fin "X") (prin " title=\"" @ "\"")) )
         (prin
            (cond
               ((= "V" (htmlVal "Var")) " selected=\"selected\"")
               (Flg " disabled=\"disabled\"") )
            ">" )
         (ht:Prin "V") )
      (prin "</option>") )
   (prinl "</select>") )

(de <check> ("Var" Flg)
   (let Val (htmlVal "Var")
      (prin "<input type=\"hidden\" ")
      (htmlVar "Var")
      (prin " value=\"" (and Flg Val T) "\">")
      (prin "<input type=\"checkbox\" ")
      (htmlVar "Var")
      (prin " value=\"T\"" (and Val " checked=\"checked\""))
      (when *JS
         (prin " onchange=\"return fldChg(this)\"")
         (htJs) )
      (dfltCss "check")
      (and Flg (prin " disabled=\"disabled\""))
      (prinl "/>") ) )

(de <radio> ("Var" Val Flg)
   (prin "<input type=\"radio\" ")
   (htmlVar "Var")
   (prin " value=\"")
   (ht:Prin Val)
   (prin "\"" (and (= Val (htmlVal "Var")) " checked=\"checked\""))
   (when *JS
      (prin " onchange=\"return fldChg(this)\"")
      (htJs) )
   (dfltCss "radio")
   (and Flg (prin " disabled=\"disabled\""))
   (prinl "/>") )

(de <submit> (S "Var" Flg JS)
   (prin "<input type=\"submit\"")
   (and "Var" (space) (htmlVar "Var"))
   (prin " value=\"")
   (ht:Prin S)
   (prin "\"")
   (when *JS
      (prin " onmousedown=\"inBtn(this,1)\" onblur=\"inBtn(this,0)\"")
      (and JS (prin " onclick=\"return doBtn(this)\""))
      (htJs) )
   (dfltCss "submit")
   (and Flg (prin " disabled=\"disabled\""))
   (prinl "/>") )

(de <image> (Src "Var" Flg JS)
   (prin "<input type=\"image\"")
   (and "Var" (space) (htmlVar "Var"))
   (prin " src=\"" (sesId Src) "\"")
   (when *JS
      (prin " onmousedown=\"inBtn(this,1)\" onblur=\"inBtn(this,0)\"")
      (and JS (prin " onclick=\"return doBtn(this)\""))
      (htJs) )
   (dfltCss "image")
   (and Flg (prin " disabled=\"disabled\""))
   (prinl "/>") )

(de <reset> (S Flg)
   (prin "<input type=\"reset\" value=\"")
   (ht:Prin S)
   (prin "\"")
   (dfltCss "reset")
   (and Flg (prin " disabled=\"disabled\""))
   (prinl "/>") )

# vi:et:ts=3:sw=3
