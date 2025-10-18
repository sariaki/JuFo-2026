1. `std::uniform_distribution(...)` oder `rand()` etc.
2. Parameter $U$ über $F^{-1}(U)$ deterministisch transformieren
3. stephensProbabilisticObfuscationCovert2018 nutzen:
   - Timing für Syscalls nutzen (vermutlich normalverteilt?) mit quasi unmöglichen constraints
   - Thread race condition für Zufallszahlgenerierung
   - if fast_process > slow_process: ...

#### ZIEL: Unbekannter Zufall -> gleichverteilter Zufall
#### Lösung:
Hashing garantiert, dass Ergebnisse uniform verteilt sind im Keyspace!
https://en.wikipedia.org/wiki/Hash_function#Overview
individual methods (e.g. time it takes for a thread to run etc.) aren't platform agnostic, but using the hashing method and the inverse CDF, i can still make statements about them on any machine