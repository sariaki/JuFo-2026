#### High Priority (fertig):
- [ ] ~~**Symbolische Variablen finden, deren Wertebereiche vorhersehbar sind, deren Werte allerdings nicht**~~
	- ~~siehe "Probabilistic Obfuscation Through Covert Channels" !!!~~
- [ ] ~~Was ist, wenn $x=$LLONG_MAX ? $\implies$ $u=1 \implies$ CDF-Methode funktioniert nicht, da Prädikate sagt, dass $\leq k$. Lieber bitmixing?~~ 

- [ ] **Zufällige Prädikatenorte + zufällige T/F Prädikatenwerte (vgl. Obfuscator-LLVM)**
#### Medium Priority
- [ ] Untersuchen, wie taint analysis dagegen eingesetzt werden kann
- [ ] Refactoring (Einheitlicher LLVM-Datentypenzugriff, Kommentare etc.)
- [ ] Probabilistic Control Flows: Mehrere Branches gleich, um dynamische Attacken abzuwehren

- [ ] Sym Exec. auf IR, Angr, Triton, Miasm; Obfuskation von großen Projekten (Chrome etc. wie CodeDefender)
#### Low Priority:
- [ ] **Ununterscheidbaren Füllcode generieren**
- [ ] Retdec nutzen wie OBFUS für Support kompillierter Programme

- [ ] Zeigen, dass ML dagegen nicht funktioniert!

- [ ] LLVM Statistics für Pass hinzufügen

- [ ] Nicht nur für Prädikate, auch Ausdrücke !?