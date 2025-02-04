
from decimal import Decimal

def fac(n):
    if n <= 1:
        return 1
    
    return fac(n - 1) * n


def e(n):
    s = Decimal.from_float(0.0)
    snew = Decimal.from_float(0.0)
    for i in range(n):
        snew = s + Decimal.from_float(1.0) / Decimal.from_float(fac(i))
        if snew == s:
            print(i)
        s = snew

    return s

print(e(80))

