"""Python library for Mathematica"""
#
GreekSymbols2Unicode = {
    "\\[Alpha]": "α",
    "\\[Beta]": "β",
    "\\[Gamma]": "γ",
    "\\[Delta]": "δ",
    "\\[Epsilon]": "ε",
    "\\[Zeta]": "ζ",
    "\\[Eta]": "η",
    "\\[Theta]": "θ",
    "\\[Iota]": "ι",
    "\\[Kappa]": "κ",
    "\\[Lambda]": "λ",
    "\\[Mu]": "μ",
    "\\[Nu]": "ν",
    "\\[Xi]": "ξ",
    "\\[Omicron]": "ο",
    "\\[Pi]": "π",
    "\\[Rho]": "ρ",
    "\\[Sigma]": "σ",
    "\\[Tau]": "τ",
    "\\[Upsilon]": "υ",
    "\\[Psi]": "φ",
    "\\[Omega]": "ω",

    "\\[CapitalAlpha]": "Α",
    "\\[CapitalBeta]": "Β",
    "\\[CapitalGamma]": "Γ",
    "\\[CapitalDelta]": "Δ",
    "\\[CapitalEpsilon]": "Ε",
    "\\[CapitalZeta]": "Ζ",
    "\\[CapitalEta]": "Η",
    "\\[CapitalTheta]": "Θ",
    "\\[CapitalIota]": "Ι",
    "\\[CapitalKappa]": "Κ",
    "\\[CapitalLambda]": "Λ",
    "\\[CapitalMu]": "Μ",
    "\\[CapitalNu]": "Ν",
    "\\[CapitalXi]": "Ξ",
    "\\[CapitalOmicron]": "Ο",
    "\\[CapitalPi]": "Π",
    "\\[CapitalRho]": "Ρ",
    "\\[CapitalSigma]": "Σ",
    "\\[CapitalTau]": "Τ",
    "\\[CapitalUpsilon]": "Υ",
    "\\[CapitalPsi]": "Φ",
    "\\[CapitalOmega]": "Χ",
}

GreekSymbols = GreekSymbols2Unicode.keys()
def LetterQ(s: str) -> bool:
    """Yields True if all the characters in the string are letters, and yields False otherwise."""
    return str.isalpha(s) or s in GreekSymbols
