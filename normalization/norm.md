## **Find candidate keys**

### function
```python
import itertools import combinations

def xplus(X, F):
    ret = {i for i in X}
    old = {}
    while old != ret:
        old = ret.copy()
        for a, b in F:
            if ret & a == a:
                ret |= b
    return ret

def is_superkey(K, S, F):
    return xplus(K, F) == S

# get candidate keys
def candkey(S, F):
    key = set()
    for i in range(len(S)):
        for c in set(combinations(S, i+1)):
            if is_superkey(c, S, F):
                nxt = frozenset(c)
                flag = True
                for k in key:
                    if k & nxt == k:
                        flag = False
                        break
                if flag:
                    key.add(nxt)
    return key
```

### input
```python
S = {'ssn', 'ename', 'pnumber', 'pname', 'plocation', 'hours'}

F = [({'ssn'}, {'ename'}), ({'pnumber'}, {'plocation', 'pname'}), ({'pnumber', 'ssn'}, {'hours'})]

candkey(S ,F)
```

### output
```python
{frozenset({'ssn', 'pnumber'})}
```

### input
```python
S = {'ssn', 'ename', 'pnumber', 'pname', 'plocation', 'hours'}

F = [({'ssn'}, {'ename'}), ({'ename'}, {'ssn'}), ({'pnumber'}, {'plocation', 'pname'}), ({'pnumber', 'ssn'}, {'hours'})]

candkey(S, F)
```

### output
```python
{frozenset({'pnumber', 'ename'}), frozenset({'ssn', 'pnumber'})}
```

### input
```python
S = {'A', 'B', 'C', 'D'}

F = [({'A','B'}, {'C'}), ({'C'}, {'D'}), ({'D'}, {'A'})]

candkey(S, F)
```

### output
```python
{frozenset({'A', 'B'}), frozenset({'C', 'B'}), frozenset({'D', 'B' })}
```

### input
```python
S = {'a', 'b', 'c', 'd', 'e'}

F = [({'a', 'b'}, {'c'}), ({'d'}, {'e'}), ({'d', 'e'}, {'b'})]

candkey(S, F)
```

### output
```python
{frozenset({'d', 'a'})}
```

### input
```python
S = {'a', 'b', 'c', 'd', 'e'}

F = [({'a', 'b'}, {'c'}), ({'c', 'd'}, {'e'}), ({'d', 'e'}, {'b'})]

candkey(S, F)
```

### output
```python
{frozenset({'d', 'c', 'a'}), frozenset({'d', 'e', 'a'}), frozenset ({'d', 'b', 'a'})}
```

### input
```python
S = {'a', 'b', 'c', 'd'}

F = [({'a', 'b'}, {'c'}), ({'c'}, {'d'}), ({'d'}, {'a'})]
```

### output
```python
{frozenset({'d', 'b'}), frozenset({'b', 'a'}), frozenset({'c', 'b' })}
```

## **Check if relation schema is 3NF or BCNF**

### function
```python
def is_3nf(S, F):
    pk = set()
    for i in candkey(S, F):
        pk |= i
    for i in F:
        if not is_superkey(i[0], S, F) and i[1] & pk != i[1]:
            return False
    return True

def is_bcnf(S, F):
    for i in F:
        if not is_superkey(i[0], S, F):
            return False
    return True
```

### input
```python
S = {'ssn', 'ename', 'pnumber', 'pname', 'plocation', 'hours'}

F = [({'ssn'}, {'ename'}), ({'pnumber'}, {'plocation', 'pname'}), ({'pnumber', 'ssn'}, {'hours'})]

is_3nf(S, F)
is_bcnf(S, F)
```

### output
```python
False
False
```

### input
```python
S = {'ssn', 'pnumber', 'hours'}

F = [({'pnumber', 'ssn'}, {'hours'})]
```

### output
```python
True
True
```

### input
```python
S = {'a', 'b', 'c'}

F = [({'a'}, {'b'}), ({'b'}, {'c'})]
```

### output
```python
False
False
```

### input
```python
S = {'a', 'b', 'c'}

F = [({'a', 'b'}, {'c'}), ({'c'}, {'a'})]
```

### output
```python
True
False
```

## **Normalization to BCNF**

### function
```python
# Pretty print relations
def pp_relations(Rs):
    for S, F in Rs:
        print('Schema:\n{}'.format(S))
        print('FDs:')
        for X, Y in F:
            print('{} -> {}'.format(X, Y))
        print()

def bcnf_normalize(S, F):
    key = candkey(S, F)
    Fp = []
    Q = [S]

    while True:
        P = []
        for q in Q:
            if not is_bcnf(q, F):
                for X, Y in F:
                    f = (X, Y)
                    if X not in key and f not in Fp:
                        Xcls = xplus(X, F)
                        q -= (Xcls - X)
                        Fp.append(f)
                        P.append(Xcls)
        flag = True
        for p in P:
            if not is_bcnf(p, F):
                flag = False
        if flag:
            break
        for p in P:
            if p not in Q:
                Q.append(p)
    
    minimal = [(X, {y}) for X, Y in F for y in Y]
    
    ret = []
    for q in Q:
        t = []
        for m in minimal:
            fd = m[0] | m[1]
            if fd & q == fd:
                t.append(m)
        ret.append((q, t))
    
    return ret
```

### input
```python
S = {'a', 'c', 'd', 'e', 'h'}

F = [({'a'}, {'c','d'}), ({'e'}, {'a','h'})]

pp_relations(bcnf_normalize(S, F))
```

### output
```python
Schema:
{'a', 'h', 'e'}
FDs:
{'e'} -> {'h'}
{'e'} -> {'a'}

Schema:
{'d', 'c', 'a'}
FDs:
{'a'} -> {'d'}
{'a'} -> {'c'}
```

### input
```python
S = {'a', 'c', 'd', 'e', 'h'}

F = [({'a'}, {'c'}), ({'a','c'}, {'d'}), ({'e'}, {'a','d'}), ({'e'}, {'h'})]

pp_relations(bcnf_normalize(S, F))
```

### output
```python
Schema:
{'a', 'h', 'e'}
FDs:
{'e'} -> {'a'}
{'e'} -> {'h'}

Schema:
{'d', 'c', 'a'}
FDs:
{'a'} -> {'c'}
{'c', 'a'} -> {'d'}
```

### input
```python
S = {'ssn', 'ename', 'pnumber', 'pname', 'plocation', 'hours'}

F = [({'ssn'}, {'ename'}),
({'pnumber'}, {'plocation', 'pname'}), ({'pnumber', 'ssn'}, {'hours'})]

pp_relations(bcnf_normalize(S, F))
```

### output
```python
Schema:
{'hours', 'pnumber', 'ssn'}
FDs:
{'ssn', 'pnumber'} -> {'hours'}

Schema:
{'ssn', 'ename'}
FDs:
{'ssn'} -> {'ename'}

Schema:
{'plocation', 'pname', 'pnumber'}
FDs:
{'pnumber'} -> {'plocation'}
{'pnumber'} -> {'pname'}
```

### input
```python
S = {'a', 'b', 'c'}

F = [({'a', 'b'}, {'c'}), ({'c'}, {'a'})]

pp_relations(bcnf_normalize(S, F))
```

### output
```python
Schema:
{'b', 'c'}
FDs:

Schema:
{'c', 'a'}
FDs:
{'c'} -> {'a'}
```

### input
```python
S = {'a', 'b', 'c', 'd', 'e'}

F= [({'a','b'},{'c'}), ({'d'}, {'e'}), ({'d', 'e'}, {'b'})]

pp_relations(bcnf_normalize(S, F))
```

### output
```python
Schema:
{'d', 'a'}
FDs:

Schema:
{'b', 'a', 'c'}
FDs:
{'b', 'a'} -> {'c'}

Schema:
{'b', 'e', 'd'}
FDs:
{'d'} -> {'e'}
{'e', 'd'} -> {'b'}
```