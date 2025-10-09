#### High Priority:
- [ ] **Symbolische Variablen finden, deren Wertebereiche vorhersehbar sind, deren Werte allerdings nicht**
- [ ] Was ist, wenn $x=$LLONG_MAX ? $\implies$ $u=1 \implies$ CDF-Methode funktioniert nicht, da Prädikate sagt, dass $\leq k$. Lieber bitmixing? 

- [ ] GUTES CDF GENERIERUNG (STRENG MONOTON STEIGEND = SCHWIERIG OHNE SPLINES !!!) https://aistudio.google.com/app/prompts?state=%7B%22ids%22:%5B%221PRh5yrbUjpZyWJ6r0BAhTIygRd-W32hu%22%5D,%22action%22:%22open%22,%22userId%22:%22106341829953451384930%22,%22resourceKeys%22:%7B%7D%7D&usp=sharing
	- **Können wir nicht Regression überspringen und einfach zufällige Bernstein-Parameter wählen, da es sowieso steigt => einfacher und schneller**
- [ ] Untersuchen, wie taint analysis dagegen eingesetzt werden kann

- Praxis:
	- [ ] SymExec dagegen ausprobieren
	- [ ] Andere Deobfuskationsmethoden analysieren
#### Medium Priority
- [ ] **Zufällige Prädikatenorte + zufällige T/F Prädikatenwerte (vgl. Obfuscator-LLVM)**
- [ ] **Ununterscheidbaren Code generieren**
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