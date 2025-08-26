#### High Priority:
- [ ] **generalisierte Wahrscheinlichkeitsverteilungsgenerierung**
	- Ist es mit Casts möglich? $\implies$ Problem bei Param == 1 !!! infinite loop






- [ ] **Symbolische Variablen finden, deren Wertebereiche vorhersehbar sind, deren Werte allerdings nicht**
- Praxis:
	- [ ] SymExec dagegen ausprobieren
	- [ ] Andere Deobfuskationsmethoden analysieren
#### Medium Priority
- [ ] Zufällige Prädikatenorte + zufällige T/F Prädikatenwerte (vgl. Obfuscator-LLVM)
- [ ] Ununterscheidbaren Code generieren
- [ ] Probabilistic Control Flows: Mehrere Branches gleich, um dynamische Attacken abzuwehren

- [ ] examples -> tests

- Experimente:
	- [ ] Beste Verteilung als Test -> Grafik
	- [ ] Sym Exec. auf IR, Angr, Triton, Miasm; Obfuskation von großen Projekten (Chrome etc. wie CodeDefender)
	- [ ] Geschwindigkeitsvergleich von Programmen
#### Low Priority:
- [ ] Retdec nutzen wie OBFUS für Support kompillierter Programme

- [ ] Zeigen, dass ML dagegen nicht funktioniert!
- [ ] CMake Linux support
- [ ] CMake Download von LLVM

- [ ] LLVM Statistics für Pass hinzufügen

- [ ] Nicht nur für Prädikate, auch Ausdrücke !?