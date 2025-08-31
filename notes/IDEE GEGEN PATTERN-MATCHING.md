1. Zufällige steigende Punkte machen $\in [0; 1]$
2. Über Regression eine Funktion dafür generieren
3. In Code dann linear überprüfen:
```c++
p = u // probability we want
for (int i = 0; i < n; i++) 
{
	const auto CDF_Regression []() -> void {return a1 * x^n + a2 * x^(n-1) + ... + k} // we can also obfuscate this
	if (CDF_Regression(i) > p) 
	{
		return i
	}
}
```
$\implies$ Code ist so allgemein, dass es im Grunde nur eine Schleife mit einer Bedingung ist.
$\implies$ nicht patternmatchbar

**Kleines ML-Modell bauen, um wie bei "Defeating Opaque Predicates Statically through Machine Learning and Binary Analysis" diese zu finden $\longrightarrow$ Zeigen, dass es nicht geht**

#### Alternativ: Über Verteilungsklasse verschiedene kumulative Verteilungsfunktion generieren
Problem: Limitierung auf Klasse $\implies$ hardcodebar, da limitiert
Problem: Hardcodebar, da ähnliche Konstanten vorkommen (z.B. $e, \pi,\sigma$ etc.)

#### Alternativ: Über Splines eine Funktion bauen
Problem: Nutzt man verschiedene Verteilungen $\implies$ hardcodebar, da ähnliche Konstanten vorkommen (z.B. $e, \pi,\sigma$ etc.)
Problem: Viele If-statements auffällig?

$\implies$ "Strong opaque predicates against symbolic execution, taint analysis and AI"