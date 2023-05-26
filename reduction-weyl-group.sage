L=RootSystem(["A",2]).ambient_space()
def n(x) :
    return L.plot(roots="all", reflection_hyperplanes="all", fundamental_weights=False)