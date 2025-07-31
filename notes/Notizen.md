- Crash wegen Stack Overflow.
  Vermutlich Loop für Wahrscheinlichkeitsverteilung?
  
  Test: Kleiner Lambda Wert?
  Ergebnis: Funktioniert nicht.
  
  Fazit: Stack Overflow war wegen Rekursion (wegen fehlendem Check, ob F == `sample_poisson`)