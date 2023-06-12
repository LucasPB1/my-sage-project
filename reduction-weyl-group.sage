### main functions ### On va considérer un produit de reflexions simples (comme une liste) ?
                        ## Fonctionne sur l'implémentation en permutation

# On va commencer par écrire une fonction qui calcule la valeur de la fonction n décrite chap 1.6 :
def n(sigma, W) : #sigma est un élément d'un groupe de Weyl W d'un système de racines
    # TODO : Trouver un moyen de vérifier que sigma appartient à W
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

def rootActionEquality(i,j,sigma,W): # Pour tester plus clairement si l'image par s_i+1, ..., s_j-1 de alpha_i est alpha_j
    return ## Peut-être que j'écrirai une fonction auxiliaire en fonction de la suite du projet

def associate_root(sigma,W):
    for alpha in W.simple_roots():
        if sigma.action(alpha) == - alpha :
            return alpha
    return -1

def deletionConditionTheorem(sigma,W): #sigma est considéré comme une liste de réflexions simples
    w = W.one()
    for s in sigma :
        w = w * s
    if n(w,W) == len(sigma): # On commence par considérer le cas où sigma est irréductible
        return sigma
    else : ## Comme len(sigma) >= n(sigma), on écrira éventuellement le cas d'erreur plus tard
        Condition1 = False
        j = 1
        while (j < len(sigma)):
            s = W.one()
            alpha = associate_root(sigma[j],W)
            i = 0
            while (i < j):
                s = s * sigma[i]
                alphaI = s.action(associate_root(sigma[j],W)) ##ERREUR ICI À CORRIGER
                Condition1 = (associate_root(sigma[i],W) == alphaI)
                if Condition1:
                    break
                i += 1
            if Condition1 :
                break
            j += 1
        return [sigma[i], sigma[j]]  #Pour faire des tests et vérifier qu'il prend les bons i et j

### tests ###
def testLength(type, nMin, nMax) :
    for i in range(nMin, nMax+1) :
        W = WeylGroup([type, i], implementation="permutation")
        print(type)
        print(i)
        L = Set(W.roots())
        for sigma in W.iteration("depth", False):
            if not(sigma.length() == n(sigma,W)):
                return False
        print("okay")
    return True

def testLength2(type, nMin, nMax) :
    for i in range(nMin, nMax+1) :
        W = WeylGroup([type, i], implementation="permutation")
        print(type)
        print(i)
        L = Set(W.roots())
        for sigma in W.iteration("depth", False):
            print(sigma)
            print(n(sigma,W))
        print("okay")

def test(type, n) :
    L=RootSystem([type,n]).ambient_space()
    return L.plot(roots="all", reflection_hyperplanes="all", fundamental_weights=False).show(figsize=15)