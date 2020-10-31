## **Algorithm to compute the closure of X under F**

### function
```python
def xplus(X, F):
    ret = {i for i in X}
    old = {}
    while old != ret:
        old = ret.copy()
        for a, b in F:
            if ret & a == a:
                ret |= b
    return ret
```

### input
```python
# Schema
S = {'ssn', 'ename', 'pnumber', 'pname', 'plocation', 'hours'}

# 3 Functional dependencies: 1st part functionally determines the 2 nd part
F = [({'ssn'}, {'ename'}), ({'pnumber', {'plocation', 'pname'}), ({'pnumber', 'ssn'}, {'hours'})]

xplus({'ssn'}, F)
xplus({'pnumber'}, F)
xplus({'ssn', 'pnumber'}, F)
```

### output
```python
{'ename', 'ssn'}
{'plocation', 'pname', 'pnumber'}
{'plocation', 'pname', 'ename', 'ssn', 'pnumber', 'hours'}
```

## **Check K is super key in F**

### function
```python
# S: Schema
def is_superkey(K, S, F):
    return xplus(K, F) == S
```

### input
```python
is_superkey({'ssn', 'pnumber'}, S, F)
is_superkey({'ssn'}, S, F)
is_superkey({'ssn', 'pnumber','ename'}, S, F)
```

### output
```python
True
False
True
```

## **Check if F covers G and check if F equivalent to G**

### function
```python
def covers(F, G):
    for a, b in G:
        if xplus(a, F) & b != b:
            return False
    return True

def equiv(F, G):
    return covers(F, G) and covers(G, F)
```

### input
```python
S1 = {'a', 'c', 'd', 'e', 'h'}

F1 = [('a'}, {'c'}), ({'e'}, {'a', 'h'})]

G1 = [({'a'}, {'c'}), ({'a', 'c'}, {'d'}), ({'e'}, {'a', 'd'}), ({'e'}, {'h'})]

S2 = {'a', 'c', 'd', 'e', 'h'}

F2 = [({'a'}, {'c', 'd'}), ({'e'}, {'a', 'h'})]

G3 = [({'a'}, {'c'}), ({'a', 'c'}, {'d'}), ({'e'}, {'a', 'd'}), ({'e'}, {'h'})]

covers(F1, G1)
covers(G1, F1)
equiv(F1, G1)

covers(F2, G2)
covers(G2, F2)
equiv(F2, G2)

```

### output
```python
False
True
False

True
True
True
```
