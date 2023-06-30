### main functions ### On va considérer un produit de reflexions simples (comme une liste) ?
                        ## Fonctionne sur l'implémentation en permutation

# On va commencer par écrire une fonction qui calcule la valeur de la fonction n décrite chap 1.6 :
def n(sigma, W) : #sigma est un élément d'un groupe de Weyl W d'un système de racines
    pi = Set(W.positive_roots())
    minus_pi = Set(W.roots()).difference(pi)
    res = [] #liste qui contiendra l'intersection de pi et de sigma ^-1 (-pi)
    #boucle qui teste pour tout alpha dans pi si sigma(alpha) dans minus_pi, et si oui l'ajoute à res
    for alpha in pi :
        beta = sigma.action(alpha)
        if beta in minus_pi.list() :
            res += [alpha]
    return len(res) #cardinal de notre ensemble

# Par un lemme des deux livres, length(sigma) = n(sigma), donc notre fonction n (que je testerai pour d'autres que A2 plus tard)
# vaut length

def rootActionEquality(i,j,sigma,W): # Pour tester plus clairement si l'image par s_i+1, ..., s_j-1 de alpha_i est alpha_j
    sigma2 = sigma.copy()
    alpha = associate_root(sigma2[j],W)
    w = constructPartialSigma(sigma2, i, j, W)
    alphaI = w.action(alpha)
    return associate_root(sigma2[i],W) == alphaI
#Non utilisé

#On écrit une fonction qui à une réflexion simple sigma 
#associe la racine simple orthogonale à l'hyperplan associé
def associate_root(sigma,W):
    for alpha in W.simple_roots():
        if sigma.action(alpha) == - alpha :
            return alpha
    return -1

#On écrit une fonction permettant la construction des
#applications partielles sigma[i+1] ... sigma[j-1]
def constructPartialSigma(sigma, i, j, W):
    w = W.one()
    for s in sigma[i+1:j]:
        w = s * w
    return w

#Fonction qui prend un produit de réflexions simples et renvoie la version 
#réduite selon le critère du théorème de condition de suppression
def deletionConditionTheorem(sigma,W):
    w = W.one()
    for s in sigma :
        w = w * s
    if n(w,W) == len(sigma):
        return sigma
    else :
        sigma2 = sigma.copy()
        for j in range(1,len(sigma2),1):
            alpha = associate_root(sigma2[j],W)
            for i in range(j):
                w = constructPartialSigma(sigma2, i, j, W)
                alphaI = w.action(alpha)
                if associate_root(sigma2[i],W) == alphaI:
                    del(sigma2[j])
                    del(sigma2[i])
                    return sigma2
        return -1
    ##Testé dans A2,A3,A4,B2,B3,G2,C3,C4,D4,D5,F4,E6,E7,E8

#Maintenant que nous avons le théorème de condition de suppression,
#on peut écrire une version récursive terminale assez naïve de la réduction
#d'un produit de réflexions simples
def reduction(sigma,W): ## Version "naïve" fonctionnelle
    l = deletionConditionTheorem2(sigma,W)
    if not(sigma == l):
        return reduction(l,W)
    else :
        return l

#On observe que certains calculs sont répétés de nombreuses fois,
#on peut donc chercher à écrire une version évitant toutes ces répétitions :
def reduction2(sigma,W) : ##Version avec moins de calculs répétés
    w = W.one()
    b = False
    sigma2 = sigma.copy()
    for s in sigma :
        w = w * s
    l = n(w,W)
    while len(sigma2) > l :
        j = 1
        while j < len(sigma2) and not(b):
            alpha = associate_root(sigma2[j],W)
            i = 0
            while i < j and not(b):
                w = constructPartialSigma(sigma2, i, j, W)
                alphaI = w.action(alpha)
                if associate_root(sigma2[i],W) == alphaI:
                    del(sigma2[j])
                    del(sigma2[i])
                    b = True
                i += 1
            j += 1
        b = False
    return sigma2

### tests et versions non abouties ###
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

def test3(sigma,W) : ##Version non aboutie avec une meilleure complexité
    w = W.one()
    b = False
    for s in sigma :
        w = w * s
    l = n(w,W)
    while len(sigma) > l :
        j = 1
        while ((j < len(sigma)) and not(b)):
            print(sigma[j])
            alpha = associate_root(sigma[j],W)
            i = 0
            while ((i < j) and (not(b))):
                w = constructPartialSigma(sigma, i, j, W)
                alphaI = w.action(alpha)
                if associate_root(sigma[i],W) == alphaI:
                    sigma.pop(j)
                    sigma.pop(i)
                    b = True
                i += 1
            j += 1
        b = False
    return sigma

def deletionConditionTheorem2(sigma,W): #sigma est considéré comme une liste de réflexions simples
    w = W.one()
    for s in sigma :
        w = w * s
    if n(w,W) == len(sigma): # On commence par considérer le cas où sigma est irréductible
        return sigma
    else : ## Comme len(sigma) >= n(sigma), on écrira éventuellement le cas d'erreur plus tard
        Condition1 = False
        j = 1
        i = 0
        while (j < len(sigma)):
            s = W.one()
            alpha = associate_root(sigma[j],W)
            i = 0
            while (i < j):
                s = s * sigma[i]
                alphaI = s.action(associate_root(sigma[j],W))
                Condition1 = (associate_root(sigma[i],W) == alphaI)
                if Condition1:
                    break
                i += 1
            if Condition1 :
                break
            j += 1
        return i,j  #sigma[j] out of range