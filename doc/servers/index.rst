Overview of TDF's server layout
===============================

.. graphviz::

   digraph TDF {
      overlap = false
   	  node [fontname=Verdana,fontsize=12]
      node [style=filled]
      node [fillcolor="#EEEEEE"]
      node [color="#EEEEEE"]
      edge [color="#31CEF0", len=0.5]
      "TDF" [shape="box", color="green"]
      "MANITU" [shape="box", color="green"]
      "HETZNER" [shape="box", color="green"]
      "FILOO" [shape="box", color="green"]
      "TDF" -> "MANITU"
      "TDF" -> "HETZNER"
      "TDF" -> "FILOO"
      "FILOO" -> "monitoring"
   	"MANITU" -> "dauntless"
      "MANITU" -> "falco"
      "MANITU" -> "excelsior"
      "MANITU" -> "gustl"
      "gustl" -> "dauntless"
      "gustl" -> "excelsior"
      "gustl" -> "falco"
      "gustl" -> "juttan"
      "gustl" -> "kuleha"
      "gustl" -> "lilith"
      "gustl" -> "maggie"
      "HETZNER" -> "bilbo"
      "HETZNER" -> "pumbaa"
      "HETZNER" -> "intrepid"
      "HETZNER" -> "saber"
      "dauntless" -> "vm165"
      "dauntless" -> "vm138"
      "dauntless" -> "vm152"
      "dauntless" -> "vm159"
      "excelsior" -> "vm169"
      "excelsior" -> "vm134"
      "excelsior" -> "vm141"
      "excelsior" -> "vm144"
      "excelsior" -> "vm146"
      "excelsior" -> "vm151"
      "excelsior" -> "vm156"
      "excelsior" -> "vm161"
      "excelsior" -> "vm163"
      "excelsior" -> "vm164"
      "excelsior" -> "vm170"
      "excelsior" -> "vm166"
      "excelsior" -> "vm136"
      "falco" -> "vm150"
      "falco" -> "vm160"
      "falco" -> "vm140"
      "falco" -> "vm160"
      "falco" -> "vm148"
      "falco" -> "vm186"
      "falco" -> "vm142"
      "falco" -> "vm147"
      "falco" -> "vm143"
      "falco" -> "vm145"
      "falco" -> "vm139"
      "falco" -> "vm178"
      "falco" -> "vm137"
      "falco" -> "vm177"
   }