# POP: Probabilistic Opaque Predicates Against Symbolic Execution

> This project showcases a new type of opaque predicate built to thwart symbolic execution based attacks. To achieve this, these new probabilistic opaque predicates do the following:
> 1. Select a function parameter (satisfying some [`properties`](https://github.com/sariaki/JuFo-2026/blob/main/obfuscator-pass/src/Utils/Utils.cpp#L223)) to create a symbolic variable.
> 2. Using the inverse CDF method, make the variable lie on a distribution which [`we create`](https://github.com/sariaki/JuFo-2026/blob/main/obfuscator-pass/src/Distribution-Generation/Bernsteinpolynomial.cpp).
> 3. Make probable/improbable statements about the transformed variable.
> 4. profit.
>
> Because probabilistic opaque predicates are just likely to take on a certain value but not deterministic, symbolic execution engines are unable to prove that they are opaque, i.e. prove that only one branch can be taken.
> By choosing a tiny probability of failiure (below that of an hardware error), the probabilistic opaque predicates have no practical impact on the obfuscated programs.