- Crash wegen Stack Overflow.
  Vermutlich Loop für Wahrscheinlichkeitsverteilung?
  
  Test: Kleiner Lambda Wert?
  Ergebnis: Funktioniert nicht.
  
  Fazit: Stack Overflow war wegen Rekursion (wegen fehlendem Check, ob F == `sample_poisson`)
---
- Ist es mit Casts möglich? 
$\implies$ Problem bei Param x == 1 !!! infinite loop
FastMathFlags?
x=1 $\implies$ u = massiv