### main functions ### On va considérer un produit de reflexions simples (comme une liste) ?

# On va commencer par écrire une fonction qui calcule la valeur de la fonction n décrite chap 1.6 :
def n(sigma, W) : #sigma est un élément d'un groupe de Weyl W d'un système de racines
    # TODO : Trouver un moyen de vérifier que sigma appartient à W
    delta = W.simple_roots()
    pi = Set(W.positive_roots())
    minus_pi = Set(W.roots()).difference(pi)
    res = [] #liste qui contiendra l'intersection de pi et de sigma ^-1 (-pi)
    #boucle qui teste pour tout alpha dans pi si sigma(alpha) dans minus_pi, et si oui l'ajoute à res
    for alpha in pi :
        beta = sigma.action(alpha)
        if beta in minus_pi.list() :
            res += [beta]
    return len(res) #cardinal de notre ensemble

# Par un lemme des deux livres, length(sigma) = n(sigma), donc notre fonction n (que je testerai pour d'autres que A2 plus tard)
# vaut length





### tests ###
def test(n) :
    L=RootSystem(["A",n]).ambient_space()
    return L.plot(roots="all", reflection_hyperplanes=False, fundamental_weights=False).show(figsize=15)