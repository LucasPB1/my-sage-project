### main functions ###
### tests ###
def test(x) :
    L=RootSystem(["A",2]).ambient_space()
    return L.plot(roots="all", reflection_hyperplanes="all", fundamental_weights=False)