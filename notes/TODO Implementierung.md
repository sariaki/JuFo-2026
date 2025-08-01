#### High Priority:
- [ ] **generalisierte Wahrscheinlichkeitsverteilungsgenerierung**
- [ ] Symbolische Variablen finden, deren Werte**bereiche** vorhersehbar sind, deren Werte allerdings nicht
- Praxis:
	- [ ] SymExec dagegen ausprobieren
	- [ ] Andere Deobfuskationsmethoden analysieren
#### Medium Priority
- [x] Inline Sampler
- [ ] Zufällige Prädikatenorte + zufällige T/F Prädikatenwerte (vgl. Obfuscator-LLVM)
- [ ] Ununterscheidbaren Code generieren
- [ ] Probabilistic Control Flows: Mehrere Branches gleich, um dynamische Attacken abzuwehren

- [ ] examples -> tests

- Experimente:
	- [ ] Beste Verteilung als Test -> Grafik
	- [ ] Sym Exec. auf IR, Angr, Triton, Miasm; Obfuskation von großen Projekten (Chrome etc. wie CodeDefender)
	- [ ] Geschwindigkeitsvergleich von Programmen
#### Low Priority:
- [ ] Zeigen, dass ML dagegen nicht funktioniert!
- [ ] CMake Linux support
- [ ] CMake Download von LLVM

- [ ] LLVM Statistics für Pass hinzufügen

- [ ] Nicht nur für Prädikate, auch Ausdrücke !?