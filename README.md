# Doodles
A place for all sorts of nonsense

## BigInteger
A rudimentary implementation that only supports adding at the moment :-)

## Map
<pre>
m map f == m match {
                case x :: xs => f(x) :: xs.map(f)     // f returns a single T
                case Nil => Nil
           }
</pre>

## FlatMap
<pre>
m flatMap f == m match {
                case x :: xs => f(x) ++ xs.flatMap(f)  // f returns a collection of T
                case Nil => Nil
               }
</pre>
               
## Filter
<pre>
m filter p == m match {
                case x :: xs => if p(x) x :: xs.filter(p) else xs.filter(p)
                case Nil => Nil
              }
</pre>

## Monad

`m map f == m flatMap (x => unit(f(x))`

Which is to say: for each type `m` apply function `f` and construct a new `m` with the result

A Monad type must obey the following:

. Associativity
  m flatMap f flatMap g == m flatMap (x => f(x) flatMap g)
  
 . Left Unit
  unit(x) flatMap f == f(x)
  
 . Right Unit
  m flatMap unit == m

## Example
See MonadExample.scala
